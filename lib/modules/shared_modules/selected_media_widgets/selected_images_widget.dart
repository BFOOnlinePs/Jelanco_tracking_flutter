import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/attachment_categories_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_cubit/add_task_submission_cubit.dart';
import 'package:jelanco_tracking_system/widgets/my_cached_network_image/my_cached_network_image.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_image.dart';

class SelectedImagesWidget extends StatelessWidget {
  // final AddTaskSubmissionCubit addTaskSubmissionCubit;
  // final TaskSubmissionModel? taskSubmissionModel; // for old picked images

  //
  final List<XFile> pickedImagesList;
  final Function({
    required int index,
    AttachmentsCategories? attachmentsCategories,
  }) deletedPickedImageFromList;

  final AttachmentsCategories? oldSubmissionAttachmentsCategories;

  final String storagePath;

  const SelectedImagesWidget({
    super.key,
    // required this.addTaskSubmissionCubit,
    // required this.taskSubmissionModel,
    required this.pickedImagesList,
    required this.deletedPickedImageFromList,
     this.oldSubmissionAttachmentsCategories,
    required this.storagePath,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // addTaskSubmissionCubit
          //         .
          pickedImagesList.isEmpty // new picked (from file)
              ? Container()
              : SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => MyImage(
                        height: 200,
                        showDeleteIcon: true,
                        onDeletePressed: () {
                          // addTaskSubmissionCubit.
                          deletedPickedImageFromList(index: index);
                        },
                        margin: const EdgeInsetsDirectional.only(end: 10),
                        child: Container(
                          // height: 200,
                          // width: 132,
                          child: Image.file(
                            File(
                                // addTaskSubmissionCubit
                                // .
                                pickedImagesList[index].path),
                            // fit: BoxFit.cover,
                          ),
                        )),
                    itemCount:
                        // addTaskSubmissionCubit.
                        pickedImagesList.length,
                  ),
                ),

          // the old picked images list is empty (from network)

          oldSubmissionAttachmentsCategories == null ||
                  // taskSubmissionModel == null ||
                  //         taskSubmissionModel!
                  //             .
                  oldSubmissionAttachmentsCategories!.images!.isEmpty
              ? Container()
              : SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => MyImage(
                      height: 100,
                      showDeleteIcon: true,
                      onDeletePressed: () {
                        // addTaskSubmissionCubit.
                        deletedPickedImageFromList(
                            index: index,
                            attachmentsCategories:
                                oldSubmissionAttachmentsCategories);
                      },
                      margin: const EdgeInsetsDirectional.only(end: 10),
                      child: Container(
                        // height: 200,
                        // width: 132,
                        child: MyCachedNetworkImage(
                          imageUrl: storagePath +
                              // taskSubmissionModel!
                              //     .
                              oldSubmissionAttachmentsCategories!
                                  .images![index].aAttachment!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    itemCount:
                        // taskSubmissionModel!
                        //     .
                        oldSubmissionAttachmentsCategories!.images!.length,
                  ),
                ),
        ],
      ),
    );
  }
}
