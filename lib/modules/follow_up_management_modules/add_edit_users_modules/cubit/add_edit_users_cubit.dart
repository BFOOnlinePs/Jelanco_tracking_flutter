import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/formats_utils.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/users_mixin/users_mixin.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/models/manager_employees_models/add_edit_manager_employees_model.dart';
import 'package:jelanco_tracking_system/models/manager_employees_models/delete_manager_model.dart';
import 'package:jelanco_tracking_system/models/manager_employees_models/manager_employees_model.dart';
import 'package:jelanco_tracking_system/modules/follow_up_management_modules/add_edit_users_modules/cubit/add_edit_users_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class AddEditUsersCubit extends Cubit<AddEditUsersStates> with UsersMixin<AddEditUsersStates> {
  AddEditUsersCubit() : super(AddEditUsersInitialState());

  static AddEditUsersCubit get(context) => BlocProvider.of(context);

  List<UserModel> allUsers = [];
  UserModel? managerUser;
  List<UserModel> employeesUsers = []; // Selected users for follow-up
  List<UserModel> filteredAllUsers = []; // Filtered list of all users
  String searchTextAll = '';

  void initValues(int? selectedUserId) async {
    // Initialize selected user if provided map first id
    if (allUsers.any((user) => user.id == selectedUserId)) {
      managerUser = allUsers.firstWhere((user) => user.id == selectedUserId);
    } else {
      managerUser = null;
    }
    if (managerUser != null) {
      await getManagerEmployeesById(managerUser!.id!);
      setInitialSelectedUsers(getManagerEmployeesByIdModel?.managerEmployees ?? []);
    }
    emit(InitValuesState());
  }

  void usersSearch(String query) {
    searchTextAll = query;
    filteredAllUsers =
        allUsers.where((user) => user.name!.toLowerCase().contains(query.toLowerCase())).toList();
    emit(UsersSearchState());
  }

  void selectManager(UserModel? user) async {
    managerUser = user; // Set the selected user
    await getManagerEmployeesById(managerUser!.id!);
    setInitialSelectedUsers(getManagerEmployeesByIdModel?.managerEmployees ?? []);
    emit(SelectManagerState());
  }

  GetManagerEmployeesModel? getManagerEmployeesByIdModel;

  Future<void> getManagerEmployeesById(int managerId) async {
    emit(GetManagerEmployeesByIdLoadingState());
    await DioHelper.getData(url: '${EndPointsConstants.managerEmployees}/$managerId', query: {
      'manager_id': managerId,
    }).then((value) {
      print(value?.data);
      getManagerEmployeesByIdModel = GetManagerEmployeesModel.fromMap(value?.data);
      emit(GetManagerEmployeesByIdSuccessState());
    }).catchError((error) {
      emit(GetManagerEmployeesByIdErrorState());
      print(error.toString());
    });
  }

  // set the selected users
  void setInitialSelectedUsers(List<UserModel> selectedUsers) {
    print('employeesUsers before: $employeesUsers');
    employeesUsers =
        allUsers.where((user) => selectedUsers.any((selectedUser) => selectedUser.id == user.id)).toList();
    print('employeesUsers after: $employeesUsers');
    emit(SetInitialSelectedUsersState());
  }

  void toggleEmployeeSelection(UserModel user) {
    if (employeesUsers.contains(user)) {
      employeesUsers.remove(user);
    } else {
      employeesUsers.add(user);
    }
    emit(ToggleUsersSelectionState());
  }

  DeleteManagerModel? deleteManagerModel;

  void deleteManager() {
    emit(DeleteManagerLoadingState());
    DioHelper.postData(url: EndPointsConstants.deleteManager, data: {
      'manager_id': managerUser?.id,
    }).then((value) {
      print(value?.data);
      deleteManagerModel = DeleteManagerModel.fromMap(value?.data);
      emit(DeleteManagerSuccessState(deleteManagerModel!));
    }).catchError((error) {
      emit(DeleteManagerErrorState());
      print(error.toString());
    });
  }

  AddEditManagerEmployeesModel? addEditManagerEmployeesModel;

  void addEditManagerEmployees() {
    emit(AddEditManagerEmployeesLoadingState());
    DioHelper.postData(url: EndPointsConstants.addEditManagerEmployees, data: {
      'manager_id': managerUser?.id,
      'employee_ids': FormatUtils.formatList<UserModel>(employeesUsers, (user) => user?.id.toString()),
      // 'is_remove': employeesUsers.isEmpty ? true : false
    }).then((value) {
      print(value?.data);
      addEditManagerEmployeesModel = AddEditManagerEmployeesModel.fromMap(value?.data);
      emit(AddEditManagerEmployeesSuccessState(addEditManagerEmployeesModel!));
    }).catchError((error) {
      emit(AddEditManagerEmployeesErrorState());
      print(error.toString());
    });
  }
}
