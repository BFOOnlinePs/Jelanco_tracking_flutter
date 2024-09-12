import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/permission_mixin/permission_mixin.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/user_submission_widget.dart';
import 'package:jelanco_tracking_system/modules/user_profile_modules/cubit/user_profile_cubit.dart';
import 'package:jelanco_tracking_system/modules/user_profile_modules/cubit/user_profile_states.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
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
        create: (context) =>
            UserProfileCubit()..getUserProfileById(userId: userId),
        child: BlocConsumer<UserProfileCubit, UserProfileStates>(
          listener: (context, state) {
            if (state is UpdateProfileImageSuccessState) {
              SnackbarHelper.showSnackbar(
                  context: context,
                  snackBarStates: state.updateProfileImageModel.status == true
                      ? SnackBarStates.success
                      : SnackBarStates.error,
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
                      return userProfileCubit.getUserProfileById(
                          userId: userId);
                    },
                    child: CustomScrollView(
                      controller: userProfileCubit.scrollController,
                      slivers: [
                        SliverToBoxAdapter(
                          child: Container(
                            // padding: const EdgeInsets.all(16.0),
                            margin: const EdgeInsetsDirectional.only(
                                start: 10, end: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(20.0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsetsDirectional.all(16),
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.grey.shade300,
                                            backgroundImage: userProfileCubit
                                                        .getUserProfileByIdModel
                                                        ?.userInfo
                                                        ?.image !=
                                                    null
                                                ? NetworkImage(EndPointsConstants
                                                        .profileStorage +
                                                    userProfileCubit
                                                        .getUserProfileByIdModel!
                                                        .userInfo!
                                                        .image!)
                                                : const AssetImage(AssetsKeys
                                                        .defaultProfileImage)
                                                    as ImageProvider,
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: ColorsConstants
                                                    .primaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  userProfileCubit
                                                      .requestPermission(
                                                          context: context,
                                                          permissionType:
                                                              PermissionType
                                                                  .storage,
                                                          functionWhenGranted:
                                                              userProfileCubit
                                                                  .pickImageFromGallery);
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Icon(
                                                    Icons.camera_alt_outlined,
                                                    color: Colors.white,
                                                    size: 20, // Icon size
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      state is UpdateProfileImageLoadingState
                                          ? const Column(
                                              children: [
                                                LinearProgressIndicator(),
                                                SizedBox(height: 10),
                                              ],
                                            )
                                          : Container(),
                                      Text(
                                        userProfileCubit.getUserProfileByIdModel
                                                ?.userInfo?.name ??
                                            '',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey[800],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),

                                      const SizedBox(height: 5),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.addressCard,
                                            color: Colors.blueGrey[400],
                                            size: 20,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            userProfileCubit
                                                    .getUserProfileByIdModel
                                                    ?.userInfo
                                                    ?.jobTitle ??
                                                '',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blueGrey[600],
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 5),

                                      // Email
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.envelope,
                                            color: Colors.blueGrey[400],
                                            size: 20,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            userProfileCubit
                                                    .getUserProfileByIdModel
                                                    ?.userInfo
                                                    ?.email ??
                                                '',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blueGrey[400],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Positioned(
                                //   top: -10,
                                //   right: 0,
                                //   child: MyTextButtonNoBorder(
                                //     onPressed: () {},
                                //     child: const Text('تعديل الملف الشخصي'),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index ==
                                      userProfileCubit
                                          .userProfileSubmissionsList.length &&
                                  !userProfileCubit
                                      .isProfileSubmissionsLastPage) {
                                if (!userProfileCubit
                                    .isProfileSubmissionsLoading) {
                                  userProfileCubit.getUserProfileById(
                                    userId: userId,
                                    page: userProfileCubit
                                            .getUserProfileByIdModel!
                                            .userSubmissions!
                                            .pagination!
                                            .currentPage! +
                                        1,
                                  );
                                }
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }
                              final submission = userProfileCubit
                                  .userProfileSubmissionsList[index];
                              return UserSubmissionWidget(
                                  submission: submission,
                                  userProfileCubit: userProfileCubit);
                            },
                            childCount: userProfileCubit
                                    .userProfileSubmissionsList.length +
                                (userProfileCubit.isProfileSubmissionsLastPage
                                    ? 0
                                    : 1),
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
