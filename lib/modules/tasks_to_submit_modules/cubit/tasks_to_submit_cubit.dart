import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/tasks_to_submit_mixin/tasks_to_submit_mixin.dart';
import 'package:jelanco_tracking_system/modules/tasks_to_submit_modules/cubit/tasks_to_submit_states.dart';

class TasksToSubmitCubit extends Cubit<TasksToSubmitStates>
    with TasksToSubmitMixin<TasksToSubmitStates> {
  TasksToSubmitCubit() : super(TasksToSubmitInitialState());

  static TasksToSubmitCubit get(context) =>
      BlocProvider.of<TasksToSubmitCubit>(context);
}
