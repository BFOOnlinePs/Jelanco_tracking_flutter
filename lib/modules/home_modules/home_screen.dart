import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jelanco_tracking_system/widgets/app_bar/my_app_bar.dart';

import '../../widgets/my_drawer/my_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'home_page_title'.tr(),),
      drawer: MyDrawer(),
      body: Column(
        children: [],
      ),
    );
  }
}
