import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/event_buses/submissions_event_bus.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/network/remote/socket_io.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_comment_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/get_task_with_submissions_and_comments_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class TaskDetailsCubit extends Cubit<TaskDetailsStates> {
  TaskDetailsCubit() : super(TaskDetailsInitialState()) {
    print('in cubit');
    // Listen for TaskUpdatedEvent from EventBus
    eventBus.on<TaskUpdatedEvent>().listen((event) {
      print('in cubit eventBus: ${event.submission.tsId}');
      print('in cubit eventBus: ${event.submission.tsParentId}');
      // Update the task in the current submissions list
      // event.submission.tsParentId id is the old submission id
      int? index = getTaskWithSubmissionsAndCommentsModel?.task?.taskSubmissions!
          .indexWhere((submission) => submission.tsId == event.submission.tsParentId);

      if (index != -1) {
        // Replace the old submission with the new one
        getTaskWithSubmissionsAndCommentsModel?.task?.taskSubmissions![index!] = event.submission;
      }

      // Emit the updated state with the updated task list
      print('in cubit eventBus: ${event.submission.tsId}');
      emit(TasksUpdatedStateViaEventBus());
    });
  }

  static TaskDetailsCubit get(context) => BlocProvider.of(context);

  final SocketIO commentService = SocketIO();

  void listenToNewComments() {
    print('listenToNewComments');
    // the sender is: socket.emit('new-comment', data);
    commentService.socket.on('new-comment', (data) {
      print('from screen Socket.IO New comment received:: $data');
      // Update the state with the new comment
      TaskSubmissionCommentModel newComment = TaskSubmissionCommentModel.fromMap(data);
      print('newComment.tscId: ${newComment.tscId}');
      // add the new comment for the task submission of id

      getTaskWithSubmissionsAndCommentsModel?.task?.taskSubmissions
          ?.firstWhere((submission) => submission.tsId == newComment.tscTaskSubmissionId)
          .submissionComments
          ?.add(newComment);

      // getTaskWithSubmissionsAndCommentsModel?.task.taskSubmissions?.add(newComment);
      emit(ListenToNewCommentsState());
    });
  }

  ScrollController scrollController = ScrollController();

  GetTaskWithSubmissionsAndCommentsModel? getTaskWithSubmissionsAndCommentsModel;

  Future<void> getTaskWithSubmissionsAndComments({required int taskId}) async {
    emit(TaskDetailsLoadingState());
    await DioHelper.getData(
      url: '${EndPointsConstants.tasks}/$taskId/${EndPointsConstants.tasksWithSubmissionsAndComments}',
    ).then((value) async {
      print(value?.data);
      getTaskWithSubmissionsAndCommentsModel = GetTaskWithSubmissionsAndCommentsModel.fromMap(value?.data);

      emit(TaskDetailsSuccessState());
    }).catchError((error) {
      emit(TaskDetailsErrorState(error: error.toString()));
      print(error.toString());
    });
  }

  // void afterEditSubmission({
  //   required int oldSubmissionId,
  //   required final TaskSubmissionModel newSubmissionModel,
  // }) {
  //   // Replace the old submission with the new one
  //   // Find the index of the submission with the old ID
  //   int? index = getTaskWithSubmissionsAndCommentsModel?.task?.taskSubmissions!
  //       .indexWhere((submission) => submission.tsId == oldSubmissionId);
  //
  //   if (index != -1) {
  //     // Replace the old submission with the new one
  //     getTaskWithSubmissionsAndCommentsModel?.task?.taskSubmissions![index!] = newSubmissionModel;
  //
  //     print(getTaskWithSubmissionsAndCommentsModel?.task?.taskSubmissions![index!].toMap());
  //   }
  //   emit(AfterEditSubmissionState());
  // }

  void afterEditTask({
    // required int oldTaskId,
    required final TaskModel newTaskModel,
  }) {
    // recall the function
    getTaskWithSubmissionsAndComments(taskId: newTaskModel.tId!);

    emit(AfterEditTaskState());
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    commentService.socket.off('new-comment');
    return super.close();
  }
}
