import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/models/users_models/get_all_users_model.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

mixin UsersMixin<T> on Cubit<T> {
  GetAllUsersModel? getAllUsersModel;
  List<UserModel> usersList = [];

  bool isUsersLoading = false;
  bool isUsersLastPage = false;

  // is users loading

  Future<void> getAllUsers({
    int pagination = 0, // 0 means no pagination, 1 means pagination
    int page = 1,
    required T loadingState,
    required T successState,
    required T Function(String error) errorState,
  }) async {
    emit(loadingState);
    isUsersLoading = true;

    await DioHelper.getData(url: EndPointsConstants.users, query: {'paginate': pagination, 'page': page}).then((value) {
      print(value?.data);
      // when refresh
      if (page == 1) {
        usersList.clear();
      }
      getAllUsersModel = GetAllUsersModel.fromMap(value?.data);
      usersList.addAll(getAllUsersModel?.users as Iterable<UserModel>);
      isUsersLastPage = getAllUsersModel?.pagination?.lastPage == getAllUsersModel?.pagination?.currentPage;
      isUsersLoading = false;
      emit(successState);
    }).catchError((error) {
      emit(errorState(error.toString()));
      print(error.toString());
    });
  }
}
