import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/comment_service.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_comment_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/comments_models/get_submission_comments_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/submission_comments_modules/cubit/submission_comments_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class SubmissionCommentsCubit extends Cubit<SubmissionCommentsStates> {
  SubmissionCommentsCubit({required this.commentService}) : super(SubmissionCommentsInitialState());

  static SubmissionCommentsCubit get(context) => BlocProvider.of(context);


  final CommentService? commentService;

  void listenToNewComments() {
    print('listenToNewComments');
    commentService?.socket.on('new-comment', (data) {
      print('from screen Socket.IO New comment received:: $data');
      // Update the state with the new comment
      TaskSubmissionCommentModel newComment = TaskSubmissionCommentModel.fromMap(data);
      print(newComment.tscId);
      getSubmissionCommentsModel?.submissionComments?.add(newComment);
      emit(ListenToNewCommentsState());
    });

    // SubmissionCommentsCubit.get(context).addNewComment(newComment);
    // commentService?.socket.on('new-comment', (data) {
    //   print('Socket.IO in listenToNewComments New comment received: $data');
    //   // Handle the incoming comment by updating the UI
    //   // Convert the data to a TaskSubmissionCommentModel object
    //   TaskSubmissionCommentModel newComment = TaskSubmissionCommentModel.fromMap(data);
    //   // Add the new comment to the existing list in your cubit or state
    //   getSubmissionCommentsModel?.submissionComments?.add(newComment);
    //
    //   // if (data != null && data['comment'] != null) {
    //   //
    //   //   // TaskSubmissionCommentModel newComment = data['comment'];
    //   //   Map<String, dynamic> commentData = data['comment'];
    //   //   TaskSubmissionCommentModel newComment = TaskSubmissionCommentModel.fromMap(commentData);
    //   //
    //   //   getSubmissionCommentsModel?.submissionComments?.add(newComment); // Add new comment to the list
    //   //   emit(GetSubmissionCommentsSuccessState()); // Emit updated list
    //   // }
    // });
  }

  int count = 0;

  void toEmit(){
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
    return super.close();
  }
}
