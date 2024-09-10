import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'اسم صاحب الملف الشخصي',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('data'),
          ],
        ),
      ),
    );
  }
}
