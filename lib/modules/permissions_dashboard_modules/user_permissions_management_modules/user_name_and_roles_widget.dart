import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/card_size.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/user_permissions_management_modules/cubit/user_permissions_management_cubit.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/user_permissions_management_modules/user_roles_and_permissions_management_modules/user_roles_and_permissions_management_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_cached_network_image/my_cached_image_builder.dart';
import 'package:jelanco_tracking_system/widgets/my_cached_network_image/my_cached_network_image.dart';

class UserNameAndRoleWidget extends StatelessWidget {
  final UserModel user;
  final void Function()? onTap;

  const UserNameAndRoleWidget({super.key, required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CardSizeConstants.cardRadius)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue.shade100,
                    child: user.image != null
                        ? MyCachedNetworkImage(
                            imageUrl: EndPointsConstants.profileStorage + user.image!,
                            imageBuilder: (context, imageProvider) => MyCachedImageBuilder(imageProvider: imageProvider),
                            isCircle: true,
                          )
                        : ClipOval(child: Image.asset(AssetsKeys.defaultProfileImage)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      user.name ?? 'username',
                      style: const TextStyle(
                        fontSize: 16,
                        // fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward),
                  // IconButton(
                  //   icon: const Icon(Icons.arrow_forward),
                  //   onPressed: () {
                  //     // Navigator.push(context, MaterialPageRoute(builder: (context) => UserRolesAndPermissionsManagementScreen(user: user)));
                  //   },
                  // ),
                ],
              ),
              user.roles!.isEmpty
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: user.roles!
                              .map((role) => Container(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: ColorsConstants.primaryColor),
                                    ),
                                    child: Text(
                                      role.name ?? 'role name',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: ColorsConstants.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
