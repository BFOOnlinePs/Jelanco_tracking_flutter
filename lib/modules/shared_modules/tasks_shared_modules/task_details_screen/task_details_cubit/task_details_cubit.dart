import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_attachment_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/get_task_with_submissions_and_comments_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class TaskDetailsCubit extends Cubit<TaskDetailsStates> {
  TaskDetailsCubit() : super(TaskDetailsInitialState());

  static TaskDetailsCubit get(context) => BlocProvider.of(context);

  GetTaskWithSubmissionsAndCommentsModel?
      getTaskWithSubmissionsAndCommentsModel;

  void getTaskWithSubmissionsAndComments({required int taskId}) {
    emit(TaskDetailsLoadingState());
    DioHelper.getData(
      url:
          '${EndPointsConstants.tasks}/$taskId/${EndPointsConstants.tasksWithSubmissionsAndComments}',
    ).then((value) async {
      print(value?.data);
      getTaskWithSubmissionsAndCommentsModel =
          GetTaskWithSubmissionsAndCommentsModel.fromMap(value?.data);

      // getTaskWithSubmissionsAndCommentsModel!.task!
      //       .taskSubmissions!
      //       .map((submission) {
      //     return submission.submissionAttachmentsCategories!.videos!.map((video) async {
      //       await initializeVideoController(video);
      //     });
      //   });

      // initialize the controllers
      final task = getTaskWithSubmissionsAndCommentsModel!.task!;
      final submissions = task.taskSubmissions!;

      for (var submission in submissions) {
        final videos = submission.submissionAttachmentsCategories?.videos ?? [];
        for (var video in videos) {
          await initializeVideoController(video,
              onControllerLoaded: (controller) {
            print('inside ii');
            video.videoController = controller;
            print('after assign the controller');
            print(video.videoController?.value.duration);
            print(controller?.value.duration);
          });
        }
      }
      isInitializeVideoController = true;

      emit(TaskDetailsSuccessState());
    }).catchError((error) {
      emit(TaskDetailsErrorState(error: error.toString()));
      print(error.toString());
    });
  }

  bool isInitializeVideoController = false;

  Future<void> initializeVideoController(
    SubmissionAttachmentModel attachmentModel, {
    required Function(VideoPlayerController?) onControllerLoaded,
  }) async {
    var uri =
        '${EndPointsConstants.taskSubmissionsStorage}${attachmentModel.aAttachment!}';

    VideoPlayerController controller =
        VideoPlayerController.networkUrl(Uri.parse(uri));

    print('controller::: ${controller.value.duration}');

    print(uri);

    try {
      await controller.initialize();
      print(
          'attachmentModel.videoController?.value?.duration:: ${controller.value?.duration}');
      onControllerLoaded(controller); // Pass controller back to the caller
      emit(InitializeVideoControllerState());
    } catch (e) {
      print('Error initializing video controller: $e');
    }
    emit(InitializeVideoControllerState());
  }

  void toggleVideoPlayPause(VideoPlayerController videoPlayerController) {
    videoPlayerController.value.isPlaying
        ? videoPlayerController.pause() 
        : videoPlayerController.play();
    emit(ToggleVideoPlayPauseState());
  }

  void launchMyUrl({required storagePath, required String uriString}) async {
    final Uri uri = Uri.parse(storagePath + uriString);
    print('uri: ${uri}');
    if (!await launchUrl(uri)) {
      // emit(CantOpenCVFileState());
      print('can\'t open the cv');
    }
  }
}
