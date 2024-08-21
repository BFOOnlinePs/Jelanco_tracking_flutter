import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors.dart';
import 'package:jelanco_tracking_system/core/utils/date_utils.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/models/shared_models/menu_item_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_screen.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/task_options_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_submission_versions/task_submission_versions_screen.dart';

class SubmissionHeaderWidget extends StatelessWidget {
  final TaskSubmissionModel submissionModel;

  const SubmissionHeaderWidget(this.submissionModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(AssetsKeys.defaultProfileImage),
                // backgroundColor: Colors.grey.shade200,
                radius: 25,
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
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      MyDateUtils.formatDateTime2(submissionModel.createdAt),
                      // submissionModel.createdAt.toString() ?? '',
                      style: const TextStyle(
                        fontSize: 12,
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
              ),
            ]),
          ],
        ),
      ],
    );
  }
}
