import 'package:flutter/material.dart';
import 'package:pomodoro_app/screens/ProjectsScreen.dart';
import 'package:pomodoro_app/screens/StatisticsScreen.dart';
import 'package:pomodoro_app/screens/homeScreen.dart';
import 'package:pomodoro_app/screens/pomodoroTimer.dart';
import 'package:pomodoro_app/screens/profileScreen.dart';
import 'package:pomodoro_app/models/clock.dart';
import 'package:provider/provider.dart';

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
    final clockProvider = Provider.of<ClockProvider>(context);
    final clock = clockProvider.getClock;
    return Scaffold(
      body: _screens[_selectedScreenIndex],
      floatingActionButton: FloatingActionButton(
        child: Text(
          clock.minutes.toString(),
          style: TextStyle(fontSize: 34, height: 1),
        ),
        elevation: 5.0,
        onPressed: () {
          Navigator.of(context).pushNamed(PomodoroTimer.route);
          // Navigator.of(context).pushNamed(TaskFormScreen.route,
          //     arguments: {'taskId': null, 'projectId': null});
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.075,
          margin: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.home_filled,
                  color: _selectedScreenIndex == 0
                      ? Theme.of(context).accentColor
                      : Theme.of(context).scaffoldBackgroundColor,
                ),
                onPressed: () {
                  _selectScreen(0);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.lightbulb,
                  color: _selectedScreenIndex == 1
                      ? Theme.of(context).accentColor
                      : Theme.of(context).scaffoldBackgroundColor,
                ),
                onPressed: () {
                  _selectScreen(1);
                },
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.07),
              IconButton(
                icon: Icon(
                  Icons.bar_chart_rounded,
                  color: _selectedScreenIndex == 2
                      ? Theme.of(context).accentColor
                      : Theme.of(context).scaffoldBackgroundColor,
                ),
                onPressed: () {
                  _selectScreen(2);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: _selectedScreenIndex == 3
                      ? Theme.of(context).accentColor
                      : Theme.of(context).scaffoldBackgroundColor,
                ),
                onPressed: () {
                  _selectScreen(3);
                },
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: _selectScreen,
      //   unselectedItemColor: Theme.of(context).scaffoldBackgroundColor,
      //   selectedItemColor: Theme.of(context).accentColor,
      //   currentIndex: _selectedScreenIndex,
      //   type: BottomNavigationBarType.fixed,
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.lightbulb),
      //       label: 'Projects',
      //     ),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.bar_chart_rounded), label: 'Statistics'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      //   ],
      // ),
    );
  }
}
