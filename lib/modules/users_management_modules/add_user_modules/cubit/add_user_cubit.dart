import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/departments_mixin/departments_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/password_visibility_mixin/password_visibility_mixin.dart';
import 'package:jelanco_tracking_system/modules/users_management_modules/add_user_modules/cubit/add_user_states.dart';

class AddUserCubit extends Cubit<AddUserStates> with PasswordVisibilityMixin<AddUserStates>, DepartmentsMixin<AddUserStates> {
  AddUserCubit() : super(AddUserInitialState());

  static AddUserCubit get(context) => BlocProvider.of(context);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController jobTitleController = TextEditingController();
}
