import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jelanco_tracking_system/core/constants/card_size.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/date_utils.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/models/basic_models/interested_party_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_screen.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_submission_details_screen/task_submission_details_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_cached_network_image/my_cached_network_image.dart';

class ArticleItem extends StatelessWidget {
  final bool isTask;
  final InterestedPartyModel interestedPartyModel;

  const ArticleItem({super.key, required this.isTask, required this.interestedPartyModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CardSizeConstants.cardRadius)),
      child: InkWell(
        onTap: () {
          NavigationServices.navigateTo(
              context,
              isTask
                  ? TaskDetailsScreen(taskId: interestedPartyModel.task!.tId!)
                  : TaskSubmissionDetailsScreen(submissionId: interestedPartyModel.submission!.tsId!));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Image and Name
            ListTile(
              leading: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 0.5),
                ),
                padding: const EdgeInsets.all(2),
                child:
                    interestedPartyModel.task?.addedByUser?.image != null || interestedPartyModel.submission?.submitterUser?.image != null
                        ? MyCachedNetworkImage(
                            imageUrl: isTask
                                ? EndPointsConstants.profileStorage + interestedPartyModel.task!.addedByUser!.image!
                                : EndPointsConstants.profileStorage + interestedPartyModel.submission!.submitterUser!.image!,
                            width: 34.w,
                            height: 34.w,
                            fit: BoxFit.cover,
                          )
                        : Image(
                            image: const AssetImage(AssetsKeys.defaultProfileImage) as ImageProvider,
                            width: 34.w,
                            height: 34.w,
                            fit: BoxFit.cover,
                          ),
              ),
              title: Text(
                isTask ? interestedPartyModel.task?.addedByUser?.name ?? '' : interestedPartyModel.submission?.submitterUser?.name ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    MyDateUtils.formatDateTimeWithAmPm(
                        isTask ? interestedPartyModel.task?.createdAt : interestedPartyModel.submission?.createdAt),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1),
            // Content Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                isTask ? interestedPartyModel.task?.tContent ?? '' : interestedPartyModel.submission?.tsContent ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1),
            // Footer Section
            Container(
              padding: const EdgeInsets.all(16.0),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(12.0),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.grey.withOpacity(0.2),
              //       blurRadius: 6.0,
              //       spreadRadius: 2.0,
              //       offset: const Offset(0, 4),
              //     ),
              //   ],
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, size: 20, color: Colors.blueAccent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'تم إضافة الإشارة من قبل: ',
                            style: const TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            children: [
                              TextSpan(
                                text: interestedPartyModel.addedByUser?.name ?? 'غير معروف',
                                style: const TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.group, size: 20, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'جميع الأشخاص المشار إليهم: ',
                            style: const TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            children: [
                              TextSpan(
                                text: isTask
                                    ? interestedPartyModel.task?.interestedPartyUsers?.map((user) => user.name).join(", ") ?? 'لا يوجد'
                                    : interestedPartyModel.submission?.interestedPartyUsers?.map((user) => user.name).join(", ") ??
                                        'لا يوجد',
                                style: const TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
