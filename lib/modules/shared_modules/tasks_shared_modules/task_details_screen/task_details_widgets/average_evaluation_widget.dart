import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/utils/navigation_services.dart';
import 'package:jelanco_tracking_system/models/basic_models/submission_evaluation_model.dart';
import 'package:jelanco_tracking_system/modules/submission_evaluations_modules/submission_evaluations_screen.dart';
import 'package:jelanco_tracking_system/widgets/components/my_star_rating.dart';

// todo make it stateful?
class AverageEvaluationWidget extends StatelessWidget {
  final int? taskId;
  final int submissionId;
  final List<SubmissionEvaluationModel>? submissionEvaluations;

  const AverageEvaluationWidget({super.key, this.taskId, required this.submissionId ,required this.submissionEvaluations});

  //  // average rating
  // double averageRating = 0;
  // int totalRaters = 0;

  // Function to calculate average rating
  double _calculateAverageRating(List<SubmissionEvaluationModel>? evaluations) {
    if (evaluations == null || evaluations.isEmpty) {
      return 0.0;
    }
    final totalRating = evaluations.fold(
      0.0,
      (sum, evaluation) => sum + (evaluation.seRating ?? 0.0),
    );
    return totalRating / evaluations.length;
  }

  // Function to calculate total raters
  int _calculateTotalRaters(List<SubmissionEvaluationModel>? evaluations) {
    return evaluations?.length ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    // Calculate average rating and total raters
    final averageRating = _calculateAverageRating(submissionEvaluations);
    final totalRaters = _calculateTotalRaters(submissionEvaluations);

    print('builllllllllllllllllllld in average evaluation widget');

    return GestureDetector(
      onTap: () {
        NavigationServices.navigateTo(
          context,
          SubmissionEvaluationsScreen(
            taskId: taskId,
            submissionId: submissionId,
            submissionEvaluations: submissionEvaluations,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Rating Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const Text(
                //   'Average Rating',
                //   style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // const SizedBox(height: 4),
                Row(
                  children: [
                    StarRating(rating: averageRating),
                    const SizedBox(width: 8),
                    Text(
                      '($totalRaters تقييم)',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Navigation Icon
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
