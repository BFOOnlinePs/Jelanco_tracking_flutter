import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/evaluations_models/add_submission_evaluation_model.dart';
import 'package:jelanco_tracking_system/modules/submission_evaluations_modules/cubit/submission_evaluations_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class SubmissionEvaluationsCubit extends Cubit<SubmissionEvaluationsStates> {
  SubmissionEvaluationsCubit() : super(SubmissionEvaluationsInitialState());

  static SubmissionEvaluationsCubit get(context) => BlocProvider.of(context);

  final TextEditingController notesController = TextEditingController();

  double newStarsRating = 0;

  void onRatingChange(newRating) {
    newStarsRating = newRating;
    emit(OnRatingChangeState());
  }

  AddSubmissionEvaluationModel? addSubmissionEvaluationModel;

  void addSubmissionEvaluation({int? taskId, required int submissionId, required double rating, String? notes}) {
    emit(AddSubmissionEvaluationLoadingState());

    DioHelper.postData(url: EndPointsConstants.evaluateSubmission, data: {
      'task_id': taskId,
      'task_submission_id': submissionId,
      'rating': rating,
      'evaluator_notes': notes,
    }).then((value) {
      print(value?.data);
      addSubmissionEvaluationModel = AddSubmissionEvaluationModel.fromMap(value?.data);
      /// todo: add to the list
      emit(AddSubmissionEvaluationSuccessState(addSubmissionEvaluationModel!));
    }).catchError((error) {
      print(error.toString());
      emit(AddSubmissionEvaluationErrorState());
    });
  }
}
