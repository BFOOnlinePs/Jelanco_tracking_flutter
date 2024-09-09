import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/core/utils/date_utils.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/models/shared_models/menu_item_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_screen.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/task_options_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_location_dialog.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_submission_details_screen/cubit/task_submission_details_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_submission_versions/task_submission_versions_screen.dart';

class SubmissionHeaderWidget extends StatelessWidget {
  TaskSubmissionModel submissionModel;
  final HomeCubit? homeCubit;
  final TaskDetailsCubit? taskDetailsCubit;
  final TaskSubmissionDetailsCubit? taskSubmissionDetailsCubit;

  SubmissionHeaderWidget({
    super.key,
    required this.submissionModel,
    this.homeCubit,
    this.taskDetailsCubit,
    this.taskSubmissionDetailsCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // add border
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 0.5),
                ),
                padding: EdgeInsets.all(2),
                child: Image(
                  image: AssetImage(AssetsKeys.defaultProfileImage),
                  height: 34,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${submissionModel.submitterUser?.name}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      MyDateUtils.formatDateTimeWithAmPm(
                          submissionModel.createdAt),
                      // MyDateUtils.formatDateTime2(submissionModel.createdAt),
                      // submissionModel.createdAt.toString() ?? '',
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            TaskOptionsWidget(menuItems: [
              MenuItemModel(
                icon: Icons.edit,
                label: 'تعديل',
                onTap: () {
                  NavigationServices.navigateTo(
                    context,
                    AddTaskSubmissionScreen(
                      taskId: submissionModel.tsTaskId!,
                      taskSubmissionModel: submissionModel,
                      isEdit: true,
                      getDataCallback: (newSubmissionModel) {
                        // shared with 3 screens (task details screen, submission details screen and home user submissions screen)
                        // to edit the submission
                        if (homeCubit != null) {
                          homeCubit!.afterEditSubmission(
                              oldSubmissionId: submissionModel.tsId!,
                              newSubmissionModel: newSubmissionModel);
                        } else if (taskDetailsCubit != null) {
                          taskDetailsCubit!.afterEditSubmission(
                              oldSubmissionId: submissionModel.tsId!,
                              newSubmissionModel: newSubmissionModel);
                        } else if (taskSubmissionDetailsCubit != null) {
                          taskSubmissionDetailsCubit!.afterEditSubmission(
                              newSubmissionModel: newSubmissionModel);
                        }
                      },
                    ),
                  );
                },
              ),
              MenuItemModel(
                icon: Icons.history,
                label: 'عرض التعديلات',
                onTap: () {
                  NavigationServices.navigateTo(
                    context,
                    TaskSubmissionVersionsScreen(
                      taskSubmissionId: submissionModel.tsId!,
                    ),
                  );
                },
              ), //
            ]),
            GestureDetector(
                onTap: () {
                  // NavigationServices.navigateTo(context, SubmissionLocationDialog(
                  //   taskSubmissionModel: submissionModel,
                  // ));
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SubmissionLocationDialog(
                        taskSubmissionModel: submissionModel,
                      );
                    },
                  );
                },
                child: Icon(Icons.location_on))
          ],
        ),
      ],
    );
  }
}
