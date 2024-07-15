import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/formats_utils.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/categories_mixin/categories_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/users_mixin/users_mixin.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_category_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/add_task_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_cubit/add_task_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class AddTaskCubit extends Cubit<AddTaskStates>
    with
        CategoriesMixin<AddTaskStates>,
        UsersMixin<AddTaskStates>{
  AddTaskCubit() : super(AddTaskInitialState());

  static AddTaskCubit get(context) => BlocProvider.of(context);

  // error
  // success
  // loading

  final formKey = GlobalKey<FormState>();
  TextEditingController contentController = TextEditingController();

  DateTime? plannedStartTime;
  DateTime? plannedEndTime;
  TaskCategoryModel? selectedCategory;
  List<UserModel> selectedUsers = [];

  Future<void> selectDateTime(BuildContext context, bool isStartTime) async {
    DateTime initialDate = isStartTime
        ? (plannedStartTime ?? DateTime.now()) // when reopen
        : (plannedEndTime ?? DateTime.now());

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      // firstDate: DateTime(2000),
      // lastDate: DateTime(2101),
      firstDate: DateTime.now(),
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
  void changeSelectedUsers(List<UserModel> selectedUsersList){
    selectedUsers = selectedUsersList;
    emit(ChangeSelectedUsersState());
  }

  // add

  AddTaskModel? addTaskModel;

  void addTask() {
    emit(AddTaskLoadingState());
    Map<String, dynamic> dataObject = {
      'content': contentController.text,
      'start_time': plannedStartTime.toString(),
      'end_time': plannedEndTime.toString(),
      'category_id': selectedCategory?.cId,
      'assigned_to': FormatUtils.formatUsersList(selectedUsers),
    };
    print(dataObject.values);
    DioHelper.postData(url: EndPointsConstants.tasks, data: dataObject)
        .then((value) {
      print(value?.data);
      addTaskModel = AddTaskModel.fromMap(value?.data);
      emit(AddTaskSuccessState(addTaskModel: addTaskModel!));
    }).catchError((error) {
      emit(AddTaskErrorState(error: error.toString()));
    });
  }
}
