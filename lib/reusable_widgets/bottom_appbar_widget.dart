import 'package:flutter/material.dart';
import 'package:project_bind/utils/color_utils.dart';

Widget bottomAppbarWidget() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      color: primaryThemeColor(),
    ),
    child: BottomNavigationBar(
      selectedItemColor: primaryTextColor(),
      unselectedItemColor: secondaryTextColor(),
      elevation: 0.0,

      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          backgroundColor: Colors.transparent,
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: '',
        ),
      ],
      // currentIndex: _selectedIndex,
      // selectedItemColor: Colors.amber[800],
      // onTap: _onItemTapped,
    ),
  );
}
