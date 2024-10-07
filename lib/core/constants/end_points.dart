class EndPointsConstants {
  /// HOST
  static const String baseUrl = '$url/api/';
  static const String url = 'https://jelanco.bfohost.com';
  static const String socketIoUrl = 'http://46.60.127.162:3000'; //  https://jelanco.bfohost.com:3000
  static const String tasksStorage = '$url/storage/tasks_attachments/';
  static const String taskSubmissionsStorage = '$url/storage/uploads/';
  static const String taskSubmissionsCommentStorage = '$url/storage/comments_attachments/';
  static const String thumbnailStorage = '$url/storage/thumbnails/';
  static const String profileStorage = '$url/storage/profile_images/';

  /// LOCAL
  // static const String baseUrl = '$url/public/api/';
  // static const String url = 'http://192.168.1.23/BFO/jelanco_tracking';
  // static const String socketIoUrl = 'http://192.168.1.23:3000';
  // static const String tasksStorage = '$url/public/storage/tasks_attachments/';
  // static const String taskSubmissionsStorage = '$url/public/storage/uploads/';
  // static const String taskSubmissionsCommentStorage = '$url/public/storage/comments_attachments/';
  // static const String thumbnailStorage = '$url/public/storage/thumbnails/';
  // static const String profileStorage = '$url/public/storage/profile_images/';

  // auth
  static const String login = 'login';
  static const String logout = 'logout';

  // tasks
  static const String tasks = 'tasks';
  static const String tasksAddedByUser = '$tasks/added-by-user';
  static const String tasksAssignedToUser = '$tasks/assigned-to-user';
  static const String tasksWithSubmissionsAndComments =
      'submissions-and-comments'; // /tasks/10/submissions-and-comments
  static const String tasksToSubmit = '$tasks/user-not-submitted-tasks';

  // tasks submissions
  static const String userSubmissions = 'user-submissions';
  static const String taskSubmissions = 'task-submissions';
  static const String taskSubmissionWithTaskAndComments = 'task-and-comments';
  static const String taskSubmissionVersions = 'versions'; // /task-submissions/106/versions
  static const String todaySubmissions = '$taskSubmissions/today';

  // task submission comment
  static const String taskSubmissionComments = 'comments';
  static const String taskSubmissionCommentsCount = 'count'; // /task-submissions/185/comments/count

  // categories
  static const String taskCategories = 'task-categories';

  // users
  static const String users = 'users';
  static const String userProfile = '$users/profile'; // /users/profile/1
  static const String updateProfile = '$userProfile/image'; // /users/profile/image

  // manager employees
  static const String managers = '$users/managers';
  static const String managerEmployees = '$users/employees';
  static const String managerEmployeesWithTaskAssignees = '$users/employees/with-task-assignees';
  static const String addEditManagerEmployees = '$managerEmployees/add-edit'; // /users/employees/add-edit
  static const String deleteManager = '$managers/delete'; // users/managers/delete

  // notifications
  static const String notifications = 'notifications';
  static const String readNotifications = '$notifications/read';
  static const String unreadNotificationsCount = '$notifications/unread-count';

  // FCM
  static const sendNotification = 'https://fcm.googleapis.com/fcm/send';
  static const storeFcmUserTokenEndPoint = 'storeFcmUserToken';
  static const deleteFcmUserTokenEndPoint = 'deleteFcmUserToken';
  static const updateFcmUserTokenEndPoint = 'updateFcmUserToken';
}
