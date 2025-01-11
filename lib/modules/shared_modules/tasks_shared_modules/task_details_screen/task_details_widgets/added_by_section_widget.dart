import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/core/utils/date_utils.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/enums/system_permissions.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';
import 'package:jelanco_tracking_system/models/shared_models/menu_item_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_widgets/all_users_selection_modules/all_users_selection_screen.dart';
import 'package:jelanco_tracking_system/modules/edit_task_modules/edit_task_screen.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/options_widget.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_cubit.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_submission_details_screen/cubit/task_submission_details_cubit.dart';
import 'package:jelanco_tracking_system/modules/tasks_added_by_user_modules/tasks_added_by_user_cubit/tasks_added_by_user_cubit.dart';
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
                NavigationServices.navigateTo(context, UserProfileScreen(userId: taskModel.addedByUser!.id!));
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
                            imageUrl: EndPointsConstants.profileStorage + taskModel.addedByUser!.image!,
                            width: 34,
                            height: 34,
                            fit: BoxFit.cover,
                          )
                        : const Image(
                            image: AssetImage(AssetsKeys.defaultProfileImage) as ImageProvider,
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
                      Row(
                        children: [
                          // taskModel.createdAt != taskModel.updatedAt
                          //     ? Text(
                          //         'تاريخ الاضافة: ',
                          //         style: const TextStyle(
                          //           fontSize: 10,
                          //         ),
                          //       )
                          //     : Container(),
                          Text(
                            MyDateUtils.formatDateTimeWithAmPm(taskModel.createdAt),
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      taskModel.createdAt != taskModel.updatedAt
                          ? Row(
                              children: [
                                const Text(
                                  'اخر تعديل: ',
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  MyDateUtils.formatDateTimeWithAmPm(taskModel.updatedAt),
                                  style: const TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        // edit task
        if (SystemPermissions.hasPermission(SystemPermissions.editTask) && taskModel.addedByUser?.id == UserDataConstants.userId)
          OptionsWidget(menuItems: [
            MenuItemModel(
              icon: Icons.edit,
              label: 'تعديل',
              onTap: () {
                TaskDetailsCubit? taskDetailsCubit;
                TaskSubmissionDetailsCubit? taskSubmissionDetailsCubit;
                TasksAddedByUserCubit? tasksAddedByUserCubit;

                try {
                  taskSubmissionDetailsCubit = TaskSubmissionDetailsCubit.get(context);
                } catch (e) {
                  print('Error in my catch: $e');
                }

                try {
                  // to show the edited task immediately
                  taskDetailsCubit = TaskDetailsCubit.get(context);
                } catch (e) {
                  print('Error in my catch: $e');
                }

                try {
                  tasksAddedByUserCubit = TasksAddedByUserCubit.get(context);
                } catch (e) {
                  print('Error in my catch: $e');
                }

                NavigationServices.navigateTo(
                  context,
                  EditTaskScreen(
                    taskId: taskModel.tId!,
                    getDataCallback: (editedTaskModel) {
                      if (taskSubmissionDetailsCubit != null) {
                        taskSubmissionDetailsCubit.afterEditTask();
                      }
                      if (taskDetailsCubit != null) {
                        taskDetailsCubit.afterEditTask(newTaskModel: editedTaskModel);
                      }
                      if (tasksAddedByUserCubit != null) {
                        tasksAddedByUserCubit.afterEditTask(oldTaskId: taskModel.tId!, newTaskModel: editedTaskModel);
                      }
                    },
                  ),
                );
              },
            ),
            MenuItemModel(
                icon: Icons.people_outline_sharp,
                label: 'الإشارات والوسوم',
                onTap: () {
                  NavigationServices.navigateTo(
                      context, AllUsersSelectionScreen(callInterestedParties: true, articleType: 'task', articleId: taskModel.tId));
                }),
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
