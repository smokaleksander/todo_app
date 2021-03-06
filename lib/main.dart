import 'package:flutter/material.dart';
import 'package:pomodoro_app/models/clock.dart';
import 'package:pomodoro_app/models/pomodoroProvider.dart';
import 'package:pomodoro_app/models/project_provider.dart';
import 'package:pomodoro_app/models/task_provider.dart';
import 'package:pomodoro_app/providers/auth.dart';
import 'package:pomodoro_app/screens/StatisticsScreen.dart';
import 'package:pomodoro_app/screens/pomodoroTimer.dart';
import 'package:pomodoro_app/screens/profileScreen.dart';
import 'package:pomodoro_app/screens/projectFormScreen.dart';
import 'package:pomodoro_app/screens/taskFormScreen.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro_app/screens/ProjectDetailScreen.dart';
import 'package:pomodoro_app/screens/bottomNavManager.dart';
import 'package:pomodoro_app/screens/homeScreen.dart';
import 'package:pomodoro_app/screens/ProjectsScreen.dart';
import 'package:pomodoro_app/screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, TaskProvider>(
          update: (ctx, auth, previouseTaskProvider) => TaskProvider(
              auth.token,
              previouseTaskProvider == null ? [] : previouseTaskProvider.tasks,
              auth.userId),
        ),
        ChangeNotifierProxyProvider<Auth, ProjectProvider>(
          update: (ctx, auth, previousProjectProvider) => ProjectProvider(
              auth.token,
              previousProjectProvider == null
                  ? []
                  : previousProjectProvider.projects),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ClockProvider(),
        ),
        ChangeNotifierProxyProvider<Auth, PomodoroProvider>(
          update: (ctx, auth, previousPomodoroProvider) => PomodoroProvider(
              auth.token,
              previousPomodoroProvider == null
                  ? []
                  : previousPomodoroProvider.pomodoros),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.white,
            accentColor: Colors.indigo[700],
            scaffoldBackgroundColor: Colors.indigo[50],
            fontFamily: 'Raleway',
          ),
          home: auth.isAuth ? BottomNavManager() : AuthScreen(),
          routes: {
            '/bottomNavManager': (ctx) => BottomNavManager(),
            ProjectsScreen.route: (ctx) => ProjectsScreen(),
            ProjectDetailScreen.route: (ctx) => ProjectDetailScreen(),
            ProfileScreen.route: (ctx) => ProfileScreen(),
            StatisticsScreen.route: (ctx) => StatisticsScreen(),
            TaskFormScreen.route: (ctx) => TaskFormScreen(),
            ProjectFormScreen.route: (ctx) => ProjectFormScreen(),
            PomodoroTimer.route: (ctx) => PomodoroTimer(),
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (ctx) => HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}
