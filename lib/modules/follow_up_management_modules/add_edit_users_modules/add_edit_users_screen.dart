import 'package:flutter/material.dart';

class AddEditUsersScreen extends StatefulWidget {
  final String? selectedUser;

  const AddEditUsersScreen({super.key, this.selectedUser});

  @override
  _AddEditUsersScreenState createState() => _AddEditUsersScreenState();
}

class _AddEditUsersScreenState extends State<AddEditUsersScreen> {
  List<String> allUsers = ['User 1', 'User 2', 'User 3', 'User 4', 'User 5'];
  List<String> selectedUsers = []; // Selected users for follow-up
  List<String> filteredAllUsers = []; // Filtered list of all users
  String searchTextAll = '';
  String? selectedUser;

  @override
  void initState() {
    super.initState();
    // Initialize selected user if provided
    selectedUser = widget.selectedUser; // Set the selected user from widget
    filteredAllUsers = allUsers; // Initialize with all users
  }

  void updateSearchResultsAll(String query) {
    setState(() {
      searchTextAll = query;
      filteredAllUsers = allUsers
          .where((user) => user.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void saveUser() {
    if (selectedUser != null) {
      // Return the selected user and selected users
      Navigator.pop(context, selectedUsers);
    }
  }

  void selectUser(String user) {
    setState(() {
      selectedUser = user; // Set the selected user
    });
  }

  void toggleUserSelection(String user) {
    setState(() {
      if (selectedUsers.contains(user)) {
        selectedUsers.remove(user);
      } else {
        selectedUsers.add(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة / تعديل الموظفين'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for selecting a user
            Text(
              'المسؤول:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              // value: selectedUser,
              hint: Text('إختر موظف'),
              items: allUsers.map((String user) {
                return DropdownMenuItem<String>(
                  value: user,
                  child: Text(user),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedUser = newValue; // Update the selected user
                });
              },
              validator: (value) => value == null ? 'الرجاء إختيار موظف' : null,
            ),
            SizedBox(height: 20),
            // Search for selecting multiple users
            Text(
              'تحديد الموظفين للمتابعة:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'بحث عن موظفين',
                border: OutlineInputBorder(),
              ),
              onChanged: updateSearchResultsAll,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredAllUsers.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(filteredAllUsers[index]),
                    value: selectedUsers.contains(filteredAllUsers[index]),
                    onChanged: (bool? value) {
                      toggleUserSelection(filteredAllUsers[index]);
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: saveUser,
              child: Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }
}
