import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/auth_models/user_login_model.dart';
import 'package:jelanco_tracking_system/modules/auth/login_modules/login_cubit/login_states.dart';

import '../../../../network/remote/dio_helper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  UserLoginModel? userLoginModel;

  void userLogin() {
    emit(LoginLoadingState());
    DioHelper.postData(url: EndPointsConstants.login, data: {
      'email': emailController.text,
      'password': passwordController.text,
    }).then((value) {
      print('userLogin method');
      print(value?.data);
      userLoginModel = UserLoginModel.fromMap(value?.data);
      emit(LoginSuccessState(userLoginModel: userLoginModel!));
    }).catchError((error) {
      emit(LoginErrorState(error: error.toString()));
      print(error);
    });
  }
}
