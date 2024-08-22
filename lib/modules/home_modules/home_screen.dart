import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_cubit.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_states.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_widgets/home_add_submission_widget.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_widgets/home_tasks_to_submit_widget.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_widgets/home_user_submissions_widget.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import '../../widgets/my_drawer/my_drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  late HomeCubit homeCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'home_page_title'.tr(),
      ),
      drawer: MyDrawer(),
      body: BlocProvider(
        create: (context) => HomeCubit()
          ..getUserSubmissions()
          ..getTasksToSubmit(
            perPage: 3,
              loadingState: GetTasksToSubmitLoadingState(),
              successState: GetTasksToSubmitSuccessState(),
              errorState: (error) => GetTasksToSubmitErrorState(error)),
        child: BlocConsumer<HomeCubit, HomeStates>(
          listener: (context, state) {},
          builder: (context, state) {
            homeCubit = HomeCubit.get(context);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeAddSubmissionWidget(),
                  HomeTasksToSubmitWidget(homeCubit: homeCubit,),
                  HomeUserSubmissionsWidget(homeCubit: homeCubit,),

                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
