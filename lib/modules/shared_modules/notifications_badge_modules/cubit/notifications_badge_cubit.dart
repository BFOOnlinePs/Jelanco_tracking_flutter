import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/notifications_models/unread_notifications_count_model.dart';
import 'package:jelanco_tracking_system/modules/shared_modules/notifications_badge_modules/cubit/notifications_badge_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class NotificationsBadgeCubit extends Cubit<NotificationsBadgeStates> {
  NotificationsBadgeCubit() : super(NotificationsInitialState());

  static NotificationsBadgeCubit get(context) => BlocProvider.of(context);

  UnreadNotificationsCountModel? unreadNotificationsCountModel;

  // Function to fetch unread notifications count from the server
  Future<void> getUnreadNotificationsCount() async {
    await DioHelper.getData(
      url: EndPointsConstants.unreadNotificationsCount,
    ).then((value) {
      print(value?.data);
      unreadNotificationsCountModel = UnreadNotificationsCountModel.fromMap(value?.data);
      emit(NotificationsSuccessState()); // Emit success state after fetching
    }).catchError((error) {
      print(error.toString());
      emit(NotificationsErrorState(error.toString())); // Emit error state in case of failure
    });
  }

  // Function to change the notification badge (decrement unread count)
  void changeNotificationsBadge() {
    print('changeNotificationsBadge');
    print(unreadNotificationsCountModel?.unreadNotificationsCount);

    // Correct the decrement operation
    unreadNotificationsCountModel?.unreadNotificationsCount =
        (unreadNotificationsCountModel?.unreadNotificationsCount ?? 0) - 1;

    print(unreadNotificationsCountModel?.unreadNotificationsCount);

    emit(NotificationsSuccessState()); // Emit success state after changing the badge
  }
}