import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_cubit/add_task_cubit.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_cubit/add_task_states.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/user_permissions_management_modules/user_name_and_roles_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/check_box_user_widget.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_refresh_indicator/my_refresh_indicator.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';

class AllUsersSelectionScreen extends StatelessWidget {
  final AddTaskCubit addTaskCubit;

  const AllUsersSelectionScreen({super.key, required this.addTaskCubit});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddTaskCubit, AddTaskStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: const MyAppBar(title: 'الجهات المعنية'),
          body: MyScreen(
            child: Column(
              children: [
                MyTextFormField(
                  labelText: 'إبحث عن موظف',
                  onChanged: (value) {
                    addTaskCubit.getAllUsers(
                      search: value,
                      pagination: 1,
                      loadingState: GetAllUsersLoadingState(),
                      successState: GetAllUsersSuccessState(),
                      errorState: (error) => GetAllUsersErrorState(),
                    );
                  },
                  prefixIcon: const Icon(Icons.search),
                  controller: addTaskCubit.searchController,
                ),
                Expanded(
                  child: addTaskCubit.getAllUsersModel == null
                      ? const Center(child: MyLoader())
                      : MyRefreshIndicator(
                          onRefresh: () async {
                            await addTaskCubit.getAllUsers(
                              pagination: 1,
                              loadingState: GetAllUsersLoadingState(),
                              successState: GetAllUsersSuccessState(),
                              errorState: (error) => GetAllUsersErrorState(),
                            );
                          },
                          child: ListView.separated(
                            itemCount: addTaskCubit.usersList.length + (addTaskCubit.isUsersLastPage ? 0 : 1),
                            itemBuilder: (context, index) {
                              if (index == addTaskCubit.usersList.length && !addTaskCubit.isUsersLastPage) {
                                if (!addTaskCubit.isUsersLoading) {
                                  addTaskCubit.getAllUsers(
                                    search: addTaskCubit.searchController.text,
                                    page: addTaskCubit.getAllUsersModel!.pagination!.currentPage! + 1,
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
                              return CheckBoxUserWidget(
                                user: addTaskCubit.usersList[index],
                                value: addTaskCubit.selectedInterestedParties.contains(addTaskCubit.usersList[index]),
                                onChanged: (value) {
                                  addTaskCubit.toggleSelectedInterestedParties(addTaskCubit.usersList[index]);
                                },
                              );
                            },
                            separatorBuilder: (context, index) => const Divider(),
                          ),
                        ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
