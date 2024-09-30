import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/notifications_utils.dart';
import 'package:jelanco_tracking_system/core/utils/scroll_utils.dart';
import 'package:jelanco_tracking_system/enums/notifications_filter_enum.dart';
import 'package:jelanco_tracking_system/models/basic_models/notification_model.dart';
import 'package:jelanco_tracking_system/models/notifications_models/get_user_notifications_model.dart';
import 'package:jelanco_tracking_system/modules/home_modules/home_cubit/home_cubit.dart';
import 'package:jelanco_tracking_system/modules/notifications_modules/cubit/notifications_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

import '../../home_modules/home_cubit/home_states.dart';

class NotificationsCubit extends Cubit<NotificationsStates> {
  NotificationsCubit() : super(NotificationsInitialState());

  static NotificationsCubit get(context) => BlocProvider.of<NotificationsCubit>(context);

  ScrollController scrollController = ScrollController();

  GetUserNotificationsModel? getUserNotificationsModel;
  List<NotificationModel> userNotificationsList = [];

  bool isUserNotificationsLoading = false;
  bool isUserNotificationsLastPage = false;

  Future<void> getUserNotifications({
    NotificationsFilterEnum? newSelectedFilter,
    int page = 1,
  }) async {
    emit(GetUserNotificationsLoadingState());
    isUserNotificationsLoading = true;

    print('is read: ${newSelectedFilter?.name}');
    await DioHelper.getData(url: EndPointsConstants.notifications, query: {
      'per_page': 8,
      'page': page,
      'is_read': newSelectedFilter?.code == 2 ? null : newSelectedFilter?.code,
    }).then((value) {
      print(value?.data);
      // when refresh
      if (page == 1) {
        userNotificationsList.clear();
      }
      getUserNotificationsModel = GetUserNotificationsModel.fromMap(value?.data);
      userNotificationsList.addAll(getUserNotificationsModel?.notifications as Iterable<NotificationModel>);

      isUserNotificationsLastPage =
          getUserNotificationsModel?.pagination?.lastPage == getUserNotificationsModel?.pagination?.currentPage;

      isUserNotificationsLoading = false;

      emit(GetUserNotificationsSuccessState());
    }).catchError((error) {
      emit(GetUserNotificationsErrorState());
      print(error.toString());
    });
  }

  bool isRefresh = false; // to show only one loader at a time

  NotificationsFilterEnum selectedFilter = NotificationsFilterEnum.all;

  void changeSelectedFilter(NotificationsFilterEnum newSelectedFilter) {
    selectedFilter = newSelectedFilter;
    print('Selected filter: $selectedFilter');
    // emit(ChangeSelectedFilterState());
    getUserNotifications(newSelectedFilter: selectedFilter);
    // scroll to beginning
    ScrollUtils.scrollPosition(scrollController: scrollController);
  }

  Future<void> notificationClicked({required NotificationModel notificationModel}) async {
    NotificationsUtils.navigateFromNotification(
      notificationId: notificationModel.id!,
      type: notificationModel.type,
      typeId: notificationModel.typeId.toString(),
    );

    print('Notification clicked: ${notificationModel.id}');

    // Communicate with HomeCubit to update the badge
    // HomeCubit.get(context).changeNotificationsBadge(changeState: NotificationsBadgeChangedState());
    
    
    Future.delayed(const Duration(seconds: 1), () {
      notificationModel.isRead = 1;
      emit(NotificationClickedState());
    });
  }
}
