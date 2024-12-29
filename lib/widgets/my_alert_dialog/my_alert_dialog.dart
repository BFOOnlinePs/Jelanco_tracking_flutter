import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/core/constants/shared_size.dart';

class MyAlertDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool? showConfirmButton;
  final bool? showCancelButton;

  const MyAlertDialog({
    required this.title,
    required this.content,
    this.confirmText = 'تأكيد',
    this.cancelText = 'إلغاء',
    this.onConfirm,
    this.onCancel,
    this.showConfirmButton = true,
    this.showCancelButton = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(SharedSize.alertDialogBorderRadius)),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Container(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              content,
            ],
          ),
        ),
      ),
      // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      actions: [
        showConfirmButton == false
            ? const SizedBox.shrink()
            : ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(backgroundColor: ColorsConstants.primaryColor),
                child: Text(
                  confirmText,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
        showCancelButton == false
            ? const SizedBox.shrink()
            : TextButton(
                onPressed: onCancel ?? () => Navigator.of(context).pop(),
                child: Text(
                  cancelText,
                  // style: const TextStyle(color: Colors.grey),
                ),
              ),
      ],
    );
  }
}
