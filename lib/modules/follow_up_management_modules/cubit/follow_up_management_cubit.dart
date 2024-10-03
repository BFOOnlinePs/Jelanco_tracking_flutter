import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/models/manager_employees_models/get_managers_model.dart';
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

  void navigateToEditAddScreen(String user) async {
    // final result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => AddEditUsersScreen(selectedUser: user),
    //   ),
    // );

    // if (result != null && result is List<String>) {
    //   // setState(() {
    //     users = result; // Update selected users when returning from edit/add screen
    //     filteredUsers = users; // Update filtered users
    //   // });
    // }
  }
}
