import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jelanco_tracking_system/core/constants/card_size.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/core/utils/launch_url_utils.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_attachment_model.dart';

class FilesListViewWidget extends StatefulWidget {
  final String? storagePath;
  final List<SubmissionAttachmentModel>? files;
  final bool isOpenFile;

  FilesListViewWidget({super.key, required this.storagePath, required this.files, this.isOpenFile = true});

  @override
  State<FilesListViewWidget> createState() => _FilesListViewWidgetState();
}

class _FilesListViewWidgetState extends State<FilesListViewWidget> {
  bool loading = false;

  // when open the pdf

  void toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 82,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.files!.length,
        itemBuilder: (BuildContext context, int index) => Container(
          margin: const EdgeInsetsDirectional.only(end: 6, top: 4),
          child: InkWell(
            onTap: widget.isOpenFile
                ? () async {
                    toggleLoading();
                    if (widget.files![index].aAttachment!.endsWith('.pdf')) {
                      await LaunchUrlUtils.downloadAndOpenPdf(widget.storagePath! + widget.files![index].aAttachment!, context);
                    } else {
                      LaunchUrlUtils.launchMyUrl(
                        storagePath: widget.storagePath!,
                        uriString: widget.files![index].aAttachment!,
                      );
                    }
                    toggleLoading();
                  }
                : null,
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
                    borderRadius: BorderRadius.circular(CardSizeConstants.mediaRadius),
                    boxShadow: const [
                      BoxShadow(
                        color: ColorsConstants.primaryColor,
                        spreadRadius: 1,
                        blurRadius: 4,
                        // offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: loading
                      ? const SizedBox(width: 24, height: 30, child: CircularProgressIndicator(color: ColorsConstants.primaryColor))
                      : const FaIcon(FontAwesomeIcons.fileLines, color: ColorsConstants.primaryColor, size: 30.0),

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
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'فتح الملف',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
