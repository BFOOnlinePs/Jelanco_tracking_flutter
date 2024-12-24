import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/widgets/my_cached_network_image/my_cached_image_builder.dart';
import 'package:jelanco_tracking_system/widgets/my_cached_network_image/my_cached_network_image.dart';

class CheckBoxUserWidget extends StatelessWidget {
  final UserModel user;
  final bool value;
  final void Function(bool?)? onChanged;
  final bool? enabled;

  const CheckBoxUserWidget({super.key, required this.user, required this.value, required this.onChanged, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            child: user.image != null
                ? MyCachedNetworkImage(
                    imageUrl: EndPointsConstants.profileStorage + user.image!,
                    imageBuilder: (context, imageProvider) => MyCachedImageBuilder(imageProvider: imageProvider),
                    isCircle: true,
                  )
                : ClipOval(child: Image.asset(AssetsKeys.defaultProfileImage)),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              user.name ?? 'name',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
      value: value,
      onChanged: onChanged,
      enabled: enabled,
    );
  }
}
