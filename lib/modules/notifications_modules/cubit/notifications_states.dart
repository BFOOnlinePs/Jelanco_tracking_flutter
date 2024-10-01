abstract class NotificationsStates {}

class NotificationsInitialState extends NotificationsStates {}

class GetUserNotificationsLoadingState extends NotificationsStates {}

class GetUserNotificationsSuccessState extends NotificationsStates {}

class GetUserNotificationsErrorState extends NotificationsStates {}

class NotificationClickedState extends NotificationsStates {}

class ChangeSelectedFilterState extends NotificationsStates {}

class ChangeBadgeState extends NotificationsStates {}
