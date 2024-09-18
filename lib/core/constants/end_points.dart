class EndPointsConstants {
  static const String baseUrl = '$url/public/api/';
  // static const String baseUrl = '$url/api/';

  // static const String url = 'http://chic.ps';

  static const String url = 'http://192.168.1.21/BFO/jelanco_tracking';

  // static const String url = 'https://we.jelanco.net';

  static const String socketIoUrl = 'http://192.168.1.21:3000';
  // static const String socketIoUrl = 'http://chic.ps:3000';

  static const String taskSubmissionsStorage = '$url/public/storage/uploads/';
  static const String taskSubmissionsCommentStorage =
      '$url/public/storage/comments_attachments/';
  static const String thumbnailStorage = '$url/public/storage/thumbnails/';
  static const String profileStorage = '$url/public/storage/profile_images/';

  // static const String taskSubmissionsStorage = '$url/storage/uploads/';
  // static const String taskSubmissionsCommentStorage =
  //     '$url/storage/comments_attachments/';
  // static const String thumbnailStorage = '$url/storage/thumbnails/';
  // static const String profileStorage = '$url/storage/profile_images/';


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
  static const String taskSubmissionVersions =
      'versions'; // /task-submissions/106/versions
  static const String todaySubmissions = '$taskSubmissions/today';

  // task submission comment
  static const String taskSubmissionComments = 'comments';
  static const String taskSubmissionCommentsCount =
      'count'; // /task-submissions/185/comments/count

  // categories
  static const String taskCategories = 'task-categories';

  // users
  static const String users = 'users';
  static const String userProfile = '$users/profile'; // /users/profile/1
  static const String updateProfile =
      '$userProfile/image'; // /users/profile/image

  // manager employees
  static const String managerEmployees = '$users/employees';


  // FCM
  static const sendNotification = 'https://fcm.googleapis.com/fcm/send';
  static const storeFcmUserTokenEndPoint = 'storeFcmUserToken';
  static const deleteFcmUserTokenEndPoint = 'deleteFcmUserToken';
  static const updateFcmUserTokenEndPoint = 'updateFcmUserToken';
}
