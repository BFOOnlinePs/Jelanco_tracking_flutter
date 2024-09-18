import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/core/utils/launch_url_utils.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/widgets/my_cached_network_image/my_cached_image_builder.dart';
import 'package:jelanco_tracking_system/widgets/my_cached_network_image/my_cached_network_image.dart';
import 'package:jelanco_tracking_system/widgets/my_media_view/my_photo_view.dart';

class ProfileCardWidget extends StatelessWidget {
  final UserModel userInfo;
  final Function onTapChangeProfilePic;

  const ProfileCardWidget(
      {super.key, required this.userInfo, required this.onTapChangeProfilePic});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 10, end: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            const BorderRadius.vertical(bottom: Radius.circular(20.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    userInfo.image != null
                        ? NavigationServices.navigateTo(
                            context,
                            MyPhotoView(
                              imagesUrls: [userInfo.image ?? ''],
                              storagePath: EndPointsConstants.profileStorage,
                              startedIndex: 0,
                            ),
                          )
                        : null;
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    child: userInfo.image != null
                        ? MyCachedNetworkImage(
                            imageUrl: EndPointsConstants.profileStorage +
                                userInfo.image!,
                            imageBuilder: (context, imageProvider) =>
                                MyCachedImageBuilder(
                                    imageProvider: imageProvider),
                            isCircle: true,
                          )
                        : ClipOval(
                            child: Image.asset(
                              AssetsKeys.defaultProfileImage,
                            ),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: UserDataConstants.userId == userInfo.id
                      ? Container(
                          decoration: const BoxDecoration(
                            color: ColorsConstants.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: InkWell(
                            onTap: () {
                              onTapChangeProfilePic();
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 20, // Icon size
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Text(
              userInfo.name ?? '',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
              // textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Row(
              // mainAxisAlignment:
              //     MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.addressCard,
                  color: Colors.blueGrey[400],
                  size: 20,
                ),
                const SizedBox(width: 5),
                Text(
                  userInfo.jobTitle ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.envelope,
                  color: Colors.blueGrey[400],
                  size: 20,
                ),
                const SizedBox(width: 5),
                Text(
                  userInfo.email ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blueGrey[400],
                  ),
                ),
              ],
            ),

            userInfo.phoneNumber != null
                ? Column(
                    children: [
                      const SizedBox(height: 5),
                      InkWell(
                        onTap: () {
                          LaunchUrlUtils.makePhoneCall(userInfo.phoneNumber!);
                        },
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              FontAwesomeIcons.phone,
                              color: Colors.blueGrey[400],
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              userInfo.phoneNumber!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blueGrey[400],
                              ),
                              textDirection: TextDirection.ltr,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      InkWell(
                        onTap: () {
                          LaunchUrlUtils.sendWhatsAppMessage(
                              userInfo.phoneNumber!);
                        },
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.blueGrey[400],
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              userInfo.phoneNumber!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blueGrey[400],
                              ),
                              textDirection: TextDirection.ltr,

                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(),
            // Divider(height: 0.5, color: Colors.grey[300],)
          ],
        ),
      ),
    );
  }
}
