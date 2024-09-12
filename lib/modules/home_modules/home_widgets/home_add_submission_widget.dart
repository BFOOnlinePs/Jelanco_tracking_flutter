import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
        color: Colors.grey.shade300,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsetsDirectional.only(end: 12),
                      child: CircleAvatar(
                        backgroundImage: UserDataConstants.image != null
                            ? NetworkImage(EndPointsConstants.profileStorage +
                                UserDataConstants.image!)
                            : const AssetImage(AssetsKeys.defaultProfileImage)
                                as ImageProvider,
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                UserDataConstants.jobTitle ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
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
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  hintText: "ماذا فعلت اليوم؟",
                ),
              ),
              const Divider(
                thickness: 0.2,
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
                  Container(width: 0.2, height: 26, color: Colors.grey),
                  const MediaOptionWidget(
                    icon: Icons.image,
                    label: 'صورة',
                    color: Colors.green,
                    onTap: null,
                  ),
                  Container(width: 0.2, height: 26, color: Colors.grey),
                  const MediaOptionWidget(
                    icon: Icons.video_camera_back,
                    label: 'فيديو',
                    color: Colors.red,
                    onTap: null,
                  ),
                  Container(width: 0.2, height: 26, color: Colors.grey),
                  const MediaOptionWidget(
                    icon: Icons.attach_file,
                    label: 'ملف',
                    color: Colors.blue,
                    onTap: null,
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
