import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_reserver/themes/mobile_theme.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int, BuildContext) onTap;

  const NavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => onTap(index, context),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        selectedItemColor: MobileTheme.accent1,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            key: Key('navHome'),
            icon: Icon(CupertinoIcons.house_fill),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            key: Key('navSearch'),
            icon: Icon(CupertinoIcons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            key: Key('navNearby'),
            icon: Icon(CupertinoIcons.location_solid),
            label: 'Nearby',
          ),
          BottomNavigationBarItem(
            key: Key('navInfo'),
            icon: Icon(CupertinoIcons.info_circle_fill),
            label: 'Info',
          ),
        ],
      ),
    );
  }
}
