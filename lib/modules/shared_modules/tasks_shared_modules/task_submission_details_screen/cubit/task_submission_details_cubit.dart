import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_comment_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/get_task_submission_with_task_and_comments_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_submission_details_screen/cubit/task_submission_details_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';
import 'package:jelanco_tracking_system/network/remote/socket_io.dart';

class TaskSubmissionDetailsCubit extends Cubit<TaskSubmissionDetailsStates> {
  TaskSubmissionDetailsCubit() : super(TaskSubmissionDetailsInitialState());

  static TaskSubmissionDetailsCubit get(context) => BlocProvider.of(context);

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
      getTaskSubmissionWithTaskAndCommentsModel
          ?.taskSubmission?.submissionComments
          ?.add(newComment);
      emit(ListenToNewCommentsState());
    });
  }

  GetTaskSubmissionWithTaskAndCommentsModel?
      getTaskSubmissionWithTaskAndCommentsModel;

  void getTaskSubmissionWithTaskAndComments({required int submissionId}) {
    emit(GetTaskSubmissionWithTaskAndCommentsLoadingState());
    // /task-submissions/201/task-and-comments
    DioHelper.getData(
            url:
                '${EndPointsConstants.taskSubmissions}/$submissionId/${EndPointsConstants.taskSubmissionWithTaskAndComments}')
        .then((value) {
      print(value?.data);
      getTaskSubmissionWithTaskAndCommentsModel =
          GetTaskSubmissionWithTaskAndCommentsModel.fromMap(value?.data);
      emit(GetTaskSubmissionWithTaskAndCommentsSuccessState());
    }).catchError((error) {
      emit(GetTaskSubmissionWithTaskAndCommentsErrorState());
      print(error.toString());
    });
  }

  @override
  Future<void> close() {
    commentService.socket.off('new-comment');
    return super.close();
  }
}
