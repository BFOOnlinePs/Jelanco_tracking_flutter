import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/evaluations_models/add_submission_evaluation_model.dart';

abstract class SubmissionEvaluationsStates {}

class SubmissionEvaluationsInitialState extends SubmissionEvaluationsStates {}

class AddSubmissionEvaluationLoadingState extends SubmissionEvaluationsStates {}

class AddSubmissionEvaluationSuccessState extends SubmissionEvaluationsStates {
  final AddSubmissionEvaluationModel addSubmissionEvaluationModel;

  AddSubmissionEvaluationSuccessState(this.addSubmissionEvaluationModel);
}

class AddSubmissionEvaluationErrorState extends SubmissionEvaluationsStates {}

class OnRatingChangeState extends SubmissionEvaluationsStates {}
