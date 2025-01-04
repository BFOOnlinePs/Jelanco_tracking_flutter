import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/formats_utils.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/departments_mixin/departments_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/password_visibility_mixin/password_visibility_mixin.dart';
import 'package:jelanco_tracking_system/core/utils/mixins/users_mixin/get_user_by_id_mixin.dart';
import 'package:jelanco_tracking_system/enums/user_status_enum.dart';
import 'package:jelanco_tracking_system/models/basic_models/department_model.dart';
import 'package:jelanco_tracking_system/models/users_models/add_update_user_model.dart';
import 'package:jelanco_tracking_system/modules/users_management_modules/add_edit_user_modules/cubit/add_edit_user_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class AddEditUserCubit extends Cubit<AddEditUserStates>
    with PasswordVisibilityMixin<AddEditUserStates>, DepartmentsMixin<AddEditUserStates>, GetUserByIdMixin<AddEditUserStates> {
  AddEditUserCubit() : super(AddUserInitialState());

  static AddEditUserCubit get(context) => BlocProvider.of(context);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController jobTitleController = TextEditingController();
  MultiSelectController<DepartmentModel>? dropDownDepartmentsController = MultiSelectController<DepartmentModel>();
  List<DepartmentModel> selectedDepartments = [];
  UserStatusEnum? userStatusEnum;

  String? validatePhoneAndEmail() {
    if (phoneController.text.isEmpty && emailController.text.isEmpty) {
      return 'يجب ادخال رقم الهاتف او البريد الالكتروني';
    }
    return null;
  }

  void initializeCubit({int? userId}) async {
    // Fetch all departments
    await getAllDepartments(
      loadingState: GetAllDepartmentsLoadingState(),
      successState: GetAllDepartmentsSuccessState(),
      errorState: GetAllDepartmentsErrorState(),
    );

    dropDownDepartmentsController!
        .addItems(getDepartmentsModel?.departments?.map((e) => DropdownItem(label: e.dName ?? 'no dep name', value: e)).toList() ?? []);

    // Fetch user details if editing
    if (userId != null) {
      await getUserById(
        userId: userId,
        loadingState: GetUserByIdLoadingState(),
        successState: GetUserByIdSuccessState(),
        errorState: GetUserByIdErrorState(),
      );

      nameController.text = getUserByIdModel?.user?.name ?? '';
      emailController.text = getUserByIdModel?.user?.email ?? '';
      phoneController.text = getUserByIdModel?.user?.phoneNumber ?? '';
      jobTitleController.text = getUserByIdModel?.user?.jobTitle ?? '';
      userStatusEnum = UserStatusEnum.getStatus(getUserByIdModel?.user?.userStatus);
      selectedDepartments = getDepartmentsModel?.departments
              ?.where((dep) => getUserByIdModel?.user?.userDepartments?.any((element) => element.dId == dep.dId) ?? false)
              .toList() ??
          [];

      // final List<int> selectedDepartmentIds = FormatUtils.convertStringListToIntList(getUserByIdModel?.user?.departments ?? '');

      // The selectWhere method should be called after the items have been added to the controller
      Future.delayed(const Duration(milliseconds: 1000), () {
        dropDownDepartmentsController?.selectWhere((element) {
          return selectedDepartments.any((selectedDepartment) => selectedDepartment.dId == element.value.dId);
        });
      });

      emit(InitializeDataDoneState());
    }
  }

  AddUpdateUserModel? addUpdateUserModel;

  void addUpdateUser({int? userId}) {
    print("user status ${userStatusEnum?.statusDBName}");
    emit(AddUpdateUserLoadingState());
    DioHelper.postData(url: EndPointsConstants.users + (userId != null ? '/$userId' : ''), data: {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'password': passwordController.text,
      'job_title': jobTitleController.text,
      'status': 1,
      'departments': selectedDepartments.isEmpty
          ? null
          : FormatUtils.formatList<DepartmentModel>(selectedDepartments, (department) => department?.dId.toString()),
      'status': userStatusEnum?.statusDBName,
    }).then((value) {
      print(value?.data);
      addUpdateUserModel = AddUpdateUserModel.fromMap(value?.data);
      emit(AddUpdateUserSuccessState(addUpdateUserModel!));
    }).catchError((error) {
      emit(AddUpdateUserErrorState());
      print(error.toString());
    });
  }

  void updateUserStatus({required bool isActive}) {
    print('user status ${userStatusEnum?.statusDBName}');
    userStatusEnum = isActive ? UserStatusEnum.active : UserStatusEnum.inactive;
    print('user status ${userStatusEnum?.statusDBName}');
    emit(UpdateUserStatusState());
  }

// void updateUser({required int userId}) {
//   emit(UpdateUserLoadingState());
//   DioHelper.putData(url: '${EndPointsConstants.users}/$userId', data: {
//     'name': nameController.text,
//     'email': emailController.text,
//     'phone': phoneController.text,
//     'job_title': jobTitleController.text,
//     'departments': selectedDepartments.isEmpty
//         ? null
//         : FormatUtils.formatList<DepartmentModel>(selectedDepartments, (department) => department?.dId.toString()),
//   }).then((value) {
//     print(value?.data);
//     addUpdateUserModel = AddUpdateUserModel.fromMap(value?.data);
//     emit(UpdateUserSuccessState(addUpdateUserModel!));
//   }).catchError((error) {
//     emit(UpdateUserErrorState());
//     print(error.toString());
//   });
// }
}
