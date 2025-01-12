import 'package:flutter/services.dart';

class ClipBoardUtils{
  static Future<bool> copyToClipboard(String text) async {
    final ClipboardData data = ClipboardData(text: text);
    return await Clipboard.setData(data).then((value) {
      print("تم النسخ إلى الحافظة");
      return true;
    }).catchError((error) {
      print("حدث خطأ أثناء النسخ  إلى الحافظة: $error");
      return false;
    });
  }
}