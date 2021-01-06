import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_app/screens/ProjectDetailScreen.dart';
import 'package:pomodoro_app/screens/homeScreen.dart';
import 'package:pomodoro_app/screens/ProjectsScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.indigo[700],
          canvasColor: Colors.indigo[50],
          fontFamily: 'Raleway',
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => ProjectsScreen(),
          ProjectDetailScreen.route: (ctx) => ProjectDetailScreen(),
        });
  }
}
