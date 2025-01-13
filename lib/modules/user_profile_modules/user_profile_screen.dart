import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/permission_mixin/permission_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/enums/system_permissions.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_screen.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/user_submission_widget.dart';
import 'package:jelanco_tracking_system/modules/user_profile_modules/cubit/user_profile_cubit.dart';
import 'package:jelanco_tracking_system/modules/user_profile_modules/cubit/user_profile_states.dart';
import 'package:jelanco_tracking_system/modules/user_profile_modules/user_profile_widgets/profile_card_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_bars/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_floating_action_button.dart';
import 'package:jelanco_tracking_system/widgets/my_refresh_indicator/my_refresh_indicator.dart';
import 'package:jelanco_tracking_system/widgets/snack_bar/my_snack_bar.dart';

class UserProfileScreen extends StatelessWidget {
  final int userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
          // title: 'اسم صاحب الملف الشخصي',
          ),
      body: BlocProvider(
        create: (context) => UserProfileCubit()..getUserProfileById(userId: userId),
        child: BlocConsumer<UserProfileCubit, UserProfileStates>(
          listener: (context, state) {
            if (state is UpdateProfileImageSuccessState) {
              SnackbarHelper.showSnackbar(
                  context: context,
                  snackBarStates: state.updateProfileImageModel.status == true ? SnackBarStates.success : SnackBarStates.error,
                  message: state.updateProfileImageModel.message);
            }
          },
          builder: (context, state) {
            UserProfileCubit userProfileCubit = UserProfileCubit.get(context);

            return userProfileCubit.getUserProfileByIdModel == null
                ? const Center(
                    child: MyLoader(),
                  )
                : MyRefreshIndicator(
                    onRefresh: () {
                      return userProfileCubit.getUserProfileById(userId: userId);
                    },
                    child: CustomScrollView(
                      controller: userProfileCubit.scrollController,
                      slivers: [
                        SliverToBoxAdapter(
                          child: state is UpdateProfileImageLoadingState
                              ? const Column(
                                  children: [
                                    LinearProgressIndicator(),
                                  ],
                                )
                              : Container(),
                        ),
                        SliverToBoxAdapter(
                          child: ProfileCardWidget(
                            userInfo: userProfileCubit.getUserProfileByIdModel!.userInfo!,
                            onTapChangeProfilePic: () {
                              userProfileCubit.requestPermission(
                                  context: context,
                                  permissionType: PermissionType.storage,
                                  functionWhenGranted: userProfileCubit.pickImageFromGallery);
                            },
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index == userProfileCubit.userProfileSubmissionsList.length &&
                                  !userProfileCubit.isProfileSubmissionsLastPage) {
                                if (!userProfileCubit.isProfileSubmissionsLoading) {
                                  userProfileCubit.getUserProfileById(
                                    userId: userId,
                                    page: userProfileCubit.getUserProfileByIdModel!.userSubmissions!.pagination!.currentPage! + 1,
                                  );
                                }
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(child: MyLoader()),
                                );
                              }
                              final submission = userProfileCubit.userProfileSubmissionsList[index];
                              return UserSubmissionWidget(submission: submission, userProfileCubit: userProfileCubit);
                            },
                            childCount: userProfileCubit.userProfileSubmissionsList.length +
                                (userProfileCubit.isProfileSubmissionsLastPage ? 0 : 1),
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),

      // if the current user can assign task to this user
      floatingActionButton: SystemPermissions.hasPermission(SystemPermissions.addTask) &&
              (UserDataConstants.userEmployeeIds?.any((empId) => empId == userId) ?? false)
          ? MyFloatingActionButton(
              onPressed: () {
                NavigationServices.navigateTo(
                  context,
                  AddTaskScreen(
                    initialSelectedUserId: userId,
                  ),
                );
              },
              labelText: 'إضافة تكليف',
              icon: Icons.add_task,
            )
          : Container(),
    );
  }
}
