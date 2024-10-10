import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/modules/follow_up_management_modules/add_edit_users_modules/cubit/add_edit_users_cubit.dart';
import 'package:jelanco_tracking_system/modules/follow_up_management_modules/add_edit_users_modules/cubit/add_edit_users_states.dart';
import 'package:jelanco_tracking_system/modules/follow_up_management_modules/cubit/follow_up_management_cubit.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/drop_down/my_drop_down_button.dart';
import 'package:jelanco_tracking_system/widgets/drop_down/my_drop_down_search.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_elevated_button.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_text_button_no_border.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_text_button_scratch.dart';
import 'package:jelanco_tracking_system/widgets/my_cached_network_image/my_cached_image_builder.dart';
import 'package:jelanco_tracking_system/widgets/my_cached_network_image/my_cached_network_image.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_vertical_spacer.dart';
import 'package:jelanco_tracking_system/widgets/snack_bar/my_snack_bar.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';

import '../../../widgets/loaders/loader_with_disable.dart';

class AddEditUsersScreen extends StatelessWidget {
  final int? selectedUserId;

  AddEditUsersScreen({super.key, this.selectedUserId});

  late AddEditUsersCubit addEditUsersCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddEditUsersCubit()
        ..getAllUsers(
          loadingState: GetAllUsersLoadingState(),
          successState: GetAllUsersSuccessState(),
          errorState: (error) => GetAllUsersErrorState(),
        ).then((_) {
          // addEditUsersCubit.initValues(widget.selectedUserId);
        }),
      child: BlocConsumer<AddEditUsersCubit, AddEditUsersStates>(
        listener: (context, state) {
          if (state is GetAllUsersSuccessState) {
            addEditUsersCubit.allUsers = addEditUsersCubit.getAllUsersModel?.users ?? [];
            addEditUsersCubit.filteredAllUsers = addEditUsersCubit.allUsers; // Initialize with all users

            addEditUsersCubit.initValues(selectedUserId);
          } else if (state is AddEditManagerEmployeesSuccessState) {
            if (state.addEditManagerEmployeesModel.status == true) {
              SnackbarHelper.showSnackbar(
                context: context,
                snackBarStates: SnackBarStates.success,
                message: state.addEditManagerEmployeesModel.message,
              );
              // return the new selected manager
              NavigationServices.back(
                  context, ManagerAction(managerModel: addEditUsersCubit.managerUser)); // isRemove = false
            } else {
              SnackbarHelper.showSnackbar(
                context: context,
                snackBarStates: SnackBarStates.error,
                message: state.addEditManagerEmployeesModel.message,
              );
            }
          } else if (state is DeleteManagerSuccessState) {
            if (state.deleteManagerModel.status == true) {
              SnackbarHelper.showSnackbar(
                context: context,
                snackBarStates: SnackBarStates.success,
                message: state.deleteManagerModel.message,
              );
              // return the new selected manager
              NavigationServices.back(
                  context, ManagerAction(managerModel: addEditUsersCubit.managerUser, isRemove: true));
            } else {
              SnackbarHelper.showSnackbar(
                context: context,
                snackBarStates: SnackBarStates.error,
                message: state.deleteManagerModel.message,
              );
            }
          }
        },
        builder: (context, state) {
          addEditUsersCubit = AddEditUsersCubit.get(context);
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Stack(
              children: [
                Scaffold(
                  appBar: const MyAppBar(
                    title: 'إضافة / تعديل المتابعين',
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsetsDirectional.only(start: 16, end: 16, top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'المسؤول:',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const MyVerticalSpacer(
                              height: 4,
                            ),
                            MyDropdownSearch<UserModel>(
                                selectedItem: addEditUsersCubit.managerUser,
                                items: addEditUsersCubit.allUsers,
                                hintText: 'إختر موظف ليصبح المسؤول',
                                itemAsString: (UserModel user) => user.name ?? '',
                                showSearchBox: true,
                                onChanged: (UserModel? newValue) {
                                  addEditUsersCubit.selectManager(newValue);
                                }),
                            // MyDropdownButton<UserModel>(
                            //     value: addEditUsersCubit.managerUser,
                            //     items: addEditUsersCubit.allUsers,
                            //     hint: 'إختر موظف ليصبح المسؤول',
                            //     displayText: (UserModel user) => user.name ?? '',
                            //     onChanged: (UserModel? newValue) {
                            //       addEditUsersCubit.selectManager(newValue);
                            //     }),

                            addEditUsersCubit.managerUser == null ||
                                    (addEditUsersCubit.getManagerEmployeesByIdModel != null &&
                                        addEditUsersCubit
                                            .getManagerEmployeesByIdModel!.managerEmployees!.isEmpty)
                                ? Container()
                                : Container(
                                    margin: EdgeInsets.only(top: 6),
                                    child: Row(
                                      children: [
                                        Spacer(),
                                        MyTextButtonScratch(
                                            onPressed: () {
                                              addEditUsersCubit.deleteManager();
                                            },
                                            child: Text('حذف المسؤول')),
                                      ],
                                    ),
                                  ),
                            // MyVerticalSpacer(),
                          ],
                        ),
                      ),
                      addEditUsersCubit.managerUser == null
                          ? Container()
                          : Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 16),
                                        Text(
                                          'تحديد موظفين للمتابعة:',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        MyTextFormField(
                                          labelText: 'بحث عن موظفين',
                                          onChanged: addEditUsersCubit.usersSearch,
                                          prefixIcon: Icon(Icons.search),
                                        ),
                                        Row(
                                          children: [
                                            Spacer(),
                                            MyTextButtonScratch(
                                                onPressed: addEditUsersCubit.managerUser == null
                                                    ? null
                                                    : () {
                                                        addEditUsersCubit.toggleAllUsersSelection();
                                                      },
                                                child: Text('تحديد الكل')),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // select all

                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: addEditUsersCubit.filteredAllUsers.length,
                                      itemBuilder: (context, index) {
                                        UserModel user = addEditUsersCubit.filteredAllUsers[index];
                                        // Exclude the manager user from the list by its id
                                        if (addEditUsersCubit.managerUser != null &&
                                            addEditUsersCubit.filteredAllUsers[index].id ==
                                                addEditUsersCubit.managerUser!.id) {
                                          return const SizedBox.shrink();
                                        }
                                        return CheckboxListTile(
                                          title: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 20,
                                                child: user.image != null
                                                    ? MyCachedNetworkImage(
                                                        imageUrl:
                                                            EndPointsConstants.profileStorage + user.image!,
                                                        imageBuilder: (context, imageProvider) =>
                                                            MyCachedImageBuilder(imageProvider: imageProvider),
                                                        isCircle: true,
                                                      )
                                                    : ClipOval(
                                                        child: Image.asset(AssetsKeys.defaultProfileImage)),
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
                                          value: addEditUsersCubit.employeesUsers
                                              .contains(addEditUsersCubit.filteredAllUsers[index]),
                                          onChanged: (bool? value) {
                                            addEditUsersCubit.toggleEmployeeSelection(
                                                addEditUsersCubit.filteredAllUsers[index]);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(16),
                                    child: MyElevatedButton(
                                      isWidthFull: true,
                                      onPressed: addEditUsersCubit.managerUser == null ||
                                              addEditUsersCubit.employeesUsers.isEmpty
                                          ? null
                                          : () {
                                              addEditUsersCubit.addEditManagerEmployees();
                                            },
                                      buttonText: 'حفظ',
                                      isDisabled: addEditUsersCubit.managerUser == null ||
                                          addEditUsersCubit.employeesUsers.isEmpty,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
                state is GetAllUsersLoadingState ||
                        state is GetManagerEmployeesByIdLoadingState ||
                        state is DeleteManagerLoadingState ||
                        state is AddEditManagerEmployeesLoadingState
                    ? const LoaderWithDisable()
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }
}
