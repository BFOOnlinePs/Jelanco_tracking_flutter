import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/categories_mixin/categories_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/users_mixin/users_mixin.dart';
import 'package:jelanco_tracking_system/models/tasks_models/edit_task_model.dart';
import 'package:jelanco_tracking_system/modules/edit_task_modules/edit_task_cubit/edit_task_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class EditTaskCubit extends Cubit<EditTaskStates> with UsersMixin, CategoriesMixin{
  EditTaskCubit() : super(EditTaskInitialState());

  static EditTaskCubit get(context) => BlocProvider.of(context);

  // EditTaskErrorState
  // EditTaskSuccessState

  EditTaskModel? editTaskModel;

  void editTask({required int taskId}) {
    emit(EditTaskLoadingState());
    DioHelper.postData(url: '${EndPointsConstants.tasks}/$taskId')
        .then((value) {
      print(value?.data);
      editTaskModel = EditTaskModel.fromMap(value?.data);
      emit(EditTaskSuccessState(editTaskModel: editTaskModel!));
    }).catchError((error) {
      emit(EditTaskErrorState(error: error.toString()));
      print(error.toString());
    });
  }
}
