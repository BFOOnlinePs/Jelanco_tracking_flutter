import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_comment_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CommentsPage extends StatefulWidget {
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  List<TaskSubmissionCommentModel> _comments = [];
  late IO.Socket _socket;

  @override
  void initState() {
    super.initState();
    _initializeSocket();
  }

  void _initializeSocket() {
    _socket = IO.io('http://192.168.1.9:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    _socket.connect();

    _socket.onConnect((_) {
      print('Connected to Socket.IO server');
    });

    _socket.on('new-comment', (data) {
      print('New comment received: $data');
      TaskSubmissionCommentModel newComment = TaskSubmissionCommentModel.fromMap(data);
      setState(() {
        _comments.add(newComment);
      });
    });

    _socket.on('connect_error', (data) {
      print('Connection Error: $data');
    });

    _socket.onDisconnect((_) {
      print('Disconnected from Socket.IO server');
    });
  }

  @override
  void dispose() {
    _socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-time Comments'),
      ),
      body: Column(
        children: [
          Text('Comments: ${_comments.length}'),
          Expanded(
            child: ListView.builder(
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return ListTile(
                  title: Text(comment.tscContent ?? 'content'),
                  subtitle: Text(comment.commentedByUser?.name ?? 'name'),
                  // trailing: comment.attachments.isNotEmpty
                  //     ? Icon(Icons.attachment)
                  //     : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}