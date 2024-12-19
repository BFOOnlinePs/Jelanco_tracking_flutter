import 'package:jelanco_tracking_system/core/utils/mixins/departments_mixin/departments_mixin_states.dart';

abstract class AddUserStates extends  DepartmentsMixinStates {}

class AddUserInitialState extends AddUserStates {}

class TogglePasswordVisibilityState extends AddUserStates {}
