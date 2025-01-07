import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/user_permissions_management_modules/cubit/user_permissions_management_cubit.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/user_permissions_management_modules/cubit/user_permissions_management_states.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/user_permissions_management_modules/user_name_and_roles_widget.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/user_permissions_management_modules/user_roles_and_permissions_management_modules/user_roles_and_permissions_management_screen.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_refresh_indicator/my_refresh_indicator.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';

class UserPermissionsManagementScreen extends StatelessWidget {
  final int? userId;

  UserPermissionsManagementScreen({super.key, this.userId});

  late UserPermissionsManagementCubit userPermissionsManagementCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserPermissionsManagementCubit()..getInitialData(),
      child: BlocConsumer<UserPermissionsManagementCubit, UserPermissionsManagementStates>(
        listener: (context, state) {
          if (state is GetInitialDataSuccessState && userId != null) {
            print('navigate to roles and permissions');

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: userPermissionsManagementCubit,
                  child: UserRolesAndPermissionsManagementScreen(
                    user: userPermissionsManagementCubit.usersList.firstWhere((element) => element.id == userId),
                    userPermissionsManagementCubit: userPermissionsManagementCubit,
                  ),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          userPermissionsManagementCubit = UserPermissionsManagementCubit.get(context);

          return Scaffold(
            appBar: const MyAppBar(title: 'إدارة صلاحيات المستخدمين'),
            body: MyScreen(
              child: Column(
                children: [
                  MyTextFormField(
                    labelText: 'إبحث عن موظف',
                    onChanged: (value) {
                      userPermissionsManagementCubit.getAllUsers(
                        search: value,
                        pagination: 1,
                        isRole: 1,
                        loadingState: GetAllUsersLoadingState(),
                        successState: GetAllUsersSuccessState(),
                        errorState: (error) => GetAllUsersErrorState(),
                      );
                    },
                    prefixIcon: const Icon(Icons.search),
                    controller: userPermissionsManagementCubit.searchController,
                  ),
                  Expanded(
                    child: userPermissionsManagementCubit.getAllUsersModel == null
                        ? const Center(child: MyLoader())
                        : MyRefreshIndicator(
                            onRefresh: () async {
                              await userPermissionsManagementCubit.getAllUsers(
                                pagination: 1,
                                isRole: 1,
                                loadingState: GetAllUsersLoadingState(),
                                successState: GetAllUsersSuccessState(),
                                errorState: (error) => GetAllUsersErrorState(),
                              );
                            },
                            child: ListView.builder(
                              itemCount: userPermissionsManagementCubit.usersList.length +
                                  (userPermissionsManagementCubit.isUsersLastPage ? 0 : 1),
                              itemBuilder: (context, index) {
                                if (index == userPermissionsManagementCubit.usersList.length &&
                                    !userPermissionsManagementCubit.isUsersLastPage) {
                                  if (!userPermissionsManagementCubit.isUsersLoading) {
                                    userPermissionsManagementCubit.getAllUsers(
                                      search: userPermissionsManagementCubit.searchController.text,
                                      page: userPermissionsManagementCubit.getAllUsersModel!.pagination!.currentPage! + 1,
                                      pagination: 1,
                                      isRole: 1,
                                      loadingState: GetAllUsersLoadingState(),
                                      successState: GetAllUsersSuccessState(),
                                      errorState: (error) => GetAllUsersErrorState(),
                                    );
                                  }
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(child: MyLoader()),
                                  );
                                }
                                return GestureDetector(
                                    child: UserNameAndRoleWidget(
                                  user: userPermissionsManagementCubit.usersList[index],
                                  onTap: () {
                                    // userPermissionsManagementCubit.usersList[index].roles =
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider.value(
                                          value: userPermissionsManagementCubit,
                                          child: UserRolesAndPermissionsManagementScreen(
                                            user: userPermissionsManagementCubit.usersList[index],
                                            userPermissionsManagementCubit: userPermissionsManagementCubit,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ));
                              },
                            ),
                          ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
