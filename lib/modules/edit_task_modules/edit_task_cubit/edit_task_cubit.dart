import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/formats_utils.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/categories_mixin/categories_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/manager_employees_mixin/manager_employees_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/users_mixin/users_mixin.dart';
import 'package:jelanco_tracking_system/enums/task_status_enum.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_category_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/edit_task_model.dart';
import 'package:jelanco_tracking_system/modules/edit_task_modules/edit_task_cubit/edit_task_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class EditTaskCubit extends Cubit<EditTaskStates>
    with CategoriesMixin<EditTaskStates>, ManagerEmployeesMixin<EditTaskStates> {
  EditTaskCubit() : super(EditTaskInitialState());

  static EditTaskCubit get(context) => BlocProvider.of(context);

  // EditTaskErrorState
  // EditTaskSuccessState

  GlobalKey<FormState> editTaskFormKey = GlobalKey<FormState>();
  TextEditingController contentController = TextEditingController();

  DateTime? plannedStartTime;
  DateTime? plannedEndTime;
  TaskCategoryModel? selectedCategory;
  List<UserModel> selectedUsers = [];
  TaskStatusEnum? selectedTaskStatusEnum;

  void initialValues({
    String? content,
    DateTime? startTime,
    DateTime? endTime,
    TaskStatusEnum? taskStatus,
  }) {
    contentController.text = content ?? '';
    plannedStartTime = startTime;
    plannedEndTime = endTime;
    selectedTaskStatusEnum = taskStatus;
    emit(InitialValuesState());
  }

  Future<void> selectDateTime(
      BuildContext context, bool isStartTime, TaskModel task) async {
    DateTime initialDate = isStartTime // when reopen
        ? (plannedStartTime ?? DateTime.now())
        : (plannedEndTime ?? DateTime.now());

    // DateTime? temp;
    // if(plannedStartTime != null && plannedEndTime != null ) {
    //   temp = plannedStartTime!.isBefore(plannedEndTime!)
    //       ? plannedStartTime
    //       : plannedEndTime;
    // }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      // firstDate: DateTime(2000),
      // lastDate: DateTime(2101),
      firstDate: task.createdAt ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        final selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        if (isStartTime) {
          plannedStartTime = selectedDateTime;
        } else {
          plannedEndTime = selectedDateTime;
        }
        emit(PlannedTimePickedState());
      }
    }
  }

  // after pop from AssignedToScreen
  void emitAfterReturn() {
    emit(EmitAfterReturnState());
  }

  void changeSelectedCategory(
      {required TaskCategoryModel? newSelectedCategory}) {
    selectedCategory = newSelectedCategory;
    emit(ChangeSelectedCategoryState());
  }

  void changeSelectedTaskStatus({required TaskStatusEnum taskStatusEnum}) {
    selectedTaskStatusEnum = taskStatusEnum;
    emit(ChangeSelectedTaskStatusState());
  }

  // edit

  EditTaskModel? editTaskModel;

  void editTask({required int taskId}) {
    emit(EditTaskLoadingState());
    Map<String, dynamic> dataObject = {
      'content': contentController.text,
      'start_time': plannedStartTime?.toString(),
      'end_time': plannedEndTime?.toString(),
      'category_id': selectedCategory?.cId,
      'assigned_to': FormatUtils.formatList<UserModel>(
          selectedUsers, (user) => user?.id.toString()),
      'status': selectedTaskStatusEnum!.statusName,
    };
    DioHelper.postData(
            url: '${EndPointsConstants.tasks}/$taskId', data: dataObject)
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
