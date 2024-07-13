import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/categories_mixin/categories_mixin.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_category_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/add_task_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_cubit/add_task_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class AddTaskCubit extends Cubit<AddTaskStates>
    with CategoriesMixin<AddTaskStates> {
  AddTaskCubit() : super(AddTaskInitialState());

  static AddTaskCubit get(context) => BlocProvider.of(context);

  // error
  // success
  // loading

  final formKey = GlobalKey<FormState>();
  String content = '';
  DateTime? plannedStartTime;
  DateTime? plannedEndTime;
  TaskCategoryModel? selectedCategory;
  List<String> assignedTo = [];

  Future<void> selectDateTime(BuildContext context, bool isStartTime) async {
    DateTime initialDate = isStartTime
        ? (plannedStartTime ?? DateTime.now())
        : (plannedEndTime ?? DateTime.now());

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        // setState(() {
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
        // });
      }
    }
  }

  AddTaskModel? addTaskModel;

  void addTask() {
    emit(AddTaskLoadingState());
    DioHelper.postData(url: EndPointsConstants.tasks).then((value) {
      print(value?.data);
      addTaskModel = AddTaskModel.fromMap(value?.data);
      emit(AddTaskSuccessState());
    }).catchError((error) {
      emit(AddTaskErrorState(error: error.toString()));
    });
  }
}
