import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/manager_employees_mixin/manager_employees_mixin.dart';
import 'package:jelanco_tracking_system/modules/manager_employees_modules/cubit/manager_employees_states.dart';

class ManagerEmployeesCubit extends Cubit<ManagerEmployeesStates>
    with ManagerEmployeesMixin<ManagerEmployeesStates> {
  ManagerEmployeesCubit() : super(ManagerEmployeesInitialState());

  static ManagerEmployeesCubit get(context) => BlocProvider.of(context);
}
