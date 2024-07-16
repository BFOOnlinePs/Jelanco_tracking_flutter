import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Task {
  final int? tId;
  final String? tContent;
  final DateTime? tPlanedStartTime;
  final DateTime? tPlanedEndTime;
  final String? tStatus;
  final int? tCategoryId;
  final int? tAddedBy;
  final String? tAssignedTo;
  final String? tSupervisorNotes;
  final String? tManagerNotes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<UserModel>? assignedToUsers;
  final TaskCategoryModel? taskCategory;
  final UserModel? addedByUser;
  final List<Submission>? submissions;

  Task({
    this.tId,
    this.tContent,
    this.tPlanedStartTime,
    this.tPlanedEndTime,
    this.tStatus,
    this.tCategoryId,
    this.tAddedBy,
    this.tAssignedTo,
    this.tSupervisorNotes,
    this.tManagerNotes,
    this.createdAt,
    this.updatedAt,
    this.assignedToUsers,
    this.taskCategory,
    this.addedByUser,
    this.submissions,
  });
}

class UserModel {
  final String name;

  UserModel({required this.name});
}

class TaskCategoryModel {
  final String name;

  TaskCategoryModel({required this.name});
}

class Submission {
  final String name;
  final String content;
  final DateTime actualStartTime;
  final DateTime actualEndTime;
  final String file;
  final String status;
  final List<Comment> comments;

  Submission({
    required this.name,
    required this.content,
    required this.actualStartTime,
    required this.actualEndTime,
    required this.file,
    required this.status,
    required this.comments,
  });
}

class Comment {
  final String commenterName;
  final String content;

  Comment({required this.commenterName, required this.content});
}


Task mockTask = Task(
  tId: 1,
  tContent: 'Design new UI for the mobile app',
  tPlanedStartTime: DateTime.now(),
  tPlanedEndTime: DateTime.now().add(Duration(days: 1)),
  tStatus: 'In Progress',
  tCategoryId: 101,
  tAddedBy: 1,
  tAssignedTo: 'John Doe',
  tSupervisorNotes: 'Ensure the design is user-friendly.',
  tManagerNotes: 'Approved by the manager.',
  createdAt: DateTime.now().subtract(Duration(days: 1)),
  updatedAt: DateTime.now(),
  assignedToUsers: [UserModel(name: 'John Doe'), UserModel(name: 'Jane Smith')],
  taskCategory: TaskCategoryModel(name: 'UI Design'),
  addedByUser: UserModel(name: 'Alice Johnson'),
  submissions: [
    Submission(
      name: 'Initial Design',
      content: 'Initial design submission',
      actualStartTime: DateTime.now().subtract(Duration(hours: 5)),
      actualEndTime: DateTime.now(),
      file: 'design.png',
      status: 'Submitted',
      comments: [
        Comment(commenterName: 'John Doe', content: 'Looks good!'),
        Comment(commenterName: 'Jane Smith', content: 'Can we change the color scheme?'),
      ],
    ),
    Submission(
      name: 'Final Design',
      content: 'Final design submission',
      actualStartTime: DateTime.now().subtract(Duration(days: 1)),
      actualEndTime: DateTime.now().subtract(Duration(hours: 3)),
      file: 'final_design.png',
      status: 'Approved',
      comments: [
        Comment(commenterName: 'Alice Johnson', content: 'Excellent work!'),
      ],
    ),
  ],
);




class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  TaskDetailsScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Detailss'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTaskDetailsSection(),
            SizedBox(height: 20),
            _buildSubmissionsSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add action for adding a new submission
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildTaskDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Task Details'),
        _buildDetailRow('Task Content', task.tContent ?? 'N/A', Icons.description, isMultiline: true),
        _buildDetailRow('Planned Start Time', task.tPlanedStartTime?.toString() ?? 'N/A', Icons.timer),
        _buildDetailRow('Planned End Time', task.tPlanedEndTime?.toString() ?? 'N/A', Icons.timer_off),
        _buildStatusRow('Status', task.tStatus ?? 'N/A', Icons.flag),
        _buildCategoryRow('Category', task.taskCategory?.name ?? 'N/A'),
        _buildDetailRow('Assigned To', task.tAssignedTo ?? 'N/A', Icons.person),
        _buildDetailRow('Supervisor Notes', task.tSupervisorNotes ?? 'N/A', Icons.notes, isMultiline: true),
        _buildDetailRow('Manager Notes', task.tManagerNotes ?? 'N/A', Icons.notes, isMultiline: true),
        _buildDateRow('Created At', task.createdAt?.toString() ?? 'N/A', Icons.calendar_today),
        _buildDateRow('Updated At', task.updatedAt?.toString() ?? 'N/A', Icons.update),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blue[900],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blue[700]),
          SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue[900]),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[800], fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, IconData icon) {
    Color statusColor;
    switch (value.toLowerCase()) {
      case 'completed':
        statusColor = Colors.green;
        break;
      case 'in progress':
        statusColor = Colors.orange;
        break;
      case 'pending':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: statusColor),
          SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue[900]),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: statusColor, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.category, color: Colors.purple[700]),
          SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue[900]),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                value,
                style: TextStyle(color: Colors.purple[900], fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[700]),
          SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue[900]),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[800], fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Submissions'),
        ...task.submissions?.map((submission) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              border: Border(
                left: BorderSide(
                  color: Colors.orange,
                  width: 5.0,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSubmissionHeader(submission),
                _buildDetailRow('Content', submission.content, Icons.content_copy, isMultiline: true),
                _buildDetailRow('Actual Start Time', submission.actualStartTime.toString(), Icons.access_time),
                _buildDetailRow('Actual End Time', submission.actualEndTime.toString(), Icons.access_time_outlined),
                _buildDetailRow('File', submission.file, Icons.attach_file),
                _buildStatusRow('Status', submission.status, Icons.info),
                SizedBox(height: 10),
                _buildCommentsSection(submission.comments),
              ],
            ),
          );
        }).toList() ?? [],
      ],
    );
  }

  Widget _buildSubmissionHeader(Submission submission) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Submission: ${submission.name}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.orange[800]),
        ),
        IconButton(
          icon: Icon(Icons.edit, color: Colors.orange[800]),
          onPressed: () {
            // Add action for editing the submission
          },
        ),
      ],
    );
  }

  Widget _buildCommentsSection(List<Comment> comments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Comments:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.orange[800])),
        ...comments.map((comment) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.grey[700]),
                    SizedBox(width: 10),
                    Text(
                      comment.commenterName,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800], fontSize: 16),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0, top: 4.0),
                  child: Text(
                    comment.content,
                    style: TextStyle(color: Colors.grey[800], fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}




