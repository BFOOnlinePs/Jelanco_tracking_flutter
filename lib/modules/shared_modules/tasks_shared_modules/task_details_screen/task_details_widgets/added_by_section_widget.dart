import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/core/utils/date_utils.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/enums/system_permissions.dart';
import 'package:jelanco_tracking_system/enums/task_status_enum.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';
import 'package:jelanco_tracking_system/models/shared_models/menu_item_model.dart';
import 'package:jelanco_tracking_system/modules/edit_task_modules/edit_task_screen.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/task_options_widget.dart';
import 'package:jelanco_tracking_system/modules/user_profile_modules/user_profile_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_cached_network_image/my_cached_network_image.dart';

class AddedBySectionWidget extends StatelessWidget {
  final TaskModel taskModel;

  const AddedBySectionWidget(this.taskModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                NavigationServices.navigateTo(context,
                    UserProfileScreen(userId: taskModel.addedByUser!.id!));
              },
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.5),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: taskModel.addedByUser?.image != null
                        ? MyCachedNetworkImage(
                            imageUrl: EndPointsConstants.profileStorage +
                                taskModel.addedByUser!.image!,
                            width: 34,
                            height: 34,
                            fit: BoxFit.cover,
                          )
                        : const Image(
                            image: AssetImage(AssetsKeys.defaultProfileImage)
                                as ImageProvider,
                            width: 34,
                            height: 34,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        taskModel.addedByUser?.name ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        MyDateUtils.formatDateTimeWithAmPm(taskModel.createdAt),
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        // edit task
        if (SystemPermissions.hasPermission(SystemPermissions.editTask) &&
            taskModel.addedByUser?.id == UserDataConstants.userId)
          TaskOptionsWidget(menuItems: [
            MenuItemModel(
              icon: Icons.edit,
              label: 'تعديل',
              onTap: () {
                NavigationServices.navigateTo(
                  context,
                  EditTaskScreen(
                    taskModel: taskModel,
                  ),
                );
              },
            ),
          ])

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
    );
  }
}
