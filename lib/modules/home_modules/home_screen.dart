import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/core/constants/user_data.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';
import 'package:jelanco_tracking_system/widgets/my_spacers/my_horizontal_spacer.dart';

import '../../widgets/my_drawer/my_drawer.dart';
import '../../widgets/my_spacers/my_vertical_spacer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'home_page_title'.tr(),
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          // User Profile and Input Field
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsetsDirectional.only(
                    start: 16, end: 16, top: 16, bottom: 10),
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  // backgroundImage: AssetImage(
                  //     'assets/profile.jpg'),e
                ),
              ),
              // MyHorizontalSpacer(),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 12),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "ماذا فعلت اليوم؟",
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ],
          ),

          Divider(
            thickness: 0.2,
          ),

          // Media Options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMediaOption(
                icon: Icons.image,
                label: 'صور',
                color: Colors.green,
                onTap: () {
                  // Handle image selection
                },
              ),
              Container(width: 0.2, height: 26, color: Colors.grey),
              _buildMediaOption(
                icon: Icons.video_camera_back,
                label: 'فيديوهات',
                color: Colors.red,
                onTap: () {
                  // Handle video selection
                },
              ),
              Container(width: 0.2, height: 26, color: Colors.grey),
              _buildMediaOption(
                icon: Icons.attach_file,
                label: 'ملفات',
                color: Colors.blue,
                onTap: () {
                  // Handle file selection
                },
              ),
            ],
          ),

          Divider(
            thickness: 5,
          ),

          // Placeholder for selected media (images/videos/files)
          // You can display selected images, videos, and files here
          Expanded(
            child: Center(
              child: Text('Selected media will appear here'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaOption(
      {required IconData icon,
      required String label,
      required Color color,
      required Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
