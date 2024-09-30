import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/notifications_utils.dart';
import 'package:jelanco_tracking_system/models/basic_models/notification_model.dart';
import 'package:jelanco_tracking_system/models/notifications_models/get_user_notifications_model.dart';
import 'package:jelanco_tracking_system/modules/notifications_modules/cubit/notifications_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class NotificationsCubit extends Cubit<NotificationsStates> {
  NotificationsCubit() : super(NotificationsInitialState());

  static NotificationsCubit get(context) =>
      BlocProvider.of<NotificationsCubit>(context);

  GetUserNotificationsModel? getUserNotificationsModel;

  Future<void> getUserNotifications({int? isRead}) async {
    emit(GetUserNotificationsLoadingState());
    print('is read: $isRead');

    await DioHelper.getData(
        url: EndPointsConstants.notifications,
        query: {'is_read': isRead == 2 ? null : isRead}).then((value) {
      print(value?.data);
      getUserNotificationsModel =
          GetUserNotificationsModel.fromMap(value?.data);
      emit(GetUserNotificationsSuccessState());
    }).catchError((error) {
      emit(GetUserNotificationsErrorState());
      print(error.toString());
    });
  }

  int selectedFilter = 2; // 2: All, 1: Read, 0: Unread

  void changeSelectedFilter(int index) {
    selectedFilter = index;
    print('Selected filter: $selectedFilter');
    getUserNotifications(isRead: selectedFilter);
    emit(ChangeSelectedFilterState());
  }

  // when click on notification
  Future<void> notificationClicked(
      {required NotificationModel notificationModel}) async {
    NotificationsUtils.navigateFromNotification(
      notificationId: notificationModel.id!,
      type: notificationModel.type,
      typeId: notificationModel.typeId.toString(),
    );
    // wait second
    Future.delayed(const Duration(seconds: 1), () {
      notificationModel.isRead = 1;
      emit(NotificationClickedState());
    });
  }
}
