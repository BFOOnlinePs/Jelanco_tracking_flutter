import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/colors.dart';
import 'package:jelanco_tracking_system/core/utils/date_utils.dart';
import 'package:jelanco_tracking_system/enums/task_status_enum.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_states.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';

import '../../../../models/basic_models/submission_comment_model.dart';

class TaskDetailsScreen extends StatelessWidget {
  final int taskId;
  late TaskDetailsCubit taskDetailsCubit;

  TaskDetailsScreen({required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Task Details',
      ),
      body: BlocProvider(
        create: (context) => TaskDetailsCubit()
          ..getTaskWithSubmissionsAndComments(taskId: taskId),
        child: BlocConsumer<TaskDetailsCubit, TaskDetailsStates>(
          listener: (context, state) {},
          builder: (context, state) {
            taskDetailsCubit = TaskDetailsCubit.get(context);
            return taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel ==
                    null
                ? Center(
                    child: MyLoader(),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTaskDetailsSection(),
                        MyVerticalSpacer(),
                        MyVerticalSpacer(),
                        taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!
                                .task!.taskSubmissions!.isNotEmpty
                            ? _buildSubmissionsSection()
                            : Container(),
                      ],
                    ),
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add action for adding a new submission
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: ColorsConstants.primaryColor,
      ),
    );
  }

  Widget _buildTaskDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Task Details',
            status: TaskStatusEnum.getStatus(taskDetailsCubit
                .getTaskWithSubmissionsAndCommentsModel!.task!.tStatus!),
            statusIcon: Icons.flag),
        _buildContent(
            'Task Content',
            taskDetailsCubit
                .getTaskWithSubmissionsAndCommentsModel!.task!.tContent!,
            Icons.description),
        taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel?.task
                    ?.taskCategory !=
                null
            ? _buildCategoryRow(
                'Category',
                taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task!
                        .taskCategory!.cName ??
                    '')
            : Container(),

        taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task!
                .assignedToUsers!.isNotEmpty
            ? _buildAssignedToWidget(
                'Assigned To',
                taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task
                        ?.assignedToUsers!
                        .map((user) => user.name)
                        .join(', ') ??
                    '',
                Icons.person)
            : Container(),
        MyVerticalSpacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task
                        ?.tPlanedStartTime !=
                    null
                ? Expanded(
                    child: _buildTimeWidget(
                        'Planned Start Time',
                        taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!
                            .task!.tPlanedStartTime!,
                        Icons.timer),
                  )
                : Container(),
            taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task
                            ?.tPlanedStartTime !=
                        null &&
                    taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!
                            .task?.tPlanedEndTime !=
                        null
                ? SizedBox(width: 10)
                : Container(),
            taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task
                        ?.tPlanedEndTime !=
                    null
                ? Expanded(
                    child: _buildTimeWidget(
                        'Planned End Time',
                        taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!
                            .task!.tPlanedEndTime!,
                        Icons.timer_off),
                  )
                : Container(),
          ],
        ),
        MyVerticalSpacer(),
        taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task!
                    .tSupervisorNotes !=
                null
            ? _buildNotesWidget(
                'Supervisor Notes',
                taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task!
                    .tSupervisorNotes!,
                Icons.notes,
              )
            : Container(),
        taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task!
                    .tManagerNotes !=
                null
            ? _buildNotesWidget(
                'Manager Notes',
                taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel!.task!
                    .tManagerNotes!,
                Icons.notes,
              )
            : Container(),
        // _buildDateRow('Created At', task.createdAt?.toString() ?? 'N/A',
        //     Icons.calendar_today),
        // _buildDateRow(
        //     'Updated At', task.updatedAt?.toString() ?? 'N/A', Icons.update),
      ],
    );
  }

  Widget _buildSectionTitle(String title,
      {TaskStatusEnum? status, IconData? statusIcon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColorsConstants.primaryColor,
            ),
          ),
          status != null
              ? Row(
                  children: [
                    Icon(statusIcon, color: Colors.green, size: 18),
                    SizedBox(width: 6),
                    Text(
                      status.statusEn,
                      style: TextStyle(color: Colors.green, fontSize: 16),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildContent(
      String label, // not used
      String value,
      IconData icon,
      {bool isSubmission = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        value,
        style: TextStyle(
          color: Colors.grey[800],
          fontSize: 18,
          fontWeight: isSubmission ? FontWeight.normal : FontWeight.bold,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildTimeWidget(
    String label,
    DateTime value,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorsConstants.primaryColor, width: 0.6),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white, // Background color
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: ColorsConstants.primaryColor),
            SizedBox(height: 5),
            Text(
              '$label: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: ColorsConstants.primaryColor,
              ),
            ),
            Text(
              MyDateUtils.formatDateTime(value),
              style: TextStyle(color: Colors.grey[800], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesWidget(
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: ColorsConstants.primaryColor.withOpacity(0.02),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 2.0, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: ColorsConstants.primaryColor)),
          SizedBox(height: 4),
          Text(value, style: TextStyle(color: Colors.grey[800], fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildAssignedToWidget(
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: ColorsConstants.primaryColor),
        SizedBox(width: 10),
        Text(
          '$label: ',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: ColorsConstants.primaryColor),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.grey[800], fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: ColorsConstants.primaryColor),
          SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: ColorsConstants.primaryColor),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[800], fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.category, color: ColorsConstants.primaryColor),
          SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: ColorsConstants.primaryColor),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[800], fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Submissions'),
        ...taskDetailsCubit
                .getTaskWithSubmissionsAndCommentsModel?.task?.taskSubmissions
                ?.map((submission) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  border: Border(
                    left: BorderSide(
                      color: ColorsConstants.secondaryColor,
                      width: 5.0,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSubmissionHeader(submission),
                    _buildContent('Content', submission.tsContent ?? '',
                        Icons.content_copy,
                        isSubmission: true),

                    _buildDetailRow(
                        'File', submission.tsFile ?? '', Icons.attach_file),

                    MyVerticalSpacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        submission.tsActualStartTime != null
                            ? Expanded(
                                child: _buildTimeWidget(
                                    'Actual Start Time',
                                    submission.tsActualStartTime!,
                                    Icons.access_time),
                              )
                            : Container(),
                        submission.tsActualStartTime != null &&
                                submission.tsActualEndTime != null
                            ? SizedBox(width: 10)
                            : Container(),
                        submission.tsActualEndTime != null
                            ? Expanded(
                                child: _buildTimeWidget(
                                    'Actual End Time',
                                    submission.tsActualEndTime!,
                                    Icons.access_time_outlined),
                              )
                            : Container(),
                      ],
                    ),

                    // _buildStatusRow('Status', submission.status, Icons.info),
                    MyVerticalSpacer(),
                    submission.submissionComments!.isNotEmpty
                        ? _buildCommentsSection(submission.submissionComments!)
                        : Container(),
                  ],
                ),
              );
            }).toList() ??
            [],
      ],
    );
  }

  Widget _buildSubmissionHeader(TaskSubmissionModel submission) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Submitted By: ${submission.submitterUser?.name}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: ColorsConstants.secondaryColor),
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit, color: ColorsConstants.secondaryColor),
          onPressed: () {
            // Add action for editing the submission
          },
        ),
      ],
    );
  }

  Widget _buildCommentsSection(List<SubmissionCommentModel> comments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Comments:',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: ColorsConstants.secondaryColor)),
        ...comments.map((comment) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.grey[700]),
                    SizedBox(width: 10),
                    Text(
                      comment.commentedByUser?.name ?? '',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          fontSize: 16),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0, top: 4.0),
                  child: Text(
                    comment.tscContent ?? '',
                    style: TextStyle(color: Colors.grey[800], fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
