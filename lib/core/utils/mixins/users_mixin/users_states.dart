import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_cubit/add_task_states.dart';

class GetAllUsersLoadingState extends UsersMixinStates {}

class GetAllUsersSuccessState extends UsersMixinStates {}

class GetAllUsersErrorState extends UsersMixinStates {
  final String error;

  GetAllUsersErrorState({required this.error});
}
