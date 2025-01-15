import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/models/basic_models/submission_evaluation_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/modules/submission_evaluations_modules/cubit/submission_evaluations_cubit.dart';
import 'package:jelanco_tracking_system/modules/submission_evaluations_modules/cubit/submission_evaluations_states.dart';
import 'package:jelanco_tracking_system/widgets/components/my_star_rating.dart';
import 'package:jelanco_tracking_system/widgets/my_alert_dialog/my_alert_dialog.dart';
import 'package:jelanco_tracking_system/widgets/my_bars/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_floating_action_button.dart';
import 'package:jelanco_tracking_system/widgets/text_form_field/my_text_form_field.dart';

class SubmissionEvaluationsScreen extends StatelessWidget {
  final int? taskId;
  final int submissionId;
  final List<SubmissionEvaluationModel>? submissionEvaluations;

  SubmissionEvaluationsScreen({super.key, this.taskId, required this.submissionId, required this.submissionEvaluations});

  late SubmissionEvaluationsCubit submissionEvaluationsCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubmissionEvaluationsCubit(),
      child: BlocConsumer<SubmissionEvaluationsCubit, SubmissionEvaluationsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          submissionEvaluationsCubit = SubmissionEvaluationsCubit.get(context);
          return Scaffold(
            appBar: MyAppBar(
              title: 'تقييمات التسليم',
            ),
            body: submissionEvaluations == null || submissionEvaluations!.isEmpty
                ? const Center(
                    child: Text(
                      'لا يوجد تقييمات حتى الان',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: submissionEvaluations?.length,
                    itemBuilder: (context, index) {
                      final evaluation = submissionEvaluations?[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(evaluation?.evaluatorUser?.name ?? '',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  StarRating(rating: evaluation?.seRating ?? 0),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    '(${evaluation?.seRating.toString() ?? ''})',
                                    style: const TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                evaluation?.seEvaluatorNotes ?? '',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            floatingActionButton: MyFloatingActionButton(
              onPressed: () {
                _showAddEvaluationDialog(context);
              },
              labelText: 'إضافة تقييم جديد',
              icon: Icons.add,
            ),
          );
        },
      ),
    );
  }

  void _showAddEvaluationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: submissionEvaluationsCubit,
          child: BlocConsumer<SubmissionEvaluationsCubit, SubmissionEvaluationsStates>(
            listener: (context, state) {
              if (state is AddSubmissionEvaluationSuccessState) {
                if (state.addSubmissionEvaluationModel.status == true) {
                  submissionEvaluations?.add(
                    SubmissionEvaluationModel(
                        seId: state.addSubmissionEvaluationModel.evaluation?.seId,
                        seRating: state.addSubmissionEvaluationModel.evaluation?.seRating,
                        seEvaluatorNotes: state.addSubmissionEvaluationModel.evaluation?.seEvaluatorNotes,
                        evaluatorUser:
                            UserModel(id: UserDataConstants.userId, name: UserDataConstants.name, image: UserDataConstants.image),
                        createdAt: state.addSubmissionEvaluationModel.evaluation?.createdAt),
                  );
                }
              }
            },
            builder: (context, state) {
              return MyAlertDialog(
                title: 'إضافة تقييم',
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('قم بإضافة تقييم جديد يتضمن التقييم والملحوظات.'),
                      const SizedBox(
                        height: 24,
                      ),
                      const Text('التقييم من 5'),
                      const SizedBox(height: 4),
                      StarRating(
                        rating: submissionEvaluationsCubit.newStarsRating,
                        starSize: 36,
                        onRatingChanged: submissionEvaluationsCubit.onRatingChange,
                      ),
                      const SizedBox(height: 12),
                      MyTextFormField(
                        controller: submissionEvaluationsCubit.notesController,
                        labelText: 'ملاحظات إضافية',
                        titleText: 'أضف ملاحظاتك هنا (إختياري)',
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                confirmText: 'إضافة',
                onConfirm: () {
                  if (submissionEvaluationsCubit.newStarsRating > 0) {
                    submissionEvaluationsCubit.addSubmissionEvaluation(
                        taskId: taskId,
                        submissionId: submissionId,
                        rating: submissionEvaluationsCubit.newStarsRating,
                        notes: submissionEvaluationsCubit.notesController.text);
                    Navigator.pop(context);
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
