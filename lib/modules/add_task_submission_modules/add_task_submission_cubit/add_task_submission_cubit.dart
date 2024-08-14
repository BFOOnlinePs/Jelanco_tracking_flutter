import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/files_extensions_utils.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/compress_media_mixins/compress_images_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/compress_media_mixins/compress_video_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/permission_mixin/permission_mixin.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/add_task_submission_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_cubit/add_task_submission_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';
import 'package:mime/mime.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class AddTaskSubmissionCubit extends Cubit<AddTaskSubmissionStates>
    with
        PermissionsMixin,
        CompressVideoMixin<AddTaskSubmissionStates>,
        CompressImagesMixin<AddTaskSubmissionStates> {
  AddTaskSubmissionCubit() : super(AddTaskSubmissionInitialState());

  static AddTaskSubmissionCubit get(context) => BlocProvider.of(context);

  GlobalKey<FormState> addTaskSubmissionFormKey = GlobalKey<FormState>();

  TextEditingController contentController = TextEditingController();

  final ImagePicker picker = ImagePicker();

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

  void deletedPickedImageFromList(
      {required int index, TaskSubmissionModel? taskSubmissionModel}) {
    if (taskSubmissionModel != null) {
      // in edit, for the old data
      taskSubmissionModel.submissionAttachmentsCategories!.images
          ?.removeAt(index);
    } else {
      // the picked
      pickedImagesList.removeAt(index);
    }
    emit(DeletePickedImageFromListState());
  }

  Future<void> compressAllImages() async {
    emit(CompressAllImagesLoadingState());
    compressedImagesList.clear();
    for (int i = 0; i < pickedImagesList.length; i++) {
      print('thePickedImagesList[i].path: ${pickedImagesList[i].path}');
      XFile? compressed = await compressImage(
        File(pickedImagesList[i].path),
      );
      compressedImagesList.add(compressed);
    }
    emit(CompressAllImagesSuccessState());
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
      await initializeVideoController(File(video.path));
      emit(PickMultipleVideosState());
      // print('videoControllers: ${videoControllers[0]?.value?.duration}');
      print('videoControllers: ${videoControllers.length}');
    }

    for (var video in pickedVideosList) {
      print('Final picked video: ${video.path}');
    }
  }

  Future<void> initializeVideoController(File file) async {
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
    if (taskSubmissionModel != null) {
      // in edit, for the old data
      taskSubmissionModel.submissionAttachmentsCategories!.videos
          ?.removeAt(index);
      oldVideoControllers[index]?.dispose();
      oldVideoControllers.removeAt(index);
    } else {
      // the picked
      pickedVideosList.removeAt(index);
      videoControllers[index]?.dispose();
      videoControllers.removeAt(index);
    }

    emit(DeletePickedVideoFromListState());
  }

  void toggleVideoPlayPause(
    int index, {
    bool isOldVideos = false, // for edit
  }) {
    if (isOldVideos) {
      print('old videos');
      // in edit
      oldVideoControllers[index]!.value.isPlaying
          ? oldVideoControllers[index]!.pause()
          : oldVideoControllers[index]!.play();
      emit(ToggleVideoPlayPauseState());
    } else if (videoControllers[index] != null) {
      print('new videos');
      videoControllers[index]!.value.isPlaying
          ? videoControllers[index]!.pause()
          : videoControllers[index]!.play();
      emit(ToggleVideoPlayPauseState());
    }
  }

  Future<void> compressVideos() async {
    compressedVideoList.clear();

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

    emit(CompressAllVideosSuccessState());
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
          // Show an error message if the file type is not accepted
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Only specific file types are accepted: pdf, doc, docx, xls, xlsx, ppt, pptx.')),
          // );
        }
      }
    }

    // if (result != null) {
    //   // pickedFiles = result!.paths.map((path) => File(path!)).toList();
    //
    //   pickedFilesList.addAll(result!.paths.map((path) => File(path!)).toList());
    //   emit(AddTaskSubmissionFileSelectSuccessState());
    // } else {
    //   emit(AddTaskSubmissionFileSelectErrorState());
    //   print('User canceled the file selection');
    // }
  }

  void deletedPickedFileFromList(
      {required int index, TaskSubmissionModel? taskSubmissionModel}) {
    if (taskSubmissionModel != null) {
      // in edit, for the old data
      taskSubmissionModel.submissionAttachmentsCategories!.files
          ?.removeAt(index);
    } else {
      // the picked
      pickedFilesList.removeAt(index);
    }
    emit(DeletePickedFilesFromListState());
  }

  // location

  Position? position;

  Future<void> getCurrentLocation() async {
    position = null;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print(
          "Latitude: ${position?.latitude}, Longitude: ${position?.longitude}");
    } catch (e) {
      print("Error: $e");
      emit(RequestLocationPermissionGetDeniedState());
    }
  }

  void emitLoading() {
    emit(EmitLoadingState());
  }

  // add

  AddTaskSubmissionModel? addTaskSubmissionModel;
  bool isAddTaskSubmissionLoading = false;

  Future<void> addNewTaskSubmission({
    required int taskId,
    required bool isEdit,
    int? taskSubmissionId,
    List<String> oldAttachments = const [],
  }) async {
    isAddTaskSubmissionLoading = true;
    emit(AddTaskSubmissionLoadingState());
    // compress images videos before send them to back-end
    await compressAllImages();
    await compressVideos();

    Map<String, dynamic> dataObject = {
      'parent_id': taskSubmissionId, // -1 first submission
      'task_id': taskId,
      'content': contentController.text,
      'start_latitude': position?.latitude,
      'start_longitude': position?.longitude,
      'old_attachments[]': oldAttachments
    };

    print('old_attachments: ${oldAttachments.length}');

    FormData formData = FormData.fromMap(dataObject);

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

    await DioHelper.postData(
      url: EndPointsConstants.taskSubmissions,
      data: formData,
    ).then((value) {
      print(value?.data);
      addTaskSubmissionModel = AddTaskSubmissionModel.fromMap(value?.data);
      emit(AddTaskSubmissionSuccessState(
          addTaskSubmissionModel: addTaskSubmissionModel!));
    }).catchError((error) {
      emit(AddTaskSubmissionErrorState(error: error.toString()));
      print(error.toString());
    });
    isAddTaskSubmissionLoading = false;
    emitLoading();
  }


  // for the edit
  void getOldData(
      {required bool isEdit, TaskSubmissionModel? taskSubmissionModel}) async {
    if (isEdit) {
      print('call the old data');
      contentController.text = taskSubmissionModel!.tsContent ?? '';
      // taskSubmissionModel.submissionAttachmentsCategories?.videos!
      //    .map((vid) async => await initializeOldVideoController(vid.aAttachment!));
      for (var vid
      in taskSubmissionModel.submissionAttachmentsCategories?.videos ??
          []) {
        await initializeOldVideoController(vid.aAttachment!);
      }
    } else {
      print('don\'t call the old data');
    }
  }

  List<VideoPlayerController?> oldVideoControllers = [];

  Future<void> initializeOldVideoController(String videoPath) async {
    print('videoPath:: $videoPath');
    if (videoPath.endsWith('.mp4')) {
      print('videoPath:: $videoPath');

      VideoPlayerController controller = VideoPlayerController.networkUrl(
          Uri.parse(EndPointsConstants.taskSubmissionsStorage + videoPath));
      try {
        await controller.initialize();
        oldVideoControllers.add(controller);
        print('oldVideoControllers:: ${oldVideoControllers.length}');
        emit(InitializeVideoControllerState());
      } catch (e) {
        print('Error initializing video controller: $e');
        oldVideoControllers.add(null);
      }
    } else {
      // message = 'File is not a video';
      oldVideoControllers.add(null);
    }
  }

  // end edit

  @override
  Future<void> close() {
    for (var controller in videoControllers) {
      controller?.dispose();
    }
    contentController.dispose();
    return super.close();
  }
}
