import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/user_card_widget.dart';
import 'package:jelanco_tracking_system/modules/users_management_modules/add_edit_user_modules/add_edit_user_screen.dart';
import 'package:jelanco_tracking_system/modules/users_management_modules/cubit/users_management_cubit.dart';
import 'package:jelanco_tracking_system/modules/users_management_modules/cubit/users_management_states.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_floating_action_button.dart';
import 'package:jelanco_tracking_system/widgets/my_refresh_indicator/my_refresh_indicator.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_title_screen/my_title_screen_widget.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';

class UsersManagementScreen extends StatelessWidget {
  const UsersManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersManagementCubit()
        ..getAllUsers(
          pagination: 1,
          loadingState: GetAllUsersLoadingState(),
          successState: GetAllUsersSuccessState(),
          errorState: (error) => GetAllUsersErrorState(),
        ),
      child: BlocConsumer<UsersManagementCubit, UsersManagementStates>(
        listener: (context, state) {},
        builder: (context, state) {
          UsersManagementCubit usersManagementCubit = UsersManagementCubit.get(context);
          return Scaffold(
            appBar: const MyAppBar(
              title: 'إدارة الموظفين',
            ),
            body: MyScreen(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyTextFormField(
                      labelText: 'إبحث عن موظف',
                      onChanged: (value) {
                        usersManagementCubit.getAllUsers(
                          search: value,
                          pagination: 1,
                          loadingState: GetAllUsersLoadingState(),
                          successState: GetAllUsersSuccessState(),
                          errorState: (error) => GetAllUsersErrorState(),
                        );
                      },
                      prefixIcon: const Icon(Icons.search),
                      controller: usersManagementCubit.searchController,
                    ),
                    usersManagementCubit.getAllUsersModel == null
                        ? const MyLoader()
                        : Expanded(
                            child: MyRefreshIndicator(
                              onRefresh: () async {
                                await usersManagementCubit.getAllUsers(
                                  pagination: 1,
                                  loadingState: GetAllUsersLoadingState(),
                                  successState: GetAllUsersSuccessState(),
                                  errorState: (error) => GetAllUsersErrorState(),
                                );
                              },
                              child: usersManagementCubit.usersList.isEmpty
                                  ? const Center(child: Text('لا يوجد موظفين'))
                                  : ListView.builder(
                                      itemCount: usersManagementCubit.usersList.length + (usersManagementCubit.isUsersLastPage ? 0 : 1),
                                      itemBuilder: (context, index) {
                                        if (index == usersManagementCubit.usersList.length && !usersManagementCubit.isUsersLastPage) {
                                          if (!usersManagementCubit.isUsersLoading) {
                                            usersManagementCubit.getAllUsers(
                                              search: usersManagementCubit.searchController.text,
                                              page: usersManagementCubit.getAllUsersModel!.pagination!.currentPage! + 1,
                                              pagination: 1,
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
                                        return UserCardWidget(
                                          userModel: usersManagementCubit.usersList[index],
                                          showEditButton: true,
                                        );
                                      }),
                            ),
                          )
                  ],
                ),
              ),
            ),
            floatingActionButton: MyFloatingActionButton(
                icon: Icons.add,
                labelText: 'إضافة موظف',
                onPressed: () {
                  NavigationServices.navigateTo(context, const AddEditUserScreen());
                }),
          );
        },
      ),
    );
  }
}
