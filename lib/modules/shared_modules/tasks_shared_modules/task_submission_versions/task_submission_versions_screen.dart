import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/content_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_media_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_time_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_submission_versions/task_submission_versions_cubit/task_submission_versions_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_submission_versions/task_submission_versions_cubit/task_submission_versions_states.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
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
            return SingleChildScrollView(
              child: Column(
                children: taskSubmissionVersionsCubit
                            .getTaskSubmissionVersionsModel !=
                        null
                    ? taskSubmissionVersionsCubit
                        .getTaskSubmissionVersionsModel!.submissionsVersions!
                        .map((submission) {
                        return Column(
                          children: [
                            ContentWidget(submission.tsContent ?? '',
                                isSubmission: true),
                            SubmissionMediaWidget(
                              submission: submission,
                            ),
                            const MyVerticalSpacer(),
                            SubmissionTimeWidget(submission: submission),
                            const MyVerticalSpacer(),
                          ],
                        );
                      }).toList()
                    : [const Center(child: MyLoader())],
              ),
            );
          },
        ),
      ),
    );
  }
}
