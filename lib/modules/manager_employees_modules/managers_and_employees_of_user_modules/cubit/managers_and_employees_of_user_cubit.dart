import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/formats_utils.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/users_mixin/users_mixin.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/models/manager_employees_models/add_edit_manager_employees_model.dart';
import 'package:jelanco_tracking_system/models/manager_employees_models/get_managers_and_employees_of_user_model.dart';
import 'package:jelanco_tracking_system/modules/manager_employees_modules/managers_and_employees_of_user_modules/cubit/managers_and_employees_of_user_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class ManagersAndEmployeesOfUserCubit extends Cubit<ManagersAndEmployeesOfUserStates> with UsersMixin<ManagersAndEmployeesOfUserStates> {
  ManagersAndEmployeesOfUserCubit() : super(ManagersAndEmployeesOfUserInitialState());

  static ManagersAndEmployeesOfUserCubit get(context) => BlocProvider.of(context);

  List<UserModel> selectedManagers = [];
  List<UserModel> filteredManagers = [];
  List<UserModel> selectedEmployees = [];
  List<UserModel> filteredEmployees = [];

  void enterScreenActions({required int userId}) async {
    await Future.wait([
      getManagersAndEmployeesOfUser(userId: userId),
      getAllUsers(
          loadingState: GetAllUsersLoadingState(), successState: GetAllUsersSuccessState(), errorState: (error) => GetAllUsersErrorState()),
    ]);

    selectedManagers =
        getManagersAndEmployeesOfUserModel?.managerIds?.map((id) => usersList.firstWhere((user) => user.id == id)).toList() ?? [];
    selectedEmployees =
        getManagersAndEmployeesOfUserModel?.employeeIds?.map((id) => usersList.firstWhere((user) => user.id == id)).toList() ?? [];
    emit(EnterScreenActionsState());
    print('selectedManagers: ${selectedManagers.length}');
    print('selectedEmployees: ${selectedEmployees.length}');
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
      filteredManagers = usersList.where((user) => user.name!.toLowerCase().contains(query.toLowerCase())).toList();
    } else {
      filteredEmployees = usersList.where((user) => user.name!.toLowerCase().contains(query.toLowerCase())).toList();
    }
    emit(UsersSearchState());
  }

  AddEditManagerEmployeesModel? addEditManagerEmployeesModel;

  void addEditManagerEmployees({required int managerId, required List<UserModel> employeesUsers}) {
    emit(AddEditManagerEmployeesLoadingState());
    DioHelper.postData(url: EndPointsConstants.addEditManagerEmployees, data: {
      'manager_id': managerId,
      'employee_ids': FormatUtils.formatList<UserModel>(employeesUsers, (user) => user?.id.toString()),
    }).then((value) {
      print(value?.data);
      addEditManagerEmployeesModel = AddEditManagerEmployeesModel.fromMap(value?.data);
      emit(AddEditManagerEmployeesSuccessState(addEditManagerEmployeesModel!));
    }).catchError((error) {
      emit(AddEditManagerEmployeesErrorState());
      print(error.toString());
    });
  }

  /// todo: model
  void assignEmployeeForManagers({required int employeeId, required List<UserModel> managersUsers}) {
    emit(AssignEmployeeForManagersLoadingState());
    DioHelper.postData(url: EndPointsConstants.assignEmployeeForManagers, data: {
      'employee_id': employeeId,
      'manager_ids': managersUsers.map((manager) => manager.id).toList(),
    }).then((value) {
      print(value?.data);
      emit(AssignEmployeeForManagersSuccessState());
    }).catchError((error) {
      emit(AssignEmployeeForManagersErrorState());
      print(error.toString());
    });
  }
}
