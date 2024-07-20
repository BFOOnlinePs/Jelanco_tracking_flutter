import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/core/values/cache_keys.dart';
import 'package:jelanco_tracking_system/models/auth_models/user_logout_model.dart';
import 'package:jelanco_tracking_system/network/local/cache_helper.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';
import 'package:jelanco_tracking_system/widgets/my_drawer/drawer_cubit/drawer_states.dart';

class DrawerCubit extends Cubit<DrawerStates> {
  DrawerCubit() : super(DrawerInitialState());

  static DrawerCubit get(context) => BlocProvider.of(context);

  UserLogoutModel? userLogoutModel;

  void userLogout() {
    emit(LogoutLoadingState());
    DioHelper.postData(
      url: EndPointsConstants.logout,
    ).then((value) {
      print(value);
      userLogoutModel = UserLogoutModel.fromMap(value?.data);
      CacheHelper.removeData(key: MyCacheKeys.token).then((value) async {
        CacheHelper.removeData(key: MyCacheKeys.userId);
        UserDataConstants.userModel = null; // empty it so the data of previous user did not show
        // await FCMServices.deleteFCMTokenFromLocalAndServer(firebaseTokenVar!);
        emit(LogoutSuccessState(userLogoutModel: userLogoutModel!));
      });
    }).catchError((error) {
      emit(LogoutErrorState(error: error.toString()));
      print(error);
    });
  }
}