import 'package:jelanco_tracking_system/models/tasks_models/add_task_model.dart';

abstract class AddTaskStates {}

class AddTaskInitialState extends AddTaskStates {}

class PlannedTimePickedState extends AddTaskStates {}

class FilterUsersOnSearchState extends AddTaskStates {}

class CheckBoxChangedState extends AddTaskStates {}

class EmitAfterReturnState extends AddTaskStates {}

class ChangeSelectedCategoryState extends AddTaskStates {}

class ChangeIsAddClickedState extends AddTaskStates {}

class EmitLoadingState extends AddTaskStates {}

class ToggleVideoPlayPauseState extends AddTaskStates {}

class AddTaskLoadingState extends AddTaskStates {}

class AddTaskSuccessState extends AddTaskStates {
  final AddTaskModel addTaskModel;

  AddTaskSuccessState({required this.addTaskModel});
}

class AddTaskErrorState extends AddTaskStates {
  final String error;

  AddTaskErrorState({required this.error});
}

class PickMediaFromCameraState extends AddTaskStates {}

class PickMultipleImagesState extends AddTaskStates {}

class PickVideoState extends AddTaskStates {}

class InitializeVideoControllerState extends AddTaskStates {}

class DeletePickedVideoFromListState extends AddTaskStates {}

class AddTaskFileSelectSuccessState extends AddTaskStates {}

class AddTaskFileSelectErrorState extends AddTaskStates {
  final String error;

  AddTaskFileSelectErrorState({required this.error});
}

class DeletePickedFilesFromListState extends AddTaskStates {}

class DeletePickedImageFromListState extends AddTaskStates {}

// Categories Mixin

class CategoriesLoadingState extends AddTaskStates {}

class CategoriesSuccessState extends AddTaskStates {}

class CategoriesErrorState extends AddTaskStates {
  final String error;

  CategoriesErrorState({required this.error});
}

// Manager Employees Mixin

class GetManagerEmployeesLoadingState extends AddTaskStates {}

class GetManagerEmployeesSuccessState extends AddTaskStates {}

class GetManagerEmployeesErrorState extends AddTaskStates {}

// compress images mixin

class CompressAllImagesLoadingState extends AddTaskStates {}

class CompressAllImagesSuccessState extends AddTaskStates {}

// compress video mixin

class CompressVideoLoadingState extends AddTaskStates {}

class CompressVideoSuccessState extends AddTaskStates {}

class CompressVideoErrorState extends AddTaskStates {
  final String error;

  CompressVideoErrorState({required this.error});
}

class CompressAllVideosSuccessState extends AddTaskStates {}
