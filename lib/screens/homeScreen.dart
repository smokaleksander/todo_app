import 'package:flutter/material.dart';
import 'package:pomodoro_app/models/task.dart';
import 'package:pomodoro_app/widgets/task_form.dart';
import 'package:pomodoro_app/widgets/task_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _pages = [];
  final List<Task> _userTasks = [
    Task(id: '1', title: 't1', date: DateTime.now()),
    Task(id: '2', title: 't2', date: DateTime.now()),
  ];

  void _addNewTask(String title, DateTime date) {
    final newTs = Task(id: DateTime.now().toString(), title: title, date: date);
    setState(() {
      _userTasks.add(newTs);
    });
  }

  void showNewTaskModal(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return TaskForm(_addNewTask);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Text('home screen')));
  }
}
