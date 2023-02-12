import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_hero/src/screens/screens.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  static Page<void> page() => const MaterialPage<void>(
        child: MainView(),
      );

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentIndex = 0;

  final screen = [
    const HomePage(),
    const ProfilePage(),
    // To be added
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 222, 222, 222),
      body: IndexedStack(
        index: currentIndex,
        children: screen,
      ),
      bottomNavigationBar: CupertinoTabBar(
        onTap: (index) {
          setState(() => currentIndex = index);
        },
        currentIndex: currentIndex,
        backgroundColor: Colors.white,
        activeColor: const Color(0xFF0F5ABC),
        inactiveColor: const Color(0xFF7C7C7C),
        height: 50,
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          )
        ],
      ),
    );
  }
}
