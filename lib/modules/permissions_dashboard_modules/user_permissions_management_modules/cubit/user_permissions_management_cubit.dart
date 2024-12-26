import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/users_mixin/users_mixin.dart';
import 'package:jelanco_tracking_system/modules/permissions_dashboard_modules/user_permissions_management_modules/cubit/user_permissions_management_states.dart';

class UserPermissionsManagementCubit extends Cubit<UserPermissionsManagementStates> with UsersMixin<UserPermissionsManagementStates> {
  UserPermissionsManagementCubit() : super(UserPermissionsManagementInitialState());

  static UserPermissionsManagementCubit get(context) => BlocProvider.of(context);
}
