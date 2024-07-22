import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/permission_mixin/permission_mixin.dart';
import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/add_task_submission_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_submission_modules/add_task_submission_cubit/add_task_submission_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';
import 'package:video_player/video_player.dart';

class AddTaskSubmissionCubit extends Cubit<AddTaskSubmissionStates>
    with PermissionsMixin {
  AddTaskSubmissionCubit() : super(AddTaskSubmissionInitialState());

  static AddTaskSubmissionCubit get(context) => BlocProvider.of(context);

  GlobalKey<FormState> addTaskSubmissionFormKey = GlobalKey<FormState>();

  TextEditingController contentController = TextEditingController();
  List<VideoPlayerController?> videoControllers = [];

  final ImagePicker picker = ImagePicker();

  // images

  List<XFile> thePickedImagesList = [];

  Future<void> pickMultipleImagesFromGallery() async {
    final List<XFile> pickedImages = await picker.pickMultiImage();
    if (pickedImages.isNotEmpty) {
      thePickedImagesList.addAll(pickedImages);
    }
    print("Image List Length:" + thePickedImagesList.length.toString());
    emit(PickMultipleImagesState());
  }

  void deletedPickedImageFromList({required int index}) {
    thePickedImagesList.removeAt(index);
    emit(DeletePickedImageFromListState());
  }

  // videos

  List<XFile> pickedVideosList = [];

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
      // videoControllers.add(controller);
      // controller.initialize().then((_) {
      //   emit(InitializeVideoControllerState());
      // });
    } else {
      // message = 'File is not a video';
      videoControllers.add(null);
    }
  }

  void deletedPickedVideoFromList({required int index}) {
    pickedVideosList.removeAt(index);
    videoControllers[index]?.dispose();
    videoControllers.removeAt(index);
    emit(DeletePickedVideoFromListState());
  }

  void toggleVideoPlayPause(int index) {
    if (videoControllers[index] != null) {
      videoControllers[index]!.value.isPlaying
          ? videoControllers[index]!.pause()
          : videoControllers[index]!.play();
      emit(ToggleVideoPlayPauseState());
    }
  }

  // files

  FilePickerResult? result;
  List<File> pickedFilesList = [];

  Future<void> pickReportFile() async {
    result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      // pickedFiles = result!.paths.map((path) => File(path!)).toList();
      pickedFilesList.addAll(result!.paths.map((path) => File(path!)).toList());
      emit(AddTaskSubmissionFileSelectSuccessState());
    } else {
      emit(AddTaskSubmissionFileSelectErrorState());
      print('User canceled the file selection');
    }
  }

  void deletedPickedFileFromList({required int index}) {
    pickedFilesList.removeAt(index);
    emit(DeletePickedFilesFromListState());
  }

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

  // add

  Future<void> addNewTaskSubmission({required int taskId}) async {
    emit(AddTaskSubmissionLoadingState());

    Map<String, dynamic> dataObject = {
      'parent_id': -1, // first submission
      'task_id': taskId,
      'content': contentController.text,
    };

    FormData formData = FormData.fromMap(dataObject);

    for (int i = 0; i < thePickedImagesList.length; i++) {
      formData.files.addAll([
        MapEntry(
          "images[]",
          await MultipartFile.fromFile(thePickedImagesList[i].path),
        ),
      ]);
    }

    for (int i = 0; i < pickedVideosList.length; i++) {
      formData.files.addAll([
        MapEntry(
          "videos[]",
          await MultipartFile.fromFile(pickedVideosList[i].path),
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

    AddTaskSubmissionModel? addTaskSubmissionModel;

    print('formData: ${formData.fields}');

    DioHelper.postData(
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
  }

  @override
  Future<void> close() {
    for (var controller in videoControllers) {
      controller?.dispose();
    }
    return super.close();
  }
}
