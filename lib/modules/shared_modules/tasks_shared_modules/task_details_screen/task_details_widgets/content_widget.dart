import 'package:flutter/material.dart';

class ContentWidget extends StatefulWidget {
  final String value;

  ContentWidget(this.value, {super.key, isSubmission});

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  bool isSubmission = false;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 10),
        child: Column(
          children: [
            Text(
              widget.value,
              maxLines: isExpanded ? null : 4,
              overflow:
                  isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 12,
                fontWeight: isSubmission ? FontWeight.normal : FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
