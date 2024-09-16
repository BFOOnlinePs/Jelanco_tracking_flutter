import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/manager_employees_models/manager_employees_model.dart';
import 'package:jelanco_tracking_system/modules/manager_employees_modules/cubit/manager_employees_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class ManagerEmployeesCubit extends Cubit<ManagerEmployeesStates> {
  ManagerEmployeesCubit() : super(ManagerEmployeesInitialState());

  static ManagerEmployeesCubit get(context) => BlocProvider.of(context);

  GetManagerEmployeesModel? getManagerEmployeesModel;

  Future<void> getManagerEmployees() async {
    emit(GetManagerEmployeesLoadingState());
    await DioHelper.getData(
      url: EndPointsConstants.managerEmployees,
    ).then((value) {
      print(value?.data);
      getManagerEmployeesModel = GetManagerEmployeesModel.fromMap(value?.data);
      emit(GetManagerEmployeesSuccessState());
    }).catchError((error) {
      emit(GetManagerEmployeesErrorState());
      print(error.toString());
    });
  }
}
