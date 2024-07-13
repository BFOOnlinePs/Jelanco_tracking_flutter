import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AssignedToScreen extends StatefulWidget {
  final Function(List<String>) onSelected;

  AssignedToScreen({required this.onSelected});

  @override
  _AssignedToScreenState createState() => _AssignedToScreenState();
}

class _AssignedToScreenState extends State<AssignedToScreen> {
  List<String> users = ['Alice', 'Bob', 'Charlie', 'Dave'];
  List<String> selectedUsers = [];
  List<String> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    filteredUsers = users;
  }

  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredUsers = users;
      } else {
        filteredUsers = users
            .where((user) => user.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign To'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search users...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: _filterUsers,
            ),
          ),
          Expanded(
            child: ListView(
              children: filteredUsers.map((user) {
                return CheckboxListTile(
                  title: Text(user),
                  value: selectedUsers.contains(user),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value != null) {
                        if (value) {
                          selectedUsers.add(user);
                        } else {
                          selectedUsers.remove(user);
                        }
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.onSelected(selectedUsers);
          Navigator.pop(context);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
