import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/project_list.dart';
import 'package:pomodoro_app/models/project_provider.dart';
import 'package:pomodoro_app/models/task_provider.dart';

class ProjectsScreen extends StatefulWidget {
  //bar for storting screen path
  static const route = '/projects';

  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ProjectList());
  }
}
