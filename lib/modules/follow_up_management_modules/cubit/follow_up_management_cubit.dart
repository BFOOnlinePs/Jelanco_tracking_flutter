import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/models/manager_employees_models/get_managers_model.dart';
import 'package:jelanco_tracking_system/modules/follow_up_management_modules/add_edit_users_modules/add_edit_users_screen.dart';
import 'package:jelanco_tracking_system/modules/follow_up_management_modules/cubit/follow_up_management_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class FollowUpManagementCubit extends Cubit<FollowUpManagementStates> {
  FollowUpManagementCubit() : super(FollowUpManagementInitialState());

  static FollowUpManagementCubit get(context) => BlocProvider.of(context);

  List<UserModel> filteredUsers = [];
  String searchText = '';

  GetManagersModel? getManagersModel;

  void getManagers() {
    emit(GetManagersLoadingState());
    DioHelper.getData(url: EndPointsConstants.managers).then((value) {
      print(value?.data);
      getManagersModel = GetManagersModel.fromMap(value?.data);
      filteredUsers = getManagersModel?.managers ?? [];
      emit(GetManagersSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetManagersErrorState());
    });
  }

  void usersSearch(String query) {
    searchText = query;
    filteredUsers = getManagersModel!.managers!
        .where((user) => user.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(UsersSearchState());
  }

  void navigateToEditAddScreen(BuildContext context, UserModel? user) async {
    final ManagerAction? managerAction = await NavigationServices.navigateTo<ManagerAction>(
        context, AddEditUsersScreen(selectedUserId: user?.id));

    print('managerAction: $managerAction');
    if (managerAction != null) {
      // add the new manager if not exists
      if (managerAction.isRemove == true) {
        getManagersModel?.managers?.removeWhere((manager) => manager.id == managerAction.managerModel?.id);
      } else if (!getManagersModel!.managers!
          .any((manager) => manager.id == managerAction.managerModel?.id)) {
        getManagersModel?.managers?.add(managerAction.managerModel ?? UserModel());
        // filteredUsers.add(UserModel(id: newManagerId));
      }
      emit(NavigateToEditAddScreenSuccessState());
    }
  }
}

class ManagerAction {
  final UserModel? managerModel;
  final bool? isRemove;

  ManagerAction({
    this.managerModel,
    this.isRemove = false,
  });
}
