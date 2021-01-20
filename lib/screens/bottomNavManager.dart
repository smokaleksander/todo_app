import 'package:flutter/material.dart';
import 'package:pomodoro_app/screens/ProjectsScreen.dart';
import 'package:pomodoro_app/screens/StatisticsScreen.dart';
import 'package:pomodoro_app/screens/homeScreen.dart';
import 'package:pomodoro_app/screens/profileScreen.dart';

class BottomNavManager extends StatefulWidget {
  @override
  _BottomNavManagerState createState() => _BottomNavManagerState();
}

class _BottomNavManagerState extends State<BottomNavManager> {
  final List<Widget> _screens = [
    HomeScreen(),
    ProjectsScreen(),
    StatisticsScreen(),
    ProfileScreen(),
  ];
  int _selectedScreenIndex = 0;
  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectScreen,
        unselectedItemColor: Theme.of(context).scaffoldBackgroundColor,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedScreenIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb), label: 'Projects'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
