import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/formats_utils.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/departments_mixin/departments_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/password_visibility_mixin/password_visibility_mixin.dart';
import 'package:jelanco_tracking_system/models/basic_models/department_model.dart';
import 'package:jelanco_tracking_system/models/users_models/add_user_model.dart';
import 'package:jelanco_tracking_system/modules/users_management_modules/add_user_modules/cubit/add_user_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class AddUserCubit extends Cubit<AddUserStates> with PasswordVisibilityMixin<AddUserStates>, DepartmentsMixin<AddUserStates> {
  AddUserCubit() : super(AddUserInitialState());

  static AddUserCubit get(context) => BlocProvider.of(context);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController jobTitleController = TextEditingController();
  List<DepartmentModel> selectedDepartments = [];

  String? validatePhoneAndEmail() {
    if (phoneController.text.isEmpty && emailController.text.isEmpty) {
      return 'يجب ادخال رقم الهاتف او البريد الالكتروني';
    }
    return null;
  }

  AddUserModel? addUserModel;

  void addNewUser() {
    emit(AddUserLoadingState());
    DioHelper.postData(url: EndPointsConstants.users, data: {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'password': passwordController.text,
      'job_title': jobTitleController.text,
      'departments': selectedDepartments.isEmpty
          ? null
          : FormatUtils.formatList<DepartmentModel>(selectedDepartments, (department) => department?.dId.toString()),
    }).then((value) {
      print(value?.data);
      addUserModel = AddUserModel.fromMap(value?.data);
      emit(AddUserSuccessState(addUserModel!));
    }).catchError((error) {
      emit(AddUserErrorState());
      print(error.toString());
    });
  }
}
