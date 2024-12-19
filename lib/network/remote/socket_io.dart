import 'package:jelanco_tracking_system/core/constants/end_points.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_comment_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIO {
  static final SocketIO _instance = SocketIO._internal();
  late IO.Socket socket;

  factory SocketIO() {
    return _instance;
  }

  SocketIO._internal() {
    print('Socket.IO inside socket Service');
    socket = IO.io(EndPointsConstants.socketIoUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'secure': true,
      'forceNew': true,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to Socket.IO server ..');
    });

    socket.on('connect_error', (data) {
      print('Socket.IO  Connection Error: $data');
    });

    socket.on('disconnect', (_) {
      print('Disconnected from Socket.IO server');
    });
  }

  void addComment(TaskSubmissionCommentModel comment) {
    final commentMap = comment.toMap(); // Convert the object to a map
    print('Socket.IO New comment emitted: $commentMap');
    // the receiver is socket.on('new-comment', (data) { })
    socket.emit('new-comment', commentMap);
  }

  // void newNotification({NotificationModel? notification}) {
  //   final notificationMap = notification?.toMap(); // Convert the object to a map
  //   print('Socket.IO New notification emitted: $notificationMap');
  //   // the receiver is socket.on('new-notification', (data) { })
  //   socket.emit('new-notification', 'notificationMap');
  //   print('after emit');
  // }

// void emitNewComment(Map<String, dynamic> comment) {
//   socket.emit('new-comment', comment);
// }
}
