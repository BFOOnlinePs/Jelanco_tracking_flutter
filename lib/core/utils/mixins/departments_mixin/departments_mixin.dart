import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/departments_models/get_departments_model.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

mixin DepartmentsMixin<T> on Cubit<T> {
  GetDepartmentsModel? _getDepartmentsModel;

  GetDepartmentsModel? get getDepartmentsModel => _getDepartmentsModel;

  Future<void> getAllDepartments({required T loadingState, required T successState, required T errorState}) async {
    emit(loadingState);
    await DioHelper.getData(url: EndPointsConstants.departments).then((value) {
      print(value?.data);
      _getDepartmentsModel = GetDepartmentsModel.fromMap(value?.data);
      emit(successState);
    }).catchError((error) {
      print(error.toString());
      emit(errorState);
    });
  }
}
