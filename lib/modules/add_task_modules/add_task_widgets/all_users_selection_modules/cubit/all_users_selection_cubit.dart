import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/interested_parties_mixins/get_interested_parties_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/users_mixin/users_mixin.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_widgets/all_users_selection_modules/cubit/all_users_selection_states.dart';

class AllUsersSelectionCubit extends Cubit<AllUsersSelectionStates>
    with UsersMixin<AllUsersSelectionStates>, GetInterestedPartiesMixin<AllUsersSelectionStates> {
  AllUsersSelectionCubit() : super(AllUsersSelectionInitialState());

  static AllUsersSelectionCubit get(context) => BlocProvider.of(context);

  List<UserModel> selectedUsers = [];
  List<int>? usersCanNotEdit = []; // when callInterestedParties = true, the list of users where the current user can't edit
  TextEditingController searchController = TextEditingController();

  void initialValues({
    required List<int> initialSelectedUserIds,
    bool callInterestedParties = false, // when enter the screen from task/submission item (not from add or edit)
    String? articleType, // when enter the screen from task/submission item
    int? articleId, // when enter the screen from task/submission item
  }) async {
    print('initialSelectedUserIds: $initialSelectedUserIds');

    await Future.wait([
      getAllUsers(
        pagination: 1,
        loadingState: GetAllUsersLoadingState(),
        successState: GetAllUsersSuccessState(),
        errorState: (error) => GetAllUsersErrorState(),
      ),
      if (callInterestedParties)
        getInterestedParties(
          articleType: articleType!,
          articleId: articleId!,
          loadingState: GetInterestedPartiesLoadingState(),
          successState: GetInterestedPartiesSuccessState(),
          errorState: GetInterestedPartiesErrorState(),
        ),
    ]);
    selectedUsers = callInterestedParties
        ? getInterestedPartiesModel!.interestedParties!.map((e) => e.user!).toList()
        : usersList.where((user) => initialSelectedUserIds.any((selectedUserId) => selectedUserId == user.id)).toList();

    if (callInterestedParties) {
      usersCanNotEdit = getInterestedPartiesModel!.interestedParties!
          .where((e) => e.ipAddedById != UserDataConstants.userId)
          .map((e) => e.ipInterestedPartyId!)
          .toList();
    }

    print('selectedUsers: ${selectedUsers.length}');
    emit(InitialValuesState());
  }

  void toggleSelectedUsers(UserModel user) {
    if (selectedUsers.contains(user)) {
      selectedUsers.remove(user);
    } else {
      selectedUsers.add(user);
    }
    print('selectedInterestedParties: ${selectedUsers.length}');

    emit(ToggleSelectedUsersState());
  }
}
