import 'package:flutter/material.dart';

class NavigationServices {
  static back<T>(BuildContext context, [T? result]) => Navigator.pop(context, result);

  // static navigateTo(BuildContext context, Widget screen, {bool removeAll = false}) {
  //   removeAll
  //       ? Navigator.pushAndRemoveUntil(
  //           context, MaterialPageRoute(builder: (context) => screen), (route) => false)
  //       : Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  // }

  static Future<T?> navigateTo<T>(BuildContext context, Widget screen, {bool removeAll = false}) {
    return removeAll
        ? Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (context) => screen), (route) => false)
        : Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}
