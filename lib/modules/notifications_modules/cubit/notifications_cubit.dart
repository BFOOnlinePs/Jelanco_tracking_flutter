import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/notifications_models/get_user_notifications_model.dart';
import 'package:jelanco_tracking_system/modules/notifications_modules/cubit/notifications_states.dart';
import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';

class NotificationsCubit extends Cubit<NotificationsStates> {
  NotificationsCubit() : super(NotificationsInitialState());

  static NotificationsCubit get(context) =>
      BlocProvider.of<NotificationsCubit>(context);

  GetUserNotificationsModel? getUserNotificationsModel;

  void getUserNotifications() {
    emit(GetUserNotificationsLoadingState());
    DioHelper.getData(url: EndPointsConstants.notifications).then((value) {
      print(value?.data);
      getUserNotificationsModel =
          GetUserNotificationsModel.fromMap(value?.data);
      emit(GetUserNotificationsSuccessState());
    }).catchError((error) {
      emit(GetUserNotificationsErrorState());
      print(error.toString());
    });
  }
  
}
