import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_cubit.dart';
import 'package:jelanco_tracking_system/modules/tasks_to_submit_modules/task_to_submit_card_widget.dart';
import 'package:jelanco_tracking_system/modules/tasks_to_submit_modules/tasks_to_submit_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_text_button_no_border.dart';

class HomeTasksToSubmitWidget extends StatelessWidget {
  final HomeCubit homeCubit;

  const HomeTasksToSubmitWidget({super.key, required this.homeCubit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              SizedBox(
                width: 6,
              ),
              Text('مهام بانتظار التسليم'),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          homeCubit.getTasksToSubmitModel == null
              ? const LinearProgressIndicator()
              : homeCubit.getTasksToSubmitModel!.tasks!.isNotEmpty
                  ? Column(
                      children: [
                        ...homeCubit.getTasksToSubmitModel!.tasks!.map((task) {
                          return TaskToSubmitCardWidget(task: task);
                        }),
                        Row(
                          children: [
                            const Spacer(),
                            MyTextButtonNoBorder(
                                onPressed: () {
                                  NavigationServices.navigateTo(
                                      context, TasksToSubmitScreen());
                                },
                                child: const Text('عرض الكل')),
                          ],
                        ),
                      ],
                    )
                  : Container(),
        ],
      ),
    );
  }
}
