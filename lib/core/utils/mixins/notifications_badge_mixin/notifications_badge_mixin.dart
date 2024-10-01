// import 'package:bloc/bloc.dart';
// import 'package:jelanco_tracking_system/core/constants/end_points.dart';
// import 'package:jelanco_tracking_system/models/notifications_models/unread_notifications_count_model.dart';
// import 'package:jelanco_tracking_system/network/remote/dio_helper.dart';
//
// mixin NotificationsBadgeMixin<T> on Cubit<T> {
//   UnreadNotificationsCountModel? unreadNotificationsCountModel;
//
//   Future<void> getUnreadNotificationsCount({
//     required T successState,
//   }) async {
//     await DioHelper.getData(
//       url: EndPointsConstants.unreadNotificationsCount,
//     ).then((value) {
//       print(value?.data);
//       unreadNotificationsCountModel = UnreadNotificationsCountModel.fromMap(value?.data);
//       emit(successState);
//     }).catchError((error) {
//       print(error.toString());
//     });
//   }
//
// //   void changeNotificationsBadge({
// //     required T changeState,
// // }) {
// //     print('changeNotificationsBadge ');
// //     print(unreadNotificationsCountModel?.unreadNotificationsCount);
// //     unreadNotificationsCountModel?.unreadNotificationsCount =
// //         unreadNotificationsCountModel?.unreadNotificationsCount ?? 0 - 1;
// //     print(unreadNotificationsCountModel?.unreadNotificationsCount);
// //
// //     emit(changeState);
// //   }
// }
