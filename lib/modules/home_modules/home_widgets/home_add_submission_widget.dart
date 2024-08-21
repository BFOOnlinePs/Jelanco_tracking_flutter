import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/text_form_field_size.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_screen.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/media_option_widget.dart';

class HomeAddSubmissionWidget extends StatelessWidget {
  const HomeAddSubmissionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // task id = -1, since the submission has no task
        NavigationServices.navigateTo(
            context, AddTaskSubmissionScreen(taskId: -1));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 7),
        color: Colors.grey.shade300,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            // border: Border.all(),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsetsDirectional.only(end: 12),
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage(AssetsKeys.defaultProfileImage),
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
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'مطور برمجيات فلاتر',
                                style: TextStyle(
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
                // onTap: (){
                //   // task id = -1, since the submission has no task
                //   NavigationServices.navigateTo(
                //       context, AddTaskSubmissionScreen(taskId: -1));
                // },
                enabled: false,
                decoration: InputDecoration(
                  isDense: true,
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(
                        TextFormFieldSizeConstants.borderRadius),
                  ),
                  // Reduces the overall height and padding
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  hintText: "ماذا فعلت اليوم؟",
                ),
              ),

              Divider(
                thickness: 0.2,
              ),

              // Media Options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MediaOptionWidget(
                    icon: Icons.image,
                    label: 'صورة',
                    color: Colors.green,
                    onTap: () {
                      NavigationServices.navigateTo(
                          context, AddTaskSubmissionScreen(taskId: -1));
                    },
                  ),
                  Container(width: 0.2, height: 26, color: Colors.grey),
                  MediaOptionWidget(
                    icon: Icons.video_camera_back,
                    label: 'فيديو',
                    color: Colors.red,
                    onTap: () {
                      NavigationServices.navigateTo(
                          context, AddTaskSubmissionScreen(taskId: -1));
                    },
                  ),
                  Container(width: 0.2, height: 26, color: Colors.grey),
                  MediaOptionWidget(
                    icon: Icons.attach_file,
                    label: 'ملف',
                    color: Colors.blue,
                    onTap: () {
                      NavigationServices.navigateTo(
                          context, AddTaskSubmissionScreen(taskId: -1));
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
