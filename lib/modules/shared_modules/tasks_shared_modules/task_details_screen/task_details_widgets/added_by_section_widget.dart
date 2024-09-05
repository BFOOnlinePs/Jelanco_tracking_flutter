import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/core/utils/date_utils.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/enums/task_status_enum.dart';

class AddedBySectionWidget extends StatelessWidget {
  final String addedByName;
  final TaskStatusEnum? status;
  final IconData? statusIcon;
  final DateTime? addedOn;

  const AddedBySectionWidget(this.addedByName,
      {super.key, this.status, this.statusIcon, this.addedOn});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // add border
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.5),
                    ),
                    padding: EdgeInsets.all(2),
                    child: Image(
                      image: AssetImage(AssetsKeys.defaultProfileImage),
                      height: 34,
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        addedByName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(

                        MyDateUtils.formatDateTimeWithAmPm(
                            addedOn),
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            ],
          ),
          // status != null
          //     ? Row(
          //         children: [
          //           Icon(statusIcon, color: status?.statusColor, size: 18),
          //           SizedBox(width: 6),
          //           Text(
          //             status?.statusAr ?? '',
          //             style:
          //                 TextStyle(color: status?.statusColor, fontSize: 16),
          //           ),
          //         ],
          //       )
          //     : Container(),
        ],
      ),
    );
  }
}
