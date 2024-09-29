import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContentWidget extends StatefulWidget {
  final String value;

  const ContentWidget(this.value, {super.key, isSubmission});

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
      child: Container(
        margin: const EdgeInsets.only(top: 4, bottom: 4),
        child: Column(
          children: [
            Text(
              widget.value,
              maxLines: isExpanded ? null : 4,
              overflow:
                  isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 20.sp,
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
