import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/files_extensions_utils.dart';
import 'package:jelanco_tracking_system/core/utils/formats_utils.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/categories_mixin/categories_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/compress_media_mixins/compress_images_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/compress_media_mixins/compress_video_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/manager_employees_mixin/manager_employees_with_task_assignees_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/permission_mixin/permission_mixin.dart';
import 'package:jelanco_tracking_system/enums/task_status_enum.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_category_model.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/edit_task_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/get_task_by_id_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/task_submissions_models/attachment_categories_model.dart';
import 'package:jelanco_tracking_system/modules/edit_task_modules/edit_task_cubit/edit_task_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';
import 'package:mime/mime.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class EditTaskCubit extends Cubit<EditTaskStates>
    with
        CategoriesMixin<EditTaskStates>,
        PermissionsMixin,
        ManagerEmployeesWithTaskAssigneesMixin<EditTaskStates>,
        CompressImagesMixin<EditTaskStates>,
        CompressVideoMixin<EditTaskStates> {
  EditTaskCubit() : super(EditTaskInitialState());

  static EditTaskCubit get(context) => BlocProvider.of(context);

  // EditTaskErrorState
  // EditTaskSuccessState

  GlobalKey<FormState> editTaskFormKey = GlobalKey<FormState>();
  TextEditingController contentController = TextEditingController();

  DateTime? plannedStartTime;
  DateTime? plannedEndTime;
  TaskCategoryModel? selectedCategory;
  List<UserModel> selectedUsers = [];
  TaskStatusEnum? selectedTaskStatusEnum;

  GetTaskByIdModel? getOldTaskDataByIdModel;

  // get old task data
  Future<void> getOldTaskData({
    required int taskId,
    // required TaskModel taskModel,
  }) async {
    emit(GetOldTaskDataLoadingState());

    await DioHelper.getData(
      url: '${EndPointsConstants.tasks}/$taskId',
    ).then((value) async {
      print(value?.data);
      getOldTaskDataByIdModel = GetTaskByIdModel.fromMap(value?.data);
      print('getOldTaskDataByIdModel: ${getOldTaskDataByIdModel?.toMap()}');

      if (getOldTaskDataByIdModel?.status == true) {
        contentController.text = getOldTaskDataByIdModel!.task!.tContent ?? '';
        plannedStartTime = getOldTaskDataByIdModel!.task!.tPlanedStartTime;
        plannedEndTime = getOldTaskDataByIdModel!.task!.tPlanedEndTime;
        selectedTaskStatusEnum = TaskStatusEnum.getStatus(getOldTaskDataByIdModel!.task!.tStatus!);

        for (var vid in getOldTaskDataByIdModel!.task!.taskAttachmentsCategories?.videos ?? []) {
          await initializeOldVideoController(vid.aAttachment!);
        }
      }

      emit(GetOldTaskDataSuccessState());
    }).catchError((error) {
      emit(GetOldTaskDataErrorState(error: error.toString()));
      print(error.toString());
    });
  }

  Future<void> selectDateTime(BuildContext context, bool isStartTime, DateTime? createdAt) async {
    DateTime initialDate = isStartTime // when reopen
        ? (plannedStartTime ?? DateTime.now())
        : (plannedEndTime ?? DateTime.now());

    // DateTime? temp;
    // if(plannedStartTime != null && plannedEndTime != null ) {
    //   temp = plannedStartTime!.isBefore(plannedEndTime!)
    //       ? plannedStartTime
    //       : plannedEndTime;
    // }

    // Ensure initialDate is not earlier than the firstDate (createdAt or current date)
    DateTime firstDate = createdAt ?? DateTime.now();
    if (initialDate.isBefore(firstDate)) {
      firstDate = initialDate;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      // firstDate: DateTime(2000),
      // lastDate: DateTime(2101),
      firstDate: firstDate,
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

  // after pop from AssignedToScreen
  void emitAfterReturn() {
    emit(EmitAfterReturnState());
  }

  void changeSelectedCategory({required TaskCategoryModel? newSelectedCategory}) {
    selectedCategory = newSelectedCategory;
    emit(ChangeSelectedCategoryState());
  }

  void changeSelectedTaskStatus({required TaskStatusEnum taskStatusEnum}) {
    selectedTaskStatusEnum = taskStatusEnum;
    emit(ChangeSelectedTaskStatusState());
  }

  final ImagePicker picker = ImagePicker();

  // from camera

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

  void deletePickedImageFromList({required int index, AttachmentsCategories? attachmentsCategories}) {
    if (attachmentsCategories != null) {
      // in edit, for the old data
      attachmentsCategories.images?.removeAt(index);
    } else {
      // the picked
      pickedImagesList.removeAt(index);
    }
    emit(DeletePickedImageFromListState());
  }

  Future<void> compressAllImages() async {
    // emit(CompressAllImagesLoadingState());
    compressedImagesList.clear();
    for (int i = 0; i < pickedImagesList.length; i++) {
      print('thePickedImagesList[i].path: ${pickedImagesList[i].path}');
      XFile? compressed = await compressImage(
        File(pickedImagesList[i].path),
      );
      compressedImagesList.add(compressed);
    }
    // emit(CompressAllImagesSuccessState());
  }

  // videos

  List<XFile> pickedVideosList = [];
  List<MediaInfo?> compressedVideoList = [];
  List<VideoPlayerController?> videosControllers = [];

  Future<void> pickVideoFromGallery() async {
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      pickedVideosList.add(video);

      print('Picked video path: ${video.path}');
      await initializeVideoController(File(video.path));
      emit(PickVideoState());
      // print('videoControllers: ${videoControllers[0]?.value?.duration}');
      print('videoControllers: ${videosControllers.length}');
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
        videosControllers.add(controller);
        print('videoControllers:: ${videosControllers.length}');
        emit(InitializeVideoControllerState());
      } catch (e) {
        print('Error initializing video controller: $e');
        videosControllers.add(null);
      }
    } else {
      // message = 'File is not a video';
      videosControllers.add(null);
    }
  }

  void deletePickedVideoFromList({
    required int index,
    AttachmentsCategories? attachmentsCategories, // for edit
  }) {
    if (attachmentsCategories != null) {
      // in edit, for the old data
      attachmentsCategories.videos?.removeAt(index);
      oldVideoControllers[index]?.dispose();
      oldVideoControllers.removeAt(index);
    } else {
      // the picked
      pickedVideosList.removeAt(index);
      videosControllers[index]?.dispose();
      videosControllers.removeAt(index);
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
    } else if (videosControllers[index] != null) {
      print('new videos');
      videosControllers[index]!.value.isPlaying
          ? videosControllers[index]!.pause()
          : videosControllers[index]!.play();
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

    // emit(CompressAllVideosSuccessState());
  }

  List<VideoPlayerController?> oldVideoControllers = [];

  Future<void> initializeOldVideoController(String videoPath) async {
    print('videoPath:: $videoPath');
    if (videoPath.endsWith('.mp4')) {
      print('videoPath:: $videoPath');

      VideoPlayerController controller =
          VideoPlayerController.networkUrl(Uri.parse(EndPointsConstants.tasksStorage + videoPath));
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

        if (mimeType != null && FilesExtensionsUtils.isAcceptedFileType(extension)) {
          pickedFilesList.add(selectedFile);
          emit(AddTaskFileSelectSuccessState());
        } else {
          emit(AddTaskFileSelectErrorState(
              error: 'يجب ان يكون الملف من نوع pdf, doc, docx, xls, xlsx, ppt, pptx'));
          // Show an error message if the file type is not accepted
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Only specific file types are accepted: pdf, doc, docx, xls, xlsx, ppt, pptx.')),
          // );
        }
      }
    }
  }

  void deletedPickedFileFromList({required int index, AttachmentsCategories? attachmentsCategories}) {
    if (attachmentsCategories != null) {
      // in edit, for the old data
      attachmentsCategories.files?.removeAt(index);
    } else {
      // the picked
      pickedFilesList.removeAt(index);
    }
    emit(DeletePickedFilesFromListState());
  }

  // edit

  EditTaskModel? editTaskModel;
  bool isAddTaskSubmissionLoading = false; // aseel change name

  void editTask({
    required int taskId,
    List<String> oldAttachments = const [],
  }) async {
    isAddTaskSubmissionLoading = true;
    emit(EditTaskLoadingState());

    // compress images videos before send them to back-end
    if (pickedImagesList.isNotEmpty) {
      await compressAllImages();
    }
    if (pickedVideosList.isNotEmpty) {
      await compressVideos();
    }

    Map<String, dynamic> dataObject = {
      'content': contentController.text,
      'start_time': plannedStartTime?.toString(),
      'end_time': plannedEndTime?.toString(),
      'category_id': selectedCategory?.cId,
      'assigned_to': FormatUtils.formatList<UserModel>(selectedUsers, (user) => user?.id.toString()),
      'status': selectedTaskStatusEnum!.statusName,
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

    await DioHelper.postData(url: '${EndPointsConstants.tasks}/$taskId', data: formData).then((value) {
      print(value?.data);
      editTaskModel = EditTaskModel.fromMap(value?.data);
      emit(EditTaskSuccessState(editTaskModel: editTaskModel!));
    }).catchError((error) {
      emit(EditTaskErrorState(error: error.toString()));
      print(error.toString());
    });

    isAddTaskSubmissionLoading = false;
    emitLoading();
  }

  void emitLoading() {
    emit(EmitLoadingState());
  }

  @override
  Future<void> close() {
    for (var controller in videosControllers) {
      controller?.dispose();
    }
    for (var controller in oldVideoControllers) {
      controller?.dispose();
    }
    contentController.dispose();
    return super.close();
  }
}
