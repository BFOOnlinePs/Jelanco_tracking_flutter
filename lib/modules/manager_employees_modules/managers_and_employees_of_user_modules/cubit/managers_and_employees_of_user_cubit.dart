import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/formats_utils.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/users_mixin/users_mixin.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/models/manager_employees_models/add_edit_manager_employees_model.dart';
import 'package:jelanco_tracking_system/models/manager_employees_models/get_managers_and_employees_of_user_model.dart';
import 'package:jelanco_tracking_system/modules/manager_employees_modules/managers_and_employees_of_user_modules/cubit/managers_and_employees_of_user_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

import '../../../../models/basic_models/status_message_model.dart';

class ManagersAndEmployeesOfUserCubit extends Cubit<ManagersAndEmployeesOfUserStates> with UsersMixin<ManagersAndEmployeesOfUserStates> {
  ManagersAndEmployeesOfUserCubit() : super(ManagersAndEmployeesOfUserInitialState());

  static ManagersAndEmployeesOfUserCubit get(context) => BlocProvider.of(context);

  List<UserModel> selectedManagers = [];
  List<UserModel> initialSelectedManagers = []; // to prevent selecting the same user as manager and employee
  List<UserModel> filteredManagers = [];
  List<UserModel> reorderedUsersListForManagers = [];
  List<UserModel> selectedEmployees = [];
  List<UserModel> initialSelectedEmployees = []; // to prevent selecting the same user as manager and employee
  List<UserModel> filteredEmployees = [];
  List<UserModel> reorderedUsersListForEmployees = [];

  void enterScreenActions({required int userId}) async {
    await Future.wait([
      getManagersAndEmployeesOfUser(userId: userId),
      getAllUsers(
          loadingState: GetAllUsersLoadingState(), successState: GetAllUsersSuccessState(), errorState: (error) => GetAllUsersErrorState()),
    ]);

    initialSelectedManagers =
        getManagersAndEmployeesOfUserModel?.managerIds?.map((id) => usersList.firstWhere((user) => user.id == id)).toList() ?? [];
    selectedManagers = List.from(initialSelectedManagers);

    initialSelectedEmployees =
        getManagersAndEmployeesOfUserModel?.employeeIds?.map((id) => usersList.firstWhere((user) => user.id == id)).toList() ?? [];
    selectedEmployees = List.from(initialSelectedEmployees);

    // Exclude the current user from usersList
    usersList.removeWhere((user) => user.id == userId);

    // reordered lists for each tab
    reorderedUsersListForManagers = [
      ...initialSelectedManagers, // Selected managers first
      ...usersList.where((user) => !initialSelectedManagers.contains(user)), // Other users
    ];

    reorderedUsersListForEmployees = [
      ...initialSelectedEmployees, // Selected employees first
      ...usersList.where((user) => !initialSelectedEmployees.contains(user)), // Other users
    ];



    emit(EnterScreenActionsState());
    print('selectedManagers: ${selectedManagers.length}');
    print('initialSelectedManagers: ${initialSelectedManagers.length}');
    print('selectedEmployees: ${selectedEmployees.length}');
    print('initialSelectedEmployees: ${initialSelectedEmployees.length}');
  }

  GetManagersAndEmployeesOfUserModel? getManagersAndEmployeesOfUserModel;

  Future<void> getManagersAndEmployeesOfUser({required int userId}) async {
    emit(GetManagersAndEmployeesOfUserLoadingState());
    await DioHelper.getData(
      url: '${EndPointsConstants.users}/$userId/${EndPointsConstants.getManagersAndEmployeesOfUser}',
    ).then((value) {
      print(value?.data);
      getManagersAndEmployeesOfUserModel = GetManagersAndEmployeesOfUserModel.fromMap(value?.data);
      emit(GetManagersAndEmployeesOfUserSuccessState());
    }).catchError((error) {
      emit(GetManagersAndEmployeesOfUserErrorState());
      print(error.toString());
    });
  }

  void toggleUserSelection(UserModel user, bool isManager) {
    print('initialSelectedManagers: ${initialSelectedManagers.length}');
    print('initialSelectedEmployees: ${initialSelectedEmployees.length}');
    if (isManager) {
      if (selectedManagers.contains(user)) {
        selectedManagers.remove(user);
      } else {
        selectedManagers.add(user);
      }
    } else {
      if (selectedEmployees.contains(user)) {
        selectedEmployees.remove(user);
      } else {
        selectedEmployees.add(user);
      }
    }

    emit(ToggleUsersSelectionState());
  }

  void usersSearch(String query, bool isManager) {
    if (isManager) {
      filteredManagers = reorderedUsersListForManagers.where((user) => user.name!.toLowerCase().contains(query.toLowerCase())).toList();
    } else {
      filteredEmployees = reorderedUsersListForEmployees.where((user) => user.name!.toLowerCase().contains(query.toLowerCase())).toList();
    }
    emit(UsersSearchState());
  }

  AddEditManagerEmployeesModel? addEditManagerEmployeesModel;

  void addEditManagerEmployees({required int managerId, required List<UserModel> employeesUsers}) {
    emit(AddEditManagerEmployeesLoadingState());
    DioHelper.postData(url: EndPointsConstants.addEditManagerEmployees, data: {
      'manager_id': managerId,
      'employee_ids': FormatUtils.formatList<UserModel>(employeesUsers, (user) => user?.id.toString()),
      'is_remove': employeesUsers.isEmpty
    }).then((value) {
      print(value?.data);
      addEditManagerEmployeesModel = AddEditManagerEmployeesModel.fromMap(value?.data);
      if (addEditManagerEmployeesModel!.status == true) initialSelectedEmployees = List.from(selectedEmployees);
      emit(AddEditManagerEmployeesSuccessState());
    }).catchError((error) {
      emit(AddEditManagerEmployeesErrorState());
      print(error.toString());
    });
  }

  StatusMessageModel? assignEmployeeForManagersModel;

  void assignEmployeeForManagers({required int employeeId, required List<UserModel> managersUsers}) {
    emit(AssignEmployeeForManagersLoadingState());
    DioHelper.postData(url: EndPointsConstants.assignEmployeeForManagers, data: {
      'employee_id': employeeId,
      'manager_ids': managersUsers.map((manager) => manager.id).toList(),
    }).then((value) {
      print(value?.data);
      assignEmployeeForManagersModel = StatusMessageModel.fromMap(value?.data);
      if (assignEmployeeForManagersModel!.status == true) initialSelectedManagers = List.from(selectedManagers);
      emit(AssignEmployeeForManagersSuccessState());
    }).catchError((error) {
      emit(AssignEmployeeForManagersErrorState());
      print(error.toString());
    });
  }
}
