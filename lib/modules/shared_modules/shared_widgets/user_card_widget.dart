import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/card_size.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/modules/user_profile_modules/user_profile_screen.dart';
import 'package:jelanco_tracking_system/modules/users_management_modules/add_user_modules/add_user_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_cached_network_image/my_cached_image_builder.dart';
import 'package:jelanco_tracking_system/widgets/my_cached_network_image/my_cached_network_image.dart';

class UserCardWidget extends StatelessWidget {
  final UserModel userModel; // id, name, jobTitle, imageUrl
  final bool showEditButton;

  const UserCardWidget({super.key, required this.userModel, this.showEditButton = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CardSizeConstants.cardRadius),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        child: GestureDetector(
          onTap: () {
            NavigationServices.navigateTo(context, UserProfileScreen(userId: userModel.id!));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                child: userModel.image != null
                    ? MyCachedNetworkImage(
                        imageUrl: EndPointsConstants.profileStorage + userModel.image!,
                        imageBuilder: (context, imageProvider) => MyCachedImageBuilder(imageProvider: imageProvider),
                        isCircle: true,
                      )
                    : ClipOval(child: Image.asset(AssetsKeys.defaultProfileImage)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userModel.name ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    userModel.jobTitle != null && userModel.jobTitle!.isNotEmpty
                        ? Column(
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                userModel.jobTitle ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
              // IconButton(
              //   icon: const Icon(Icons.more_vert),
              //   onPressed: () {
              //     // Handle button press
              //   },
              // ),
              if (showEditButton)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    NavigationServices.navigateTo(context, AddUserScreen(userId: userModel.id));
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
