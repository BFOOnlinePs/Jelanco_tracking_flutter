import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:jelanco_tracking_system/core/utils/clip_board_utils.dart';
import 'package:jelanco_tracking_system/core/utils/launch_url_utils.dart';
import 'package:jelanco_tracking_system/widgets/snack_bar/my_snack_bar.dart';

class PdfViewerScreen extends StatelessWidget {
  final String originalFilePath;
  final String tempFilePath;

  const PdfViewerScreen({super.key, required this.originalFilePath, required this.tempFilePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () async {
              if (await ClipBoardUtils.copyToClipboard(originalFilePath) == true) {
                print("تم نسخ الرابط إلى الحافظة، يمكنك مشاركته الان.");
                SnackbarHelper.showSnackbar(
                    context: context, snackBarStates: SnackBarStates.none, message: 'تم نسخ الرابط إلى الحافظة، يمكنك مشاركته الان.');
              } else {
                print("فشل نسخ الرابط");
                SnackbarHelper.showSnackbar(context: context, snackBarStates: SnackBarStates.none, message: 'فشل نسخ الرابط.');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              LaunchUrlUtils.launchMyUrl(storagePath: '', uriString: originalFilePath);
            },
          ),
        ],
      ),
      body: PDFView(
        filePath: tempFilePath,
      ),
    );
  }
}
