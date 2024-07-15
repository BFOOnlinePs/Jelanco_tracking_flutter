import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/models/basic_models/user_model.dart';
import 'package:jelanco_tracking_system/modules/add_task_modules/add_task_widgets/assigned_to_states/assigned_to_states.dart';

class AssignedToCubit extends Cubit<AssignedToStates> {
  AssignedToCubit() : super(AssignedToInitialState());

  static AssignedToCubit get(context) => BlocProvider.of(context);

  List<UserModel> users = []; // all users
  List<UserModel> selectedUsers = []; // checked
  List<UserModel> filteredUsers = []; // from search

  void initialValues({
    required List<UserModel> usersList,
    required List<UserModel> selectedUsersList,
  }) {
    users = usersList;
    filteredUsers = usersList;
    selectedUsers = selectedUsersList;
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredUsers = users;
    } else {
      filteredUsers = users
          .where(
              (user) => user.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    emit(FilterUsersOnSearchState());
  }

  void checkBoxChanged(bool? value, UserModel user) {
    if (value != null) {
      if (value) {
        selectedUsers.add(user);
      } else {
        selectedUsers.remove(user);
      }
    }
    emit(CheckBoxChangedState());
  }
}
