import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/colors_constants.dart';
import 'package:jelanco_tracking_system/modules/manager_employees_modules/managers_and_employees_of_user_modules/cubit/managers_and_employees_of_user_cubit.dart';
import 'package:jelanco_tracking_system/modules/manager_employees_modules/managers_and_employees_of_user_modules/cubit/managers_and_employees_of_user_states.dart';
import 'package:jelanco_tracking_system/modules/manager_employees_modules/managers_and_employees_of_user_modules/managers_employees_tap_body.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/loader_with_disable.dart';
import 'package:jelanco_tracking_system/widgets/my_buttons/my_floating_action_button.dart';

class ManagersAndEmployeesOfUserScreen extends StatelessWidget {
  final int userId;
  final String userName;

  ManagersAndEmployeesOfUserScreen({super.key, required this.userId, required this.userName});

  late ManagersAndEmployeesOfUserCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'إدارة المسؤولين و الموظفين',
      ),
      body: BlocProvider(
        create: (context) => ManagersAndEmployeesOfUserCubit()..enterScreenActions(userId: userId),
        child: BlocConsumer<ManagersAndEmployeesOfUserCubit, ManagersAndEmployeesOfUserStates>(
          listener: (context, state) {
            if (state is GetAllUsersSuccessState) {
              // cubit.allUsers = cubit.getAllUsersModel?.users ?? [];
              cubit.filteredManagers = cubit.reorderedUsersListForManagers; // Initialize with all users
              cubit.filteredEmployees = cubit.reorderedUsersListForEmployees; // Initialize with all users
              // cubit.initValues(selectedUserId);
            }
          },
          builder: (context, state) {
            cubit = ManagersAndEmployeesOfUserCubit.get(context);
            return Stack(
              children: [
                DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        labelPadding: EdgeInsets.zero,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: ColorsConstants.primaryColor,
                        labelColor: ColorsConstants.primaryColor,
                        unselectedLabelColor: ColorsConstants.primaryColor.withOpacity(0.8),
                        // indicator: BoxDecoration(
                        //   color: ColorsConstants.primaryColor.withOpacity(0.1),
                        // ),
                        labelStyle: const TextStyle(fontSize: 16, fontFamily: 'Tajawal'),
                        unselectedLabelStyle: const TextStyle(fontSize: 14, fontFamily: 'Tajawal'),
                        dividerHeight: 0.5,
                        tabs: const [Tab(text: 'المسؤولين'), Tab(text: 'الموظفين')],
                      ),
                      Expanded(
                        child: state is GetManagersAndEmployeesOfUserLoadingState || state is GetAllUsersLoadingState
                            ? const Center(child: CircularProgressIndicator())
                            : Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: TabBarView(
                                  children: [
                                    ManagersEmployeesTapBody(isManagersTab: true, cubit: cubit, userId: userId, userName: userName),
                                    ManagersEmployeesTapBody(isManagersTab: false, cubit: cubit, userId: userId, userName: userName),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                state is AssignEmployeeForManagersLoadingState || state is AddEditManagerEmployeesLoadingState
                    ? const LoaderWithDisable()
                    : Container(),
              ],
            );
          },
        ),
      ),
    );
  }
}
