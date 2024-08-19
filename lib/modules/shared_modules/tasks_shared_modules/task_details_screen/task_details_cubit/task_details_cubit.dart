import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/files_extensions_utils.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/compress_media_mixins/compress_images_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/compress_media_mixins/compress_video_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/launch_url_mixin/launch_url_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/permission_mixin/permission_mixin.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_attachment_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_comment_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/comments_models/add_task_submission_comment_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/get_task_with_submissions_and_comments_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/tasks_shared_modules/task_details_screen/task_details_cubit/task_details_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';
import 'package:mime/mime.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class TaskDetailsCubit extends Cubit<TaskDetailsStates>
    with
        PermissionsMixin,
        CompressVideoMixin<TaskDetailsStates>,
        CompressImagesMixin<TaskDetailsStates> {
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

      emit(TaskDetailsSuccessState());
    }).catchError((error) {
      emit(TaskDetailsErrorState(error: error.toString()));
      print(error.toString());
    });
  }

  final FocusNode focusNode = FocusNode();
  TextEditingController commentController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  void changeCommentText({required String text}) {
    commentController.text = text;
    emit(ChangeCommentTextState());
  }

// images

  List<XFile> pickedImagesList = [];
  List<XFile?> compressedImagesList = [];

  Future<void> pickMultipleImagesFromGallery() async {
    final List<XFile> pickedImages = await picker.pickMultiImage();
    if (pickedImages.isNotEmpty) {
      pickedImagesList.addAll(pickedImages);
    }
    print("Image List Length:" + pickedImagesList.length.toString());
    emit(PickMultipleImagesState());
  }

  void deletedPickedImageFromList({required int index}) {
    pickedImagesList.removeAt(index);

    emit(DeletePickedImageFromListState());
  }

  Future<void> compressAllImages() async {
    // emit(CompressAllImagesLoadingState());
    compressedImagesList.clear();
    print('pickedImagesList.length: ${pickedImagesList.length}');
    for (int i = 0; i < pickedImagesList.length; i++) {
      print('thePickedImagesList[i].path: ${pickedImagesList[i].path}');
      XFile? compressed = await compressImage(
        File(pickedImagesList[i].path),
      );
      compressedImagesList.add(compressed);
      print('next loop');
    }
    // emit(CompressAllImagesSuccessState());
  }

// videos

  List<XFile> pickedVideosList = [];
  List<MediaInfo?> compressedVideoList = [];
  List<VideoPlayerController?> videoControllers = [];

  Future<void> pickMultipleVideosFromGallery() async {
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      pickedVideosList.add(video);

      print('Picked video path: ${video.path}');
      await initializeVideoControllerForAddComment(File(video.path));
      emit(PickMultipleVideosState());
      print('videoControllers: ${videoControllers.length}');
    }

    for (var video in pickedVideosList) {
      print('Final picked video: ${video.path}');
    }
  }

  Future<void> initializeVideoControllerForAddComment(File file) async {
    if (file.path.endsWith('.mp4')) {
      VideoPlayerController controller = VideoPlayerController.file(file);

      try {
        await controller.initialize();
        videoControllers.add(controller);
        print('videoControllers:: ${videoControllers.length}');
        emit(InitializeVideoControllerState());
      } catch (e) {
        print('Error initializing video controller: $e');
        videoControllers.add(null);
      }
    } else {
// message = 'File is not a video';
      videoControllers.add(null);
    }
  }

  void deletedPickedVideoFromList({
    required int index,
    TaskSubmissionModel? taskSubmissionModel, // for edit
  }) {
// the picked
    pickedVideosList.removeAt(index);
    videoControllers[index]?.dispose();
    videoControllers.removeAt(index);

    emit(DeletePickedVideoFromListState());
  }

  Future<void> compressVideos() async {
    compressedVideoList.clear();

    print('pickedVideosList.length: ${pickedVideosList.length}');
    for (int i = 0; i < pickedVideosList.length; i++) {
      print('pickedVideosList[i].path: ${pickedVideosList[i].path}');
      var compressed = await compressVideo(
        pickedVideosList[i].path,
        loadingState: CompressVideoLoadingState(),
        successState: CompressVideoSuccessState(),
        errorState: (error) => CompressVideoErrorState(error: error),
      );
      compressedVideoList.add(compressed);
    }

    // emit(CompressAllVideosSuccessState());
  }

// files

  FilePickerResult? result;
  List<File> pickedFilesList = [];

  Future<void> pickReportFile() async {
    result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      for (PlatformFile file in result!.files) {
        File selectedFile = File(file.path!);
        String? mimeType = lookupMimeType(file.path!);
        String extension = file.extension ?? '';

        if (mimeType != null &&
            FilesExtensionsUtils.isAcceptedFileType(extension)) {
          pickedFilesList.add(selectedFile);
          emit(AddTaskSubmissionFileSelectSuccessState());
        } else {
          emit(AddTaskSubmissionFileSelectErrorState(
              error:
                  'يجب ان يكون الملف من نوع pdf, doc, docx, xls, xlsx, ppt, pptx'));
        }
      }
    }
  }

  void deletedPickedFileFromList({
    required int index,
  }) {
// the picked
    pickedFilesList.removeAt(index);

    emit(DeletePickedFilesFromListState());
  }

  AddTaskSubmissionCommentModel? addTaskSubmissionCommentModel;

  Future<void> addComment({
    required int taskId,
    required int taskSubmissionId,
    required int parentId,
    required String commentContent,
  }) async {
    emit(AddCommentLoadingState());

    // compress images videos before send them to back-end
    await compressAllImages();
    await compressVideos();

    Map<String, dynamic> data = {
      'task_id': taskId,
      'task_submission_id': taskSubmissionId,
      'parent_id': parentId,
      'comment_content': commentContent,
    };

    FormData formData = FormData.fromMap(data);

    // compressedImagesList instead of pickedImagesList
    for (int i = 0; i < compressedImagesList.length; i++) {
      formData.files.addAll([
        MapEntry(
          "images[]",
          await MultipartFile.fromFile(compressedImagesList[i]!.path),
        ),
      ]);
    }

    // compressedVideoList instead of pickedVideosList
    for (int i = 0; i < compressedVideoList.length; i++) {
      formData.files.addAll([
        MapEntry(
          "videos[]",
          await MultipartFile.fromFile(compressedVideoList[i]!.path!),
        ),
      ]);
    }

    for (int i = 0; i < pickedFilesList.length; i++) {
      formData.files.addAll([
        MapEntry(
          "documents[]",
          await MultipartFile.fromFile(pickedFilesList[i].path),
        ),
      ]);
    }

    print('formData: ${formData.fields}');

    DioHelper.postData(
      url: EndPointsConstants.taskSubmissionComments,
      data: formData,
    ).then((value) {
      clearCommentData();
      print(value?.data);
      addTaskSubmissionCommentModel =
          AddTaskSubmissionCommentModel.fromMap(value?.data);
      emit(AddCommentSuccessState(
          addTaskSubmissionCommentModel: addTaskSubmissionCommentModel!));
      // add to the model so it will be shown in the list immediately
      // make the object (add the name and image from backend)
      if (addTaskSubmissionCommentModel!.status == true) {
        TaskSubmissionCommentModel newComment =
            addTaskSubmissionCommentModel!.comment!;

        getTaskWithSubmissionsAndCommentsModel!.task!.taskSubmissions!
            .where((submission) => submission.tsId == taskSubmissionId)
            .first
            .submissionComments
            ?.add(newComment);
      }
      // ..........................................
      // emit
    }).catchError((error) {
      emit(AddCommentErrorState(error: error.toString()));
      print(error.toString());
    });
  }

  void whenCloseBottomSheet() {
    focusNode.unfocus();
    //     emit(ClearCommentControllerState());
  }

  void clearCommentData() {
    commentController.clear();
    pickedFilesList.clear();
    pickedImagesList.clear();
    pickedVideosList.clear();
    videoControllers.clear();
  }

  @override
  Future<void> close() {
    focusNode.dispose();
    return super.close();
  }
}
