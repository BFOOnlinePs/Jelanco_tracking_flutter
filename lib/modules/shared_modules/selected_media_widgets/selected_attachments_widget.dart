import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/attachment_categories_model.dart';

class SelectedAttachmentsWidget extends StatelessWidget {
  final List<File> pickedFilesList;
  final Function({
    required int index,
    AttachmentsCategories? attachmentsCategories,
  }) deletedPickedFileFromList;
  final AttachmentsCategories? oldSubmissionAttachmentsCategories;

  const SelectedAttachmentsWidget({
    super.key,
    required this.pickedFilesList,
    required this.deletedPickedFileFromList,
    this.oldSubmissionAttachmentsCategories,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // addTaskSubmissionCubit
        //     .
        pickedFilesList.isEmpty
            ? Container()
            : Container(
                // height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    String fileName =
                        pickedFilesList[index].path.split('/').last;
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () =>
                              deletedPickedFileFromList(index: index),
                        ),
                        title: Text(fileName),
                        // subtitle: Text(pickedFiles[index].path),
                      ),
                    );
                  },
                  itemCount: pickedFilesList.length,
                ),
              ),

        // the old picked files list is empty (from network)

        oldSubmissionAttachmentsCategories == null ||
                oldSubmissionAttachmentsCategories!.files!.isEmpty
            ? Container()
            : Container(
                // height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    String? fileName =
                        // taskSubmissionModel!
                        // .
                        oldSubmissionAttachmentsCategories!
                            .files![index].aAttachment;
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () =>
                                // addTaskSubmissionCubit.
                                deletedPickedFileFromList(
                                    index: index,
                                    attachmentsCategories:
                                        oldSubmissionAttachmentsCategories)),
                        title: Text(fileName ?? 'file name'),
                        // subtitle: Text(pickedFiles[index].path),
                      ),
                    );
                  },
                  itemCount: oldSubmissionAttachmentsCategories!.files!.length,
                ),
              ),
      ],
    );
  }
}
