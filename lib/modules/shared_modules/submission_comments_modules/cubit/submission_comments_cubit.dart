import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/network/remote/socket_io.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_comment_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/comments_models/get_submission_comments_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/submission_comments_modules/cubit/submission_comments_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class SubmissionCommentsCubit extends Cubit<SubmissionCommentsStates> {
  SubmissionCommentsCubit() : super(SubmissionCommentsInitialState());

  static SubmissionCommentsCubit get(context) => BlocProvider.of(context);

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
      getSubmissionCommentsModel?.submissionComments?.add(newComment);
      emit(ListenToNewCommentsState());
    });
  }

  int count = 0;

  void toEmit() {
    count++;
    emit(OpenSheetState());
  }

  ScrollController scrollController = ScrollController();

  GetSubmissionCommentsModel? getSubmissionCommentsModel;

  // if pagination added, then when add new comment we should handle how it will be shown in different way
  // calling the api one more time will get the first page only, and the comments ordered
  Future<void> getSubmissionComments({required int submissionId}) async {
    emit(GetSubmissionCommentsLoadingState());
    await DioHelper.getData(
      url:
          '${EndPointsConstants.taskSubmissions}/$submissionId/${EndPointsConstants.taskSubmissionComments}', // /task-submissions/139/comments
    ).then((value) {
      print(value?.data);
      getSubmissionCommentsModel =
          GetSubmissionCommentsModel.fromMap(value?.data);
      emit(GetSubmissionCommentsSuccessState());
    }).catchError((error) {
      emit(GetSubmissionCommentsErrorState(error.toString()));
      print(error.toString());
    });
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    // Clean up the socket listener when the Cubit is closed
    commentService.socket.off('new-comment');
    return super.close();
  }
}
