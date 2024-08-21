import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_cubit/add_task_submission_cubit.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_image.dart';

class SelectedImagesWidget extends StatelessWidget {
  final AddTaskSubmissionCubit addTaskSubmissionCubit;
  final TaskSubmissionModel? taskSubmissionModel;

  const SelectedImagesWidget({
    super.key,
    required this.addTaskSubmissionCubit,
    required this.taskSubmissionModel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          addTaskSubmissionCubit
                  .pickedImagesList.isEmpty // new picked (from file)
              ? Container()
              : Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => MyImage(
                        height: 100,
                        showDeleteIcon: true,
                        onDeletePressed: () {
                          addTaskSubmissionCubit.deletedPickedImageFromList(
                              index: index);
                        },
                        child: Image.file(
                          File(addTaskSubmissionCubit
                              .pickedImagesList[index].path),
                        ),
                        margin: EdgeInsetsDirectional.only(end: 10)),
                    itemCount: addTaskSubmissionCubit.pickedImagesList.length,
                  ),
                ),

          // the old picked images list is empty (from network)
          taskSubmissionModel == null ||
                  taskSubmissionModel!
                      .submissionAttachmentsCategories!.images!.isEmpty
              ? Container()
              : Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => MyImage(
                        height: 100,
                        showDeleteIcon: true,
                        onDeletePressed: () {
                          addTaskSubmissionCubit.deletedPickedImageFromList(
                              index: index,
                              taskSubmissionModel: taskSubmissionModel!);
                        },
                        margin: EdgeInsetsDirectional.only(end: 10),
                        child: Image(
                          image: NetworkImage(
                            '${EndPointsConstants.taskSubmissionsStorage}${taskSubmissionModel!.submissionAttachmentsCategories!.images![index].aAttachment}',
                          ),
                        )),
                    itemCount: taskSubmissionModel!
                        .submissionAttachmentsCategories!.images!.length,
                  ),
                ),
        ],
      ),
    );
  }
}
