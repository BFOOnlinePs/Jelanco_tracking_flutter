import 'package:jelanco_tracking_system/models/tasks_models/edit_task_model.dart';

abstract class EditTaskStates {}

class EditTaskInitialState extends EditTaskStates {}

class CategoriesMixinStates extends EditTaskStates {} // for the mixin

class UsersMixinStates extends EditTaskStates {} // for the mixin

class InitialValuesState extends EditTaskStates {}

class FilterUsersOnSearchState extends EditTaskStates {}

class CheckBoxChangedState extends EditTaskStates {}

class PlannedTimePickedState extends EditTaskStates {}

class EmitAfterReturnState extends EditTaskStates {}

class ChangeSelectedCategoryState extends EditTaskStates {}

class ChangeSelectedTaskStatusState extends EditTaskStates {}

class EditTaskLoadingState extends EditTaskStates {}

class EditTaskSuccessState extends EditTaskStates {
  final EditTaskModel editTaskModel;

  EditTaskSuccessState({required this.editTaskModel});
}

class EditTaskErrorState extends EditTaskStates {
  final String error;

  EditTaskErrorState({required this.error});
}

class EmitLoadingState extends EditTaskStates {}

class PickMediaFromCameraState extends EditTaskStates {}

class PickMultipleImagesState extends EditTaskStates {}

class DeletePickedImageFromListState extends EditTaskStates {}

class CompressAllImagesLoadingState extends EditTaskStates {}

class CompressAllImagesSuccessState extends EditTaskStates {}

class PickVideoState extends EditTaskStates {}

class InitializeVideoControllerState extends EditTaskStates {}

class DeletePickedVideoFromListState extends EditTaskStates {}

class ToggleVideoPlayPauseState extends EditTaskStates {}

class CompressAllVideosSuccessState extends EditTaskStates {}

class AddTaskFileSelectSuccessState extends EditTaskStates {}

class DeletePickedFilesFromListState extends EditTaskStates {}

class AddTaskFileSelectErrorState extends EditTaskStates {
  final String error;

  AddTaskFileSelectErrorState({required this.error});
}

// Categories Mixin

class CategoriesLoadingState extends EditTaskStates {}

class CategoriesSuccessState extends EditTaskStates {}

class CategoriesErrorState extends EditTaskStates {
  final String error;

  CategoriesErrorState({required this.error});
}

// Manager Employees Mixin

class GetManagerEmployeesLoadingState extends EditTaskStates {}

class GetManagerEmployeesSuccessState extends EditTaskStates {}

class GetManagerEmployeesErrorState extends EditTaskStates {}

// compress video mixin

class CompressVideoLoadingState extends EditTaskStates {}

class CompressVideoSuccessState extends EditTaskStates {}

class CompressVideoErrorState extends EditTaskStates {
  final String error;

  CompressVideoErrorState({required this.error});
}
