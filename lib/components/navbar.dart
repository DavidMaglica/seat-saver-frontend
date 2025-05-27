import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../themes/theme.dart';

class NavBar extends StatelessWidget {
  final BuildContext context;
  final int currentIndex;
  final Function(int, BuildContext) onTap;

  const NavBar({
    super.key,
    required this.currentIndex,
    required this.context,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => onTap(index, context),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        selectedItemColor: AppThemes.accent1,
        unselectedItemColor: Theme.of(context).colorScheme.background,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house_fill),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.location_solid),
            label: 'Nearby',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.info_circle_fill),
            label: 'Info',
          ),
        ],
      ),
    );
  }
}
