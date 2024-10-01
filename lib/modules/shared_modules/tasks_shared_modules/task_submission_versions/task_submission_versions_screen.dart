import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/content_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_header_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/media_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_time_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_submission_versions/task_submission_versions_cubit/task_submission_versions_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_submission_versions/task_submission_versions_cubit/task_submission_versions_states.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';

class TaskSubmissionVersionsScreen extends StatelessWidget {
  final int taskSubmissionId;

  TaskSubmissionVersionsScreen({super.key, required this.taskSubmissionId});

  late TaskSubmissionVersionsCubit taskSubmissionVersionsCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'تعديلات التسليم',
      ),
      body: BlocProvider(
        create: (context) => TaskSubmissionVersionsCubit()
          ..getTaskSubmissionVersions(taskSubmissionId: taskSubmissionId),
        child: BlocConsumer<TaskSubmissionVersionsCubit,
            TaskSubmissionVersionsStates>(
          listener: (context, state) {},
          builder: (context, state) {
            taskSubmissionVersionsCubit =
                TaskSubmissionVersionsCubit.get(context);
            return MyScreen(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: taskSubmissionVersionsCubit
                              .getTaskSubmissionVersionsModel !=
                          null
                      ? taskSubmissionVersionsCubit
                          .getTaskSubmissionVersionsModel!.submissionsVersions!
                          .map((submission) {
                          return Column(
                            children: [
                              SubmissionHeaderWidget(
                                submissionModel: submission,
                                showSubmissionOptions: false,
                              ),
                              ContentWidget(submission.tsContent ?? '',
                                  isSubmission: true),
                              MediaWidget(
                                attachmentsCategories:
                                    submission.submissionAttachmentsCategories!,
                                storagePath:
                                    EndPointsConstants.taskSubmissionsStorage,
                              ),
                              const MyVerticalSpacer(),
                              SubmissionTimeWidget(submission: submission),
                              const MyVerticalSpacer(),
                            ],
                          );
                        }).toList()
                      : [const Center(child: MyLoader())],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
