import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/constants/text_form_field_size.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/core/utils/scroll_utils.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_screen.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_cubit.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_states.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/media_option_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_cached_network_image/my_cached_image_builder.dart';
import 'package:jelanco_tracking_system/widgets/my_cached_network_image/my_cached_network_image.dart';

class HomeAddSubmissionWidget extends StatelessWidget {
  final HomeCubit homeCubit;

  const HomeAddSubmissionWidget({super.key, required this.homeCubit});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigationServices.navigateTo(
          context,
          AddTaskSubmissionScreen(
            getDataCallback: (taskSubmissionModel) {
              print('call the data');
              homeCubit.getUserSubmissions();
              homeCubit.getTasksToSubmit(
                perPage: 3,
                loadingState: GetTasksToSubmitLoadingState(),
                successState: GetTasksToSubmitSuccessState(),
                errorState: (error) => GetTasksToSubmitErrorState(error),
              );
              ScrollUtils.scrollPosition(
                  scrollController: homeCubit.scrollController);
            },
            taskId: -1, // task id = -1, since the submission has no task
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.w),
        color: Colors.grey.shade300,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsetsDirectional.only(end: 12.w),
                      child: CircleAvatar(
                        radius: 24.w,
                        backgroundColor: Colors.grey[300],
                        // Optional, for better visibility if image is not loaded
                        child: UserDataConstants.image != null
                            ? MyCachedNetworkImage(
                                imageUrl: EndPointsConstants.profileStorage +
                                    UserDataConstants.image!,
                                imageBuilder: (context, imageProvider) =>
                                    MyCachedImageBuilder(
                                        imageProvider: imageProvider),
                          isCircle: true,
                              )
                            : Image.asset(
                                AssetsKeys.defaultProfileImage,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                UserDataConstants.name ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Text(
                                UserDataConstants.jobTitle ?? '',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  isDense: true,
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(
                        TextFormFieldSizeConstants.borderRadius),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5.w, horizontal: 10.w),
                  hintText: "ماذا فعلت اليوم؟",
                ),
              ),
              Divider(
                thickness: 0.2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const MediaOptionWidget(
                    icon: Icons.camera_alt,
                    label: 'كاميرا',
                    color: Colors.blue,
                    onTap: null,
                  ),
                  Container(width: 0.2.w, height: 26.h, color: Colors.grey),
                  const MediaOptionWidget(
                    icon: Icons.image,
                    label: 'صورة',
                    color: Colors.green,
                    onTap: null,
                  ),
                  Container(width: 0.2.w, height: 26.h, color: Colors.grey),
                  const MediaOptionWidget(
                    icon: Icons.video_camera_back,
                    label: 'فيديو',
                    color: Colors.red,
                    onTap: null,
                  ),
                  Container(width: 0.2.w, height: 26.h, color: Colors.grey),
                  const MediaOptionWidget(
                    icon: Icons.attach_file,
                    label: 'ملف',
                    color: Colors.blue,
                    onTap: null,
                  ),
                ],
              ),
              SizedBox(
                height: 6.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
