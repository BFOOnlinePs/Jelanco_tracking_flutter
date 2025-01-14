import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/values/assets_keys.dart';
import 'package:jelanco_tracking_system/modules/manager_employees_modules/cubit/manager_employees_cubit.dart';
import 'package:jelanco_tracking_system/modules/manager_employees_modules/cubit/manager_employees_states.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/shared_widgets/user_card_widget.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/loaders/my_loader.dart';
import 'package:jelanco_tracking_system/widgets/my_refresh_indicator/my_refresh_indicator.dart';
import 'package:jelanco_tracking_system/widgets/my_screen.dart';
import 'package:jelanco_tracking_system/widgets/my_title_screen/my_title_screen_widget.dart';

class ManagerEmployeesScreen extends StatelessWidget {
  const ManagerEmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('build');
    ManagerEmployeesCubit managerEmployeesCubit;
    return Scaffold(
      appBar: const MyAppBar(
        title: 'متابعة الموظفين',
      ),
      body: BlocProvider(
        create: (context) => ManagerEmployeesCubit()
          ..getManagerEmployees(
            loadingState: GetManagerEmployeesLoadingState(),
            successState: GetManagerEmployeesSuccessState(),
            errorState: GetManagerEmployeesErrorState(),
          ),
        child: BlocConsumer<ManagerEmployeesCubit, ManagerEmployeesStates>(
          listener: (context, state) {},
          builder: (context, state) {
            print('builder');
            managerEmployeesCubit = ManagerEmployeesCubit.get(context);
            return MyScreen(
              child: Column(
                children: [
                  const MyScreenTitleWidget(
                    title: 'موظفين أقوم بمتابعتهم',
                  ),
                  Expanded(
                          child: managerEmployeesCubit.getManagerEmployeesModel ==
                            null
                        ? const Center(child: MyLoader())
                        : MyRefreshIndicator(
                            onRefresh: () {
                              return managerEmployeesCubit.getManagerEmployees(
                                loadingState: GetManagerEmployeesLoadingState(),
                                successState: GetManagerEmployeesSuccessState(),
                                errorState: GetManagerEmployeesErrorState(),
                              );
                            },
                            child: managerEmployeesCubit
                                    .getManagerEmployeesModel!
                                    .managerEmployees!
                                    .isEmpty
                                ? const Center(
                                    child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image(
                                        image: AssetImage(
                                          AssetsKeys.defaultNoUsersImage,
                                        ),
                                        height: 250,
                                      ),
                                      Text('لا يوجد مستخدمين'),
                                    ],
                                  ))
                                : ListView.builder(
                                    itemBuilder: (context, index) {
                                      return UserCardWidget(
                                          userModel: managerEmployeesCubit
                                              .getManagerEmployeesModel!
                                              .managerEmployees![index]);
                                    },
                                    itemCount: managerEmployeesCubit
                                        .getManagerEmployeesModel!
                                        .managerEmployees!
                                        .length,
                                  ),
                          ),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
