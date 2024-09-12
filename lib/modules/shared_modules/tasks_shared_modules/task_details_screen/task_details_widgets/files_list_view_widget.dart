import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jelanco_tracking_system/core/constants/card_size.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/core/utils/launch_url_utils.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_attachment_model.dart';

class FilesListViewWidget extends StatelessWidget {
  final String? storagePath;
  final List<SubmissionAttachmentModel>? files;

  const FilesListViewWidget(
      {super.key, required this.storagePath, required this.files});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsetsDirectional.only(end: 14),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: files!.length,
        itemBuilder: (BuildContext context, int index) => InkWell(
          onTap: () {
            LaunchUrlUtils.launchMyUrl(
              storagePath: storagePath!,
              uriString: files![index].aAttachment!,
            );
          },
          borderRadius: BorderRadius.circular(8.0),
          splashColor: Colors.blue.withOpacity(0.2),
          highlightColor: Colors.blue.withOpacity(0.1),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(
                    color: ColorsConstants.primaryColor,
                    width: 0.7,
                  ),
                  borderRadius:
                      BorderRadius.circular(CardSizeConstants.mediaRadius),
                  boxShadow: const [
                    BoxShadow(
                      color: ColorsConstants.primaryColor,
                      spreadRadius: 1,
                      blurRadius: 4,
                      // offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: const FaIcon(FontAwesomeIcons.fileLines,
                    color: ColorsConstants.primaryColor, size: 30.0),

                // Text(
                //   'ملف رقم ${index + 1}',
                //   style: TextStyle(
                //     color: ColorsConstants.primaryColor,
                //     fontSize: 12.0,
                //     fontWeight: FontWeight.bold,
                //     decoration: TextDecoration.underline,
                //     shadows: [
                //       Shadow(
                //         color: Colors.black.withOpacity(0.2),
                //         offset: Offset(1, 1),
                //         blurRadius: 2,
                //       ),
                //     ], // Subtle shadow
                //   ),
                // ),
              ),
              const SizedBox(height: 10,),
              const Text('فتح الملف'),
            ],
          ),
        ),
      ),
    );
  }
}
