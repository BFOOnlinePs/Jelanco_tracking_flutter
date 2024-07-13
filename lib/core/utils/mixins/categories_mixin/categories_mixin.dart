import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/task_categories_models/get_task_categories_model.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';
import 'categories_states.dart';

mixin CategoriesMixin<T> on Cubit<T> {
  GetTaskCategoriesModel? getTaskCategoriesModel;

  // loading on add task
  // error on add task

  void getTaskCategories() {
    emit(CategoriesLoadingState() as T);
    DioHelper.getData(
      url: EndPointsConstants.taskCategories,
    ).then((value) {
      print(value?.data);
      getTaskCategoriesModel = GetTaskCategoriesModel.fromMap(value?.data);
      emit(CategoriesSuccessState()  as T);
    }).catchError((error) {
      emit(CategoriesErrorState(error: error.toString())  as T);
    });
  }
}
