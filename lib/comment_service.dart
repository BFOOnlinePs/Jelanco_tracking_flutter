import 'package:jelanco_tracking_system/models/basic_models/task_submission_comment_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CommentService {
  late IO.Socket socket;

  CommentService() {
    print('Socket.IO inside CommentService');
    socket = IO.io('http://192.168.1.9:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to Socket.IO server ..');
    });

    socket.on('connect_error', (data) {
      print('Socket.IO  Connection Error: $data');
    });

    // socket.on('new-comment', (data) {
    //   print('Socket.IO New comment received: $data');
    //   // Handle the incoming comment (e.g., update UI)
    //   // You may need to update the UI or state here
    // });

    // void emitNewComment(Map<String, dynamic> comment) {
    //   socket.emit('new-comment', comment);
    // }

    socket.on('new-comment', (data) {
      print('from service Socket.IO New comment received: $data');
      // Handle the incoming comment by updating the UI
      // Convert the data to a TaskSubmissionCommentModel object
      TaskSubmissionCommentModel newComment =
          TaskSubmissionCommentModel.fromMap(data);
      // Add the new comment to the existing list in your cubit or state
      // getSubmissionCommentsModel?.submissionComments?.add(newComment);

      // print('Socket.IO New comment received: $data');
      // // Handle the incoming comment (e.g., update UI)
      // // Assuming `data` contains the complete comment object
      // if (data != null && data['comment'] != null) {
      //   var comment = data['comment'];
      //
      //   // add to model list
      //
      //   // Process the comment object here
      //   // e.g., update the state or UI with the new comment
      // }
    });

    socket.on('disconnect', (_) {
      print('Disconnected from Socket.IO server');
    });
  }

  // void addComment(String comment) {
  //   print('Socket.IO New comment emitted: $comment');
  //   socket.emit('new-comment', {'comment': comment});
  // }

  void addComment(TaskSubmissionCommentModel comment) {
    final commentMap = comment.toMap(); // Convert the object to a map
    print('Socket.IO New comment emitted: $commentMap');
    socket.emit('new-comment', commentMap);

    // print('Socket.IO New comment emitted: $comment');
    // socket.emit('new-comment', {'comment': comment});
  }
}

//
// class CommentService {
//   late IO.Socket socket;
//
//   CommentService() {
//     // Initialize and connect to the Socket.IO server
//     socket = IO.io('http://192.168.1.9:3000', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//     });
//
//     // Connect to the server
//     socket.connect();
//
//     // Listen for 'new-comment' events
//     socket.on('new-comment', (data) {
//       print('New comment received: $data');
//       // Handle the incoming comment (e.g., update UI)
//     });
//
//     socket.on('connect', (_) {
//       print('Connected to Socket.IO server');
//     });
//
//     socket.on('disconnect', (_) {
//       print('Disconnected from Socket.IO server');
//     });
//   }
//
//   void addComment(String comment) {
//     socket.emit('new-comment', {'comment': comment});
//   }
// }
