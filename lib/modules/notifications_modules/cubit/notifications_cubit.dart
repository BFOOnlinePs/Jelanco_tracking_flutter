import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/core/utils/notifications_utils.dart';
import 'package:jelanco_tracking_system/enums/notifications_filter_enum.dart';
import 'package:jelanco_tracking_system/models/basic_models/notification_model.dart';
import 'package:jelanco_tracking_system/models/notifications_models/get_user_notifications_model.dart';
import 'package:jelanco_tracking_system/modules/notifications_modules/cubit/notifications_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class NotificationsCubit extends Cubit<NotificationsStates> {
  NotificationsCubit() : super(NotificationsInitialState());

  static NotificationsCubit get(context) =>
      BlocProvider.of<NotificationsCubit>(context);

  GetUserNotificationsModel? getUserNotificationsModel;

  Future<void> getUserNotifications({NotificationsFilterEnum? newSelectedFilter}) async {
    emit(GetUserNotificationsLoadingState());
    print('is read: ${newSelectedFilter?.name}');
    await DioHelper.getData(
        url: EndPointsConstants.notifications,
        query: {'is_read': newSelectedFilter?.code == 2 ? null : newSelectedFilter?.code}).then((value) {
      print(value?.data);
      getUserNotificationsModel =
          GetUserNotificationsModel.fromMap(value?.data);
      emit(GetUserNotificationsSuccessState());
    }).catchError((error) {
      emit(GetUserNotificationsErrorState());
      print(error.toString());
    });
  }

  bool isRefresh = false;

  NotificationsFilterEnum selectedFilter = NotificationsFilterEnum.getStatus(2); // 2: All, 1: Read, 0: Unread

  void changeSelectedFilter(NotificationsFilterEnum newSelectedFilter) {
    selectedFilter = newSelectedFilter;
    print('Selected filter: $selectedFilter');
    // emit(ChangeSelectedFilterState());
    getUserNotifications(newSelectedFilter: selectedFilter);
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
