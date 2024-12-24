import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/users_mixin/users_mixin.dart';
import 'package:jelanco_tracking_system/modules/users_management_modules/cubit/users_management_states.dart';

class UsersManagementCubit extends Cubit<UsersManagementStates> with UsersMixin<UsersManagementStates>{
  UsersManagementCubit() : super(UsersManagementInitialState());

  static UsersManagementCubit get(context) => BlocProvider.of(context);

  TextEditingController searchController = TextEditingController();
}