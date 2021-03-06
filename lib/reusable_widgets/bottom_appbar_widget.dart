import 'package:flutter/material.dart';

Widget bottomAppbarWidget() {
  return Container(
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(30), topLeft: Radius.circular(30)),
      color: Colors.deepOrange,
    ),
    child: BottomNavigationBar(
      selectedItemColor: Colors.lightBlueAccent,
      unselectedItemColor: Colors.white,
      elevation: 0.0,

      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          backgroundColor: Colors.transparent,
          icon: Icon(Icons.home),
          label: '',
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
