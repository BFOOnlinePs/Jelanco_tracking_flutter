import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/departments_mixin/departments_mixin_states.dart';
import 'package:jelanco_tracking_system/models/departments_models/get_departments_model.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

mixin DepartmentsMixin<T extends DepartmentsMixinStates> on Cubit<T> {
  GetDepartmentsModel? _getDepartmentsModel;

  GetDepartmentsModel? get getDepartmentsModel => _getDepartmentsModel;

  void getAllDepartments() {
    emit(DepartmentsMixinInitialState() as T);
    DioHelper.getData(url: EndPointsConstants.departments).then((value) {
      print(value?.data);
      _getDepartmentsModel = GetDepartmentsModel.fromMap(value?.data);
    }).catchError((error) {
      print(error.toString());
    });
  }
}
