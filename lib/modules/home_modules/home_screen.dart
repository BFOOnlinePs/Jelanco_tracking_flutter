import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_cubit.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_states.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_widgets/home_add_submission_widget.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_widgets/home_tasks_to_submit_widget.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_widgets/home_user_submissions_widget.dart';
import 'package:jelanco_tracking_system/widgets/my_refresh_indicator/my_refresh_indicator.dart';

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

        return MyRefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              homeCubit.getUserSubmissions(),
              homeCubit.getTasksToSubmit(
                perPage: 3,
                loadingState: GetTasksToSubmitLoadingState(),
                successState: GetTasksToSubmitSuccessState(),
                errorState: (error) => GetTasksToSubmitErrorState(error),
              ),
            ]);
          },

          child: CustomScrollView(
            controller: homeCubit.scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: HomeAddSubmissionWidget(
                  homeCubit: homeCubit,
                ),
              ),
              SliverToBoxAdapter(
                child: HomeTasksToSubmitWidget(
                  homeCubit: homeCubit,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == homeCubit.userSubmissionsList.length &&
                        !homeCubit.isUserSubmissionsLastPage) {
                      if (!homeCubit.isUserSubmissionsLoading) {
                        homeCubit.getUserSubmissions(
                          page: homeCubit.getUserSubmissionsModel!.pagination!
                                  .currentPage! +
                              1,
                        );
                      }
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final submission = homeCubit.userSubmissionsList[index];

                    return HomeUserSubmissionsWidget(
                        homeCubit: homeCubit, submission: submission);
                  },
                  childCount: homeCubit.userSubmissionsList.length +
                      (homeCubit.isUserSubmissionsLastPage
                          ? 0
                          : 1), // Replace with your data length
                ),
              ),
            ],
          ),

          // SingleChildScrollView(
          //   // physics: AlwaysScrollableScrollPhysics(),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const HomeAddSubmissionWidget(),
          //       HomeTasksToSubmitWidget(
          //         homeCubit: homeCubit,
          //       ),
          //       HomeUserSubmissionsWidget(
          //         homeCubit: homeCubit,
          //       ),
          //     ],
          //   ),
          // ),
        );
      },
    );
  }
}
