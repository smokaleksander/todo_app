import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_app/models/project_provider.dart';
import 'package:pomodoro_app/models/task_provider.dart';
import 'package:pomodoro_app/screens/StatisticsScreen.dart';
import 'package:pomodoro_app/screens/profileScreen.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro_app/screens/ProjectDetailScreen.dart';
import 'package:pomodoro_app/screens/bottomNavManager.dart';
import 'package:pomodoro_app/screens/homeScreen.dart';
import 'package:pomodoro_app/screens/ProjectsScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => TaskProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ProjectProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: Colors.indigo[700],
          scaffoldBackgroundColor: Colors.indigo[50],
          fontFamily: 'Raleway',
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => BottomNavManager(),
          ProjectsScreen.route: (ctx) => ProjectsScreen(),
          ProjectDetailScreen.route: (ctx) => ProjectDetailScreen(),
          ProfileScreen.route: (ctx) => ProfileScreen(),
          StatisticsScreen.route: (ctx) => StatisticsScreen()
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (ctx) => HomeScreen(),
          );
        },
      ),
    );
  }
}
