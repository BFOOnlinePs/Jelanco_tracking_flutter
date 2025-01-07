import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/password_visibility_mixin/password_visibility_mixin.dart';
import 'package:jelanco_tracking_system/models/basic_models/status_message_model.dart';
import 'package:jelanco_tracking_system/modules/change_password_module/cubit/change_password_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordStates> with PasswordVisibilityMixin<ChangePasswordStates> {
  ChangePasswordCubit() : super(ChangePasswordInitial());

  static ChangePasswordCubit get(context) => BlocProvider.of(context);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  StatusMessageModel? statusMessageModel;

  void changePassword() {
    if (formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      emit(ChangePasswordLoadingState());
      DioHelper.postData(
        url: EndPointsConstants.changePassword,
        data: {'password': passwordController.text},
      ).then((value) {
        print(value?.data);
        statusMessageModel = StatusMessageModel.fromMap(value?.data);
        emit(ChangePasswordSuccessState(statusMessageModel!));
      }).catchError((error) {
        emit(ChangePasswordErrorState());
        print(error.toString());
      });
    }
  }
}
