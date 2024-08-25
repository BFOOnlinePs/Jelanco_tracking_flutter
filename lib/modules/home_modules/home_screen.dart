import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_cubit.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_states.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_widgets/home_add_submission_widget.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_widgets/home_tasks_to_submit_widget.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_widgets/home_user_submissions_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  late HomeCubit homeCubit;

  @override
  bool get wantKeepAlive => true;

  // @override
  // void initState() {
  //   super.initState();
  //
  //   homeCubit = HomeCubit.get(context);
  //   homeCubit.getUserSubmissions();
  //   homeCubit.getTasksToSubmit(
  //     perPage: 3,
  //     loadingState: GetTasksToSubmitLoadingState(),
  //     successState: GetTasksToSubmitSuccessState(),
  //     errorState: (error) => GetTasksToSubmitErrorState(error),
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        homeCubit = HomeCubit.get(context);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeAddSubmissionWidget(),
              HomeTasksToSubmitWidget(
                homeCubit: homeCubit,
              ),
              HomeUserSubmissionsWidget(
                homeCubit: homeCubit,
              ),
            ],
          ),
        );
      },
    );
  }
}
