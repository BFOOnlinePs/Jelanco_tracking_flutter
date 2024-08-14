import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_cubit.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_image.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_photo_view.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_video.dart';

class SubmissionMediaWidget extends StatelessWidget {
  final TaskSubmissionModel submission;
  final TaskDetailsCubit taskDetailsCubit;

  const SubmissionMediaWidget({
    super.key,
    required this.submission,
    required this.taskDetailsCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        submission.submissionAttachmentsCategories!.files!.isNotEmpty
            ? Column(
                children: [
                  ...submission.submissionAttachmentsCategories!.files!
                      .asMap()
                      .entries
                      .map((entry) {
                    final index = entry.key;
                    final file = entry.value;

                    return InkWell(
                      onTap: () {
                        taskDetailsCubit.launchMyUrl(
                            storagePath:
                                EndPointsConstants.taskSubmissionsStorage,
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
                                color: Colors.black.withOpacity(0.2),
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
        submission.submissionAttachmentsCategories!.videos!.isNotEmpty
            ? Container(
                height: 300.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return taskDetailsCubit.isInitializeVideoController
                        ? MyVideo(
                            // height: 200,
                            margin: EdgeInsetsDirectional.only(end: 8),
                            index: index,
                            videoPlayerController: submission
                                .submissionAttachmentsCategories!
                                .videos![index]
                                .videoController,
                            onTogglePlayPauseWithController:
                                taskDetailsCubit.toggleVideoPlayPause,
                          )
                        : Text('not initialized');
                  },
                  itemCount: submission
                      .submissionAttachmentsCategories!.videos!.length,
                ),
              )
            : Container(),
        submission.submissionAttachmentsCategories!.images!.isNotEmpty
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
                                    .submissionAttachmentsCategories!.images!
                                    .map((image) => image.aAttachment!)
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
                      .submissionAttachmentsCategories!.images!.length,
                ),
              )
            : Container(),
      ],
    );
  }
}
