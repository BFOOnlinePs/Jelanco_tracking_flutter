import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/modules/follow_up_management_modules/cubit/follow_up_management_cubit.dart';
import 'package:jelanco_tracking_system/modules/follow_up_management_modules/cubit/follow_up_management_states.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/loader_with_disable.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_floating_action_button.dart';
import 'package:jelanco_tracking_system/widgets/my_cached_network_image/my_cached_image_builder.dart';
import 'package:jelanco_tracking_system/widgets/my_cached_network_image/my_cached_network_image.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';

class UsersFollowUpManagementScreen extends StatelessWidget {
  const UsersFollowUpManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FollowUpManagementCubit()..getManagers(),
      child: BlocConsumer<FollowUpManagementCubit, FollowUpManagementStates>(
        listener: (context, state) {},
        builder: (context, state) {
          FollowUpManagementCubit followUpManagementCubit = FollowUpManagementCubit.get(context);
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Stack(
              children: [
                Scaffold(
                  appBar: const MyAppBar(
                    title: 'المتابعين الحاليين',
                  ),
                  body: Column(
                    children: [
                      followUpManagementCubit.filteredUsers.isEmpty &&
                              followUpManagementCubit.searchText.isEmpty
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: MyTextFormField(
                                labelText: 'بحث عن متابع',
                                onChanged: followUpManagementCubit.usersSearch,
                                prefixIcon: const Icon(Icons.search),
                              )),
                      Expanded(
                        child: followUpManagementCubit.filteredUsers.isEmpty &&
                                state is! GetManagersLoadingState
                            ? const Center(
                                child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image(
                                    image: AssetImage(
                                      AssetsKeys.defaultNoUsersImage,
                                    ),
                                    height: 250,
                                  ),
                                  Text('لا يوجد متابعين'),
                                ],
                              ))
                            : ListView.builder(
                                itemCount: followUpManagementCubit.filteredUsers.length,
                                itemBuilder: (context, index) {
                                  UserModel user = followUpManagementCubit.filteredUsers[index];
                                  return ListTile(
                                    title: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          child: user.image != null
                                              ? MyCachedNetworkImage(
                                                  imageUrl: EndPointsConstants.profileStorage + user.image!,
                                                  imageBuilder: (context, imageProvider) =>
                                                      MyCachedImageBuilder(imageProvider: imageProvider),
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
                                    trailing: GestureDetector(
                                      child: const Icon(Icons.edit),
                                      onTap: () {
                                        // Navigate to edit screen with the selected user
                                        followUpManagementCubit.navigateToEditAddScreen(
                                            context, followUpManagementCubit.filteredUsers[index]);
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                  floatingActionButton: MyFloatingActionButton(
                    icon: Icons.add,
                    labelText: 'متابع جديد',
                    onPressed: () {
                      // // Navigate to add a new user
                      followUpManagementCubit.navigateToEditAddScreen(context, null);
                    },
                  ),
                ),
                state is GetManagersLoadingState ? const LoaderWithDisable() : Container(),
              ],
            ),
          );
        },
      ),
    );
  }
}
