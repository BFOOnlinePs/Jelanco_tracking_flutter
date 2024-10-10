import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/compress_media_mixins/compress_images_mixin.dart';
import 'package:jelanco_tracking_system/event_buses/submissions_event_bus.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:jelanco_tracking_system/models/tasks_models/comments_models/get_submission_comment_count_model.dart';
import 'package:jelanco_tracking_system/models/users_models/get_user_profile_by_id_model.dart';
import 'package:jelanco_tracking_system/models/users_models/update_profile_image_model.dart';
import 'package:jelanco_tracking_system/modules/user_profile_modules/cubit/user_profile_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

import '../../../core/utils/mixins/permission_mixin/permission_mixin.dart';

class UserProfileCubit extends Cubit<UserProfileStates> with PermissionsMixin, CompressImagesMixin {
  UserProfileCubit() : super(UserProfileInitialState()) {
    // Listen for TaskUpdatedEvent from EventBus
    eventBus.on<TaskUpdatedEvent>().listen((event) {
      // event.submission.tsParentId id is the old submission id
      int index = userProfileSubmissionsList
          .indexWhere((submission) => submission.tsId == event.submission.tsParentId);

      if (index != -1) {
        // Replace the old submission with the new one
        userProfileSubmissionsList[index] = event.submission;
      }
      emit(TasksUpdatedStateViaEventBus());
    });
  }

  static UserProfileCubit get(context) => BlocProvider.of(context);

  ScrollController scrollController = ScrollController();

  GetUserProfileByIdModel? getUserProfileByIdModel;
  List<TaskSubmissionModel> userProfileSubmissionsList = [];

  bool isProfileSubmissionsLoading = false;
  bool isProfileSubmissionsLastPage = false;

  Future<void> getUserProfileById({int page = 1, required int userId}) async {
    emit(GetUserProfileLoadingState());
    isProfileSubmissionsLoading = true;

    await DioHelper.getData(
      url: '${EndPointsConstants.userProfile}/$userId',
      query: {'page': page},
    ).then((value) {
      print(value?.data);
      // when refresh
      if (page == 1) {
        userProfileSubmissionsList.clear();
      }
      getUserProfileByIdModel = GetUserProfileByIdModel.fromMap(value?.data);

      userProfileSubmissionsList
          .addAll(getUserProfileByIdModel?.userSubmissions?.submissions as Iterable<TaskSubmissionModel>);

      isProfileSubmissionsLastPage = getUserProfileByIdModel?.userSubmissions?.pagination?.lastPage ==
          getUserProfileByIdModel?.userSubmissions?.pagination?.currentPage;

      isProfileSubmissionsLoading = false;

      emit(GetUserProfileSuccessState());
    }).catchError((error) {
      emit(GetUserProfileErrorState());
      print(error.toString());
    });
  }

  final ImagePicker picker = ImagePicker();

  XFile? pickedImage;
  XFile? compressedImage;

  Future<void> pickImageFromGallery() async {
    pickedImage = await picker.pickImage(source: ImageSource.gallery);
    print("Image ${pickedImage?.name}");
    // emit(PickImageFromGalleryState());

    // call the update
    if (pickedImage != null) {
      updateProfileImage(profileImage: pickedImage!.path);
    }
  }

  UpdateProfileImageModel? updateProfileImageModel;

  void updateProfileImage({required String profileImage}) async {
    emit(UpdateProfileImageLoadingState());

    compressedImage = await compressImage(File(pickedImage!.path));

    print('compressed image: ${compressedImage?.path}');
    Map<String, dynamic> data = {};

    FormData formData = FormData.fromMap(data);
    formData.files.addAll([
      MapEntry(
        "profile_image",
        await MultipartFile.fromFile(compressedImage!.path),
      )
    ]);

    DioHelper.postData(url: EndPointsConstants.updateProfile, data: formData).then((value) {
      print(value?.data);

      updateProfileImageModel = UpdateProfileImageModel.fromMap(value?.data);

      // update the image in the screen immediately, and in the user data constants
      if (updateProfileImageModel?.status == true) {
        getUserProfileByIdModel!.userInfo!.image = updateProfileImageModel?.imageUrl;
        UserDataConstants.image = updateProfileImageModel?.imageUrl;
      }

      emit(UpdateProfileImageSuccessState(updateProfileImageModel: updateProfileImageModel!));
    }).catchError((error) {
      print(error.toString());
      emit(UpdateProfileImageErrorState());
    });
  }

  // void afterEditSubmission({
  //   required int oldSubmissionId,
  //   required final TaskSubmissionModel newSubmissionModel,
  // }) {
  //   // Replace the old submission with the new one
  //   // Find the index of the submission with the old ID
  //   int index = userProfileSubmissionsList
  //       .indexWhere((submission) => submission.tsId == oldSubmissionId);
  //
  //   if (index != -1) {
  //     // Replace the old submission with the new one
  //     userProfileSubmissionsList[index] = newSubmissionModel;
  //
  //     print(userProfileSubmissionsList[index].toMap());
  //     print(userProfileSubmissionsList[index].tsId);
  //   }
  //   emit(AfterEditSubmissionState());
  // }

  GetSubmissionCommentCountModel? getSubmissionCommentCountModel;

  // after pop from submission comments screen, update the number of comments
  void getCommentsCount({required int submissionId}) async {
    emit(GetCommentsCountLoadingState());
    await DioHelper.getData(
      url:
          '${EndPointsConstants.taskSubmissions}/$submissionId/${EndPointsConstants.taskSubmissionComments}/${EndPointsConstants.taskSubmissionCommentsCount}',
      // /task-submissions/185/comments/count
    ).then((value) {
      print(value?.data);
      getSubmissionCommentCountModel = GetSubmissionCommentCountModel.fromMap(value?.data);

      // update the number of comments in the original submission model

      userProfileSubmissionsList.firstWhere((submission) => submission.tsId == submissionId).commentsCount =
          getSubmissionCommentCountModel?.commentsCount;

      emit(GetCommentsCountSuccessState());
    }).catchError((error) {
      emit(GetCommentsCountErrorState());
      print(error.toString());
    });
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}
