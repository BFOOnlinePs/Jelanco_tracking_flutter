import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/users_mixin/users_mixin.dart';
import 'package:jelanco_tracking_system/modules/follow_up_management_modules/add_edit_users_modules/cubit/add_edit_users_states.dart';

class AddEditUsersCubit extends Cubit<AddEditUsersStates> with UsersMixin<AddEditUsersStates> {
  AddEditUsersCubit() : super(AddEditUsersInitialState());

  static AddEditUsersCubit get(context) => BlocProvider.of(context);





}
