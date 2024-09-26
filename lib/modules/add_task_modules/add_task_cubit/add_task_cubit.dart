import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/files_extensions_utils.dart';
import 'package:jelanco_tracking_system/core/utils/formats_utils.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/categories_mixin/categories_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/compress_media_mixins/compress_images_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/compress_media_mixins/compress_video_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/manager_employees_mixin/manager_employees_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/permission_mixin/permission_mixin.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_category_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/add_task_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/attachment_categories_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_cubit/add_task_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';
import 'package:mime/mime.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class AddTaskCubit extends Cubit<AddTaskStates>
    with
        CategoriesMixin<AddTaskStates>,
        PermissionsMixin,
        ManagerEmployeesMixin<AddTaskStates>,
        CompressVideoMixin<AddTaskStates>,
        CompressImagesMixin<AddTaskStates> {
  AddTaskCubit() : super(AddTaskInitialState());

  static AddTaskCubit get(context) => BlocProvider.of(context);

  // error
  // success
  // loading

  final formKey = GlobalKey<FormState>();
  TextEditingController contentController = TextEditingController();

  DateTime? plannedStartTime;
  DateTime? plannedEndTime;
  TaskCategoryModel? selectedCategory;
  List<UserModel> selectedUsers = [];

  Future<void> selectDateTime(BuildContext context, bool isStartTime) async {
    DateTime initialDate = isStartTime
        ? (plannedStartTime ?? DateTime.now()) // when reopen
        : (plannedEndTime ?? DateTime.now());

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      // firstDate: DateTime(2000),
      // lastDate: DateTime(2101),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        final selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        if (isStartTime) {
          plannedStartTime = selectedDateTime;
        } else {
          plannedEndTime = selectedDateTime;
        }
        emit(PlannedTimePickedState());
      }
    }
  }

  // initial user when add task to a specific user from profile screen
  void addInitialSelectedUser({required int userId}) {
    selectedUsers = getManagerEmployeesModel!.managerEmployees!
        .where((user) => user.id == userId)
        .toList();
  }

  // after pop from AssignedToScreen
  void emitAfterReturn() {
    emit(EmitAfterReturnState());
  }

  void changeSelectedCategory(
      {required TaskCategoryModel? newSelectedCategory}) {
    selectedCategory = newSelectedCategory;
    emit(ChangeSelectedCategoryState());
  }

  final ImagePicker picker = ImagePicker();

  // from camera
  // List<XFile> pickedFromCameraList = [];
  // List<XFile?> compressedFromCameraList = [];

  Future<void> pickMediaFromCamera({bool isImage = true}) async {
    if (isImage) {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        pickedImagesList.add(image);
      }
    } else {
      final XFile? video = await picker.pickVideo(source: ImageSource.camera);
      if (video != null) {
        pickedVideosList.add(video);
        await initializeVideoController(File(video.path));
      }
    }

    emit(PickMediaFromCameraState());
  }

  // images

  List<XFile> pickedImagesList = [];
  List<XFile?> compressedImagesList = [];

  Future<void> pickMultipleImagesFromGallery() async {
    final List<XFile> pickedImages = await picker.pickMultiImage();
    if (pickedImages.isNotEmpty) {
      pickedImagesList.addAll(pickedImages);
    }
    print("Image List Length:${pickedImagesList.length}");
    emit(PickMultipleImagesState());
  }

  void deletedPickedImageFromList(
      {required int index, AttachmentsCategories? attachmentsCategories}) {
    if (attachmentsCategories != null) {
      // in edit, for the old data
      attachmentsCategories!.images?.removeAt(index);
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

  Future<void> pickVideoFromGallery() async {
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      pickedVideosList.add(video);

      print('Picked video path: ${video.path}');
      await initializeVideoController(File(video.path));
      emit(PickVideoState());
      // print('videoControllers: ${videoControllers[0]?.value?.duration}');
      print('videoControllers: ${videoControllers.length}');
    }

    // for (var video in pickedVideosList) {
    //   print('Final picked video: ${video.path}');
    // }
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

  // void deletedPickedVideoFromList({
  //   required int index,
  //   TaskSubmissionModel? taskSubmissionModel, // for edit
  // }) {
  //   if (taskSubmissionModel != null) {
  //     // in edit, for the old data
  //     taskSubmissionModel.submissionAttachmentsCategories!.videos
  //         ?.removeAt(index);
  //     oldVideoControllers[index]?.dispose();
  //     oldVideoControllers.removeAt(index);
  //   } else {
  //     // the picked
  //     pickedVideosList.removeAt(index);
  //     videoControllers[index]?.dispose();
  //     videoControllers.removeAt(index);
  //   }
  //
  //   emit(DeletePickedVideoFromListState());
  // }

  // void toggleVideoPlayPause(
  //   int index, {
  //   bool isOldVideos = false, // for edit
  // }) {
  //   if (isOldVideos) {
  //     print('old videos');
  //     // in edit
  //     oldVideoControllers[index]!.value.isPlaying
  //         ? oldVideoControllers[index]!.pause()
  //         : oldVideoControllers[index]!.play();
  //     emit(ToggleVideoPlayPauseState());
  //   } else if (videoControllers[index] != null) {
  //     print('new videos');
  //     videoControllers[index]!.value.isPlaying
  //         ? videoControllers[index]!.pause()
  //         : videoControllers[index]!.play();
  //     emit(ToggleVideoPlayPauseState());
  //   }
  // }

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
          emit(AddTaskFileSelectSuccessState());
        } else {
          emit(AddTaskFileSelectErrorState(
              error:
                  'يجب ان يكون الملف من نوع pdf, doc, docx, xls, xlsx, ppt, pptx'));
          // Show an error message if the file type is not accepted
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Only specific file types are accepted: pdf, doc, docx, xls, xlsx, ppt, pptx.')),
          // );
        }
      }
    }
  }

  void deletedPickedFileFromList(
      {required int index, AttachmentsCategories? attachmentsCategories}) {
    if (attachmentsCategories != null) {
      // in edit, for the old data
      attachmentsCategories.files?.removeAt(index);
    } else {
      // the picked
      pickedFilesList.removeAt(index);
    }
    emit(DeletePickedFilesFromListState());
  }

  // add

  AddTaskModel? addTaskModel;
  bool isAddClicked = false; // for assignedTo error message

  void changeIsAddClicked(bool value) {
    isAddClicked = value;
    emit(ChangeIsAddClickedState());
  }

  bool isAddTaskSubmissionLoading = false;

  Future<void> addTask() async {
    isAddTaskSubmissionLoading = true;

    emit(AddTaskLoadingState());

    // compress images videos before send them to back-end
    await compressAllImages();
    await compressVideos();

    Map<String, dynamic> dataObject = {
      'content': contentController.text,
      'start_time': plannedStartTime?.toString(),
      'end_time': plannedEndTime?.toString(),
      'category_id': selectedCategory?.cId,
      'assigned_to': FormatUtils.formatList<UserModel>(
          selectedUsers, (user) => user?.id.toString()),
    };
    print(dataObject.values);
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

    await DioHelper.postData(url: EndPointsConstants.tasks, data: formData)
        .then((value) {
      print(value?.data);
      addTaskModel = AddTaskModel.fromMap(value?.data);
      emit(AddTaskSuccessState(addTaskModel: addTaskModel!));
    }).catchError((error) {
      emit(AddTaskErrorState(error: error.toString()));
    });
    isAddTaskSubmissionLoading = false;
    emitLoading();
  }

  void emitLoading() {
    emit(EmitLoadingState());
  }
}
