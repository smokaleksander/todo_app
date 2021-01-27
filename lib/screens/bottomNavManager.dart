import 'package:flutter/material.dart';
import 'package:pomodoro_app/screens/ProjectsScreen.dart';
import 'package:pomodoro_app/screens/StatisticsScreen.dart';
import 'package:pomodoro_app/screens/homeScreen.dart';
import 'package:pomodoro_app/screens/pomodoroTimer.dart';
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
    final fab = FloatingActionButton(
      child: Icon(Icons.add),
      elevation: 5.0,
      onPressed: () {
        Navigator.of(context).pushNamed(PomodotoTimer.route);
        // Navigator.of(context).pushNamed(TaskFormScreen.route,
        //     arguments: {'taskId': null, 'projectId': null});
      },
    );
    return Scaffold(
      body: _screens[_selectedScreenIndex],
      floatingActionButton: fab,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectScreen,
        unselectedItemColor: Theme.of(context).scaffoldBackgroundColor,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedScreenIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded), label: 'Statistics'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
