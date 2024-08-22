import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorsConstants {
  static const Color primaryColor = Color(0xFF2A3890);
  static const Color secondaryColor = Color(0xFFED1922);

  static const LinearGradient myLinearGradient = LinearGradient(
    colors: [Colors.lightBlueAccent, Colors.purple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
