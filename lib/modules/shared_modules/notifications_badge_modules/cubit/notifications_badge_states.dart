
abstract class NotificationsBadgeStates {}

class NotificationsInitialState extends NotificationsBadgeStates {}

class NotificationsSuccessState extends NotificationsBadgeStates {}

class NotificationsErrorState extends NotificationsBadgeStates {
  final String error;

  NotificationsErrorState(this.error);
}