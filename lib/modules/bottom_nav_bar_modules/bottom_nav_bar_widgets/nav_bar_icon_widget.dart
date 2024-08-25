import 'package:flutter/cupertino.dart';

class NavBarIconWidget extends StatelessWidget {
  final IconData icon;

  const NavBarIconWidget({required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      child: Icon(
        icon,
        size: 20,
      ),
    );
  }
}
