import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_widgets/all_users_selection_modules/cubit/all_users_selection_cubit.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_widgets/all_users_selection_modules/cubit/all_users_selection_states.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/check_box_user_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_bars/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/loader_with_disable.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_refresh_indicator/my_refresh_indicator.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/snack_bar/my_snack_bar.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';

class AllUsersSelectionScreen extends StatelessWidget {
  List<int>? selectedUsersList = [];
  List<int>? usersCanNotEdit = []; // the list of users where the current user can't edit
  bool? callInterestedParties = false;
  String? articleType;
  int? articleId;

  AllUsersSelectionScreen(
      {super.key, this.selectedUsersList, this.usersCanNotEdit, this.callInterestedParties, this.articleType, this.articleId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllUsersSelectionCubit()
        ..initialValues(
          initialSelectedUserIds: selectedUsersList ?? [],
          callInterestedParties: callInterestedParties ?? false,
          articleType: articleType,
          articleId: articleId,
        ),
      child: BlocConsumer<AllUsersSelectionCubit, AllUsersSelectionStates>(
        listener: (context, state) {
          if (state is HandleInterestedPartiesSuccessState) {
            SnackbarHelper.showSnackbar(
              context: context,
              snackBarStates:
                  state.handleInterestedPartiesStatusMessageModel.status == true ? SnackBarStates.success : SnackBarStates.error,
              message: state.handleInterestedPartiesStatusMessageModel.message,
            );
            if (state.handleInterestedPartiesStatusMessageModel.status == true) {
              Navigator.pop(context);
            }
          }
        },
        builder: (context, state) {
          AllUsersSelectionCubit allUsersSelectionCubit = AllUsersSelectionCubit.get(context);
          return Stack(
            children: [
              Scaffold(
                appBar: const MyAppBar(title: 'الإشارات والوسوم'),
                body: MyScreen(
                  child: Column(
                    children: [
                      MyTextFormField(
                        labelText: 'إبحث عن موظف',
                        onChanged: (value) {
                          allUsersSelectionCubit.getAllUsers(
                            search: value,
                            pagination: 1,
                            loadingState: GetAllUsersLoadingState(),
                            successState: GetAllUsersSuccessState(),
                            errorState: (error) => GetAllUsersErrorState(),
                          );
                        },
                        prefixIcon: const Icon(Icons.search),
                        controller: allUsersSelectionCubit.searchController,
                      ),
                      Expanded(
                        child: allUsersSelectionCubit.getAllUsersModel == null
                            ? const Center(child: MyLoader())
                            : MyRefreshIndicator(
                                onRefresh: () async {
                                  await allUsersSelectionCubit.getAllUsers(
                                    pagination: 1,
                                    loadingState: GetAllUsersLoadingState(),
                                    successState: GetAllUsersSuccessState(),
                                    errorState: (error) => GetAllUsersErrorState(),
                                  );
                                },
                                child: ListView.separated(
                                  itemCount: allUsersSelectionCubit.usersList.length + (allUsersSelectionCubit.isUsersLastPage ? 0 : 1),
                                  itemBuilder: (context, index) {
                                    if (index == allUsersSelectionCubit.usersList.length && !allUsersSelectionCubit.isUsersLastPage) {
                                      if (!allUsersSelectionCubit.isUsersLoading) {
                                        allUsersSelectionCubit.getAllUsers(
                                          search: allUsersSelectionCubit.searchController.text,
                                          page: allUsersSelectionCubit.getAllUsersModel!.pagination!.currentPage! + 1,
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
                                        user: allUsersSelectionCubit.usersList[index],
                                        // value: allUsersSelectionCubit.selectedUsers.contains(allUsersSelectionCubit.usersList[index]),
                                        value: allUsersSelectionCubit.selectedUsers
                                            .any((selectedUser) => selectedUser.id == allUsersSelectionCubit.usersList[index].id),
                                        onChanged: (value) {
                                          allUsersSelectionCubit.toggleSelectedUsers(allUsersSelectionCubit.usersList[index].id!);
                                        },
                                        enabled: callInterestedParties == true
                                            ? !allUsersSelectionCubit.usersCanNotEdit!.contains(allUsersSelectionCubit.usersList[index].id)
                                            : usersCanNotEdit != null
                                                ? !usersCanNotEdit!.contains(allUsersSelectionCubit.usersList[index].id)
                                                : true);
                                  },
                                  separatorBuilder: (context, index) => const Divider(),
                                ),
                              ),
                      ) 
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    if (callInterestedParties == true) {
                      allUsersSelectionCubit.handleInterestedParties(
                          articleType: articleType!,
                          articleId: articleId!,
                          interestedParties: allUsersSelectionCubit.selectedUsers.map((user) => user.id!).toList(),
                          loadingState: HandleInterestedPartiesLoadingState(),
                          successState: (value) => HandleInterestedPartiesSuccessState(value),
                          errorState: HandleInterestedPartiesErrorState());
                    } else {
                      Navigator.pop(context, allUsersSelectionCubit.selectedUsers);
                    }
                  },
                  child: const Icon(Icons.check),
                ),
              ),
              if (state is HandleInterestedPartiesLoadingState) const LoaderWithDisable()
            ],
          );
        },
      ),
    );
  }
}
