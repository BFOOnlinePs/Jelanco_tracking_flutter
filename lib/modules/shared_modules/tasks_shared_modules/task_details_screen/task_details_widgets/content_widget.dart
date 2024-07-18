import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContentWidget extends StatelessWidget {
  final String label; // not used
  final String value;
  final IconData icon;
  bool isSubmission = false;

  ContentWidget(this.label, this.value, this.icon,
      {super.key, isSubmission});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        value,
        style: TextStyle(
          color: Colors.grey[800],
          fontSize: 18,
          fontWeight: isSubmission ? FontWeight.normal : FontWeight.bold,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
