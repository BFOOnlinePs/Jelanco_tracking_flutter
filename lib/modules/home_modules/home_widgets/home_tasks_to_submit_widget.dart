import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/card_size.dart';
import 'package:jelanco_tracking_system/core/constants/colors.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_cubit.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_text_button_no_border.dart';

class HomeTasksToSubmitWidget extends StatelessWidget {
  final HomeCubit homeCubit;

  const HomeTasksToSubmitWidget({super.key, required this.homeCubit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.only(top: 10),
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
          SizedBox(
            height: 6,
          ),
          homeCubit.getTasksToSubmitModel == null
              ? const LinearProgressIndicator()
              : homeCubit.getTasksToSubmitModel!.tasks!.isNotEmpty
                  ? Column(
                      children: [
                        ...homeCubit.getTasksToSubmitModel!.tasks!.map((task) {
                          return Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              gradient: ColorsConstants.myLinearGradient,
                              borderRadius: BorderRadius.circular(
                                  CardSizeConstants.cardRadius),
                            ),
                            child: Card(
                              color: Colors.transparent,
                              // Make the Card background transparent
                              elevation: 4.0,
                              // Add shadow to the Card
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    CardSizeConstants.cardRadius),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                // Add padding inside the Card
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '> ${task.addedByUser?.name ?? ''}',
                                      style:
                                          TextStyle(color: Colors.orangeAccent),
                                    ),
                                    Text(
                                      task.tContent ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                        Row(
                          children: [
                            Spacer(),
                            MyTextButtonNoBorder(
                                onPressed: () {}, child: Text('عرض الكل')),
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
