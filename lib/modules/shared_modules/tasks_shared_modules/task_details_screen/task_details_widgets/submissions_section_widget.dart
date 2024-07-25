import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/comments_section_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/content_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/detail_row_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/section_title_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/submission_header_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_widgets/time_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_text_button.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_image.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_photo_view.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_video.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';

class SubmissionsSectionWidget extends StatefulWidget {
  final TaskDetailsCubit taskDetailsCubit;

  const SubmissionsSectionWidget({super.key, required this.taskDetailsCubit});

  @override
  State<SubmissionsSectionWidget> createState() =>
      _SubmissionsSectionWidgetState();
}

class _SubmissionsSectionWidgetState extends State<SubmissionsSectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleWidget('عمليات التسليم'),
        ...widget.taskDetailsCubit.getTaskWithSubmissionsAndCommentsModel?.task
                ?.taskSubmissions
                ?.map((submission) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  border: Border(
                    right: BorderSide(
                      color: ColorsConstants.secondaryColor,
                      width: 5.0,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubmissionHeaderWidget(submission),
                    ContentWidget('Content', submission.tsContent ?? '',
                        Icons.content_copy,
                        isSubmission: true),

                    DetailRowWidget(
                        'الوسائط', submission.tsFile ?? '', Icons.attach_file),

                    submission
                            .submissionAttachmentsCategories!.files!.isNotEmpty
                        ? Column(
                            children: [
                              ...submission
                                  .submissionAttachmentsCategories!.files!
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final index = entry.key;
                                final file = entry.value;

                                return InkWell(
                                  onTap: () {
                                    widget.taskDetailsCubit.launchMyUrl(
                                        storagePath: EndPointsConstants
                                            .taskSubmissionsStorage,
                                        uriString: file.aAttachment!);
                                  },
                                  borderRadius: BorderRadius.circular(8.0),
                                  splashColor: Colors.blue.withOpacity(0.2),
                                  highlightColor: Colors.blue.withOpacity(0.1),
                                  child: Container(
                                    padding: EdgeInsets.all(8.0), // Add padding
                                    child: Text(
                                      'ملف رقم ${index + 1}',
                                      style: TextStyle(
                                        color: ColorsConstants.primaryColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        shadows: [
                                          Shadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            offset: Offset(1, 1),
                                            blurRadius: 2,
                                          ),
                                        ], // Subtle shadow
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          )
                        : Container(),

                    submission
                            .submissionAttachmentsCategories!.videos!.isNotEmpty
                        ? Container(
                            height: 300.0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return widget.taskDetailsCubit
                                        .isInitializeVideoController
                                    ? MyVideo(
                                        // height: 200,
                                        margin:
                                            EdgeInsetsDirectional.only(end: 8),
                                        index: index,
                                        videoPlayerController: submission
                                            .submissionAttachmentsCategories!
                                            .videos![index]
                                            .videoController,
                                        onTogglePlayPauseWithController: widget
                                            .taskDetailsCubit
                                            .toggleVideoPlayPause,
                                      )
                                    : Text('not initialized');
                              },
                              itemCount: submission
                                  .submissionAttachmentsCategories!
                                  .videos!
                                  .length,
                            ),
                          )
                        : Container(),

                    submission
                            .submissionAttachmentsCategories!.images!.isNotEmpty
                        ? Container(
                            height: 220.0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return MyImage(
                                  height: 200,
                                  margin: EdgeInsetsDirectional.only(end: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MyPhotoView(
                                            galleryItems: submission
                                                .submissionAttachmentsCategories!
                                                .images!
                                                .map((image) =>
                                                    image.aAttachment!)
                                                .toList(),
                                            imagesHostPath:
                                                '${EndPointsConstants.taskSubmissionsStorage}',
                                            startedIndex: index,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Image(
                                      image: NetworkImage(
                                        '${EndPointsConstants.taskSubmissionsStorage}${submission.submissionAttachmentsCategories!.images![index].aAttachment}',
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: submission
                                  .submissionAttachmentsCategories!
                                  .images!
                                  .length,
                            ),
                          )
                        : Container(),

                    MyVerticalSpacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        submission.tsActualStartTime != null
                            ? Expanded(
                                child: TimeWidget(
                                    'وقت البدء الفعلي',
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
                                child: TimeWidget(
                                    'وقت الإنتهاء الفعلي',
                                    submission.tsActualEndTime!,
                                    Icons.access_time_outlined),
                              )
                            : Container(),
                      ],
                    ),

                    // _buildStatusRow('Status', submission.status, Icons.info),
                    MyVerticalSpacer(),
                    submission.submissionComments!.isNotEmpty
                        ? CommentsSectionWidget(submission.submissionComments!)
                        : Container(),
                  ],
                ),
              );
            }).toList() ??
            [],
      ],
    );
  }
}
