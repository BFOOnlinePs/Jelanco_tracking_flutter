import 'package:dio/dio.dart';
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

  CancelToken? cancelToken;

  Future<void> getAllUsers({
    int pagination = 0, // 0 means no pagination, 1 means with pagination
    int page = 1,
    String? search,
    required T loadingState,
    required T successState,
    required T Function(String error) errorState,
  }) async {
    emit(loadingState);
    isUsersLoading = true;

    // Cancel previous request
    cancelToken?.cancel();
    // Create a new token for the current request
    cancelToken = CancelToken();

    await DioHelper.getData(
      url: EndPointsConstants.users,
      query: {'search': search, 'paginate': pagination, 'page': page},
      cancelToken: cancelToken,
    ).then((value) {
      print(value?.data);
      // when cancel the request (on search), it returns Null
      if (value?.data != null) {
        // when refresh
        if (page == 1) {
          usersList.clear();
        }

        getAllUsersModel = GetAllUsersModel.fromMap(value?.data);
        usersList.addAll(getAllUsersModel?.users as Iterable<UserModel>);
        isUsersLastPage = getAllUsersModel?.pagination?.lastPage == getAllUsersModel?.pagination?.currentPage;
        isUsersLoading = false;
        emit(successState);
      } else {
        print('Response data is null');
      }
    }).catchError((error) {
      emit(errorState(error.toString()));
      print(error.toString());
    });
  }
}
