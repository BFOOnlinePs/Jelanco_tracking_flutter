class EndPointsConstants {
  static const String baseUrl = '$url/public/api/';
  static const String url = 'http://192.168.1.15/BFO/jelanco_tracking';

  // static const String url = 'https://we.jelanco.net';

  static const String taskSubmissionsStorage = '$url/public/storage/uploads/';
  static const String taskSubmissionsCommentStorage =
      '$url/public/storage/comments_attachments/';
  static const String thumbnailStorage = '$url/public/storage/thumbnails/';

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
  static const String taskSubmissionVersions =
      'versions'; // /task-submissions/106/versions

  // task submission comment
  static const String taskSubmissionComments = 'comments';

  // categories
  static const String taskCategories = 'task-categories';

  // users
  static const String users = 'users';
}
