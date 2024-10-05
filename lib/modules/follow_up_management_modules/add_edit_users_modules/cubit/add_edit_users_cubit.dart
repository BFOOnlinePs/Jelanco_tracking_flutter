import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/formats_utils.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/users_mixin/users_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/models/manager_employees_models/add_edit_manager_employees_model.dart';
import 'package:jelanco_tracking_system/models/manager_employees_models/manager_employees_model.dart';
import 'package:jelanco_tracking_system/modules/follow_up_management_modules/add_edit_users_modules/cubit/add_edit_users_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class AddEditUsersCubit extends Cubit<AddEditUsersStates> with UsersMixin<AddEditUsersStates> {
  AddEditUsersCubit() : super(AddEditUsersInitialState());

  static AddEditUsersCubit get(context) => BlocProvider.of(context);

  List<UserModel> allUsers = [];
  List<UserModel> employeesUsers = []; // Selected users for follow-up
  List<UserModel> filteredAllUsers = []; // Filtered list of all users
  String searchTextAll = '';
  UserModel? managerUser;

  void initValues(UserModel? selectedUser) {
    // Initialize selected user if provided
    managerUser = selectedUser; // Set the selected user from widget
  }

  void usersSearch(String query) {
    // setState(() {
    searchTextAll = query;
    filteredAllUsers =
        allUsers.where((user) => user.name!.toLowerCase().contains(query.toLowerCase())).toList();
    // });
    emit(UsersSearchState());
  }

  void selectManager(UserModel user) {
    // setState(() {
    managerUser = user; // Set the selected user
    // });
  }

  GetManagerEmployeesModel? getManagerEmployeesByIdModel;

  void getManagerEmployeesById(int managerId) {
    emit(GetManagerEmployeesByIdLoadingState());
    DioHelper.getData(url: '${EndPointsConstants.managerEmployees}/$managerId', query: {
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

  void toggleEmployeeSelection(UserModel user) {
    // setState(() {
    if (employeesUsers.contains(user)) {
      employeesUsers.remove(user);
    } else {
      employeesUsers.add(user);
    }
    // });

    emit(ToggleUsersSelectionState());
  }

  AddEditManagerEmployeesModel? addEditManagerEmployeesModel;

  void addEditManagerEmployees() {
    emit(AddEditManagerEmployeesLoadingState());
    DioHelper.postData(url: EndPointsConstants.addEditManagerEmployees, data: {
      'manager_id': managerUser?.id,
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
}
