import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/socket_io.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_comment_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/get_task_with_submissions_and_comments_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class TaskDetailsCubit extends Cubit<TaskDetailsStates> {
  TaskDetailsCubit() : super(TaskDetailsInitialState());

  static TaskDetailsCubit get(context) => BlocProvider.of(context);

  final SocketIO commentService = SocketIO();

  void listenToNewComments() {
    print('listenToNewComments');
    // the sender is: socket.emit('new-comment', data);
    commentService.socket.on('new-comment', (data) {
      print('from screen Socket.IO New comment received:: $data');
      // Update the state with the new comment
      TaskSubmissionCommentModel newComment =
          TaskSubmissionCommentModel.fromMap(data);
      print('newComment.tscId: ${newComment.tscId}');
      // add the new comment for the task submission of id

      getTaskWithSubmissionsAndCommentsModel?.task?.taskSubmissions
          ?.firstWhere(
              (submission) => submission.tsId == newComment.tscTaskSubmissionId)
          ?.submissionComments
          ?.add(newComment);

      // getTaskWithSubmissionsAndCommentsModel?.task.taskSubmissions?.add(newComment);
      emit(ListenToNewCommentsState());
    });
  }

  ScrollController scrollController = ScrollController();

  GetTaskWithSubmissionsAndCommentsModel?
      getTaskWithSubmissionsAndCommentsModel;

  Future<void> getTaskWithSubmissionsAndComments({required int taskId}) async {
    emit(TaskDetailsLoadingState());
    await DioHelper.getData(
      url:
          '${EndPointsConstants.tasks}/$taskId/${EndPointsConstants.tasksWithSubmissionsAndComments}',
    ).then((value) async {
      print(value?.data);
      getTaskWithSubmissionsAndCommentsModel =
          GetTaskWithSubmissionsAndCommentsModel.fromMap(value?.data);

      emit(TaskDetailsSuccessState());
    }).catchError((error) {
      emit(TaskDetailsErrorState(error: error.toString()));
      print(error.toString());
    });
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    commentService.socket.off('new-comment');
    return super.close();
  }
}
