import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChange;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(128), blurRadius: 8),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: GNav(
          rippleColor: Colors.white,
          hoverColor: const Color.fromARGB(255, 138, 67, 67),
          haptic: true,
          tabBorderRadius: 30,
          tabActiveBorder: Border.all(color: Colors.white, width: 0),
          tabBorder: Border.all(color: Colors.grey, width: 0),
          tabShadow: [
            BoxShadow(color: Colors.white.withAlpha(128), blurRadius: 0)
          ],
          duration: const Duration(milliseconds: 100),
          gap: 8,
          color: Colors.black,
          activeColor: Colors.white,
          iconSize: 24,
          tabBackgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          selectedIndex: currentIndex,
          onTabChange: onTabChange,
          tabs: const [
            GButton(
              icon: Icons.dashboard,
              text: 'Manage',
            ),
            GButton(
              icon: Icons.settings_remote,
              text: 'Control',
            ),
            GButton(
              icon: Icons.settings,
              text: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
