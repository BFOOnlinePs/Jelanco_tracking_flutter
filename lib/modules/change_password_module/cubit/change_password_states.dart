import 'package:jelanco_tracking_system/models/basic_models/status_message_model.dart';

abstract class ChangePasswordStates {}

class ChangePasswordInitial extends ChangePasswordStates {}

class ChangePasswordLoadingState extends ChangePasswordStates {}

class ChangePasswordSuccessState extends ChangePasswordStates {
  final StatusMessageModel statusMessageModel;

  ChangePasswordSuccessState(this.statusMessageModel);
}

class ChangePasswordErrorState extends ChangePasswordStates {}

class TogglePasswordVisibilityState extends ChangePasswordStates {}
