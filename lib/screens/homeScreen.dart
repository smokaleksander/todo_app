import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro_app/widgets/task_item.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro_app/models/task.dart';
import 'package:pomodoro_app/models/task_provider.dart';
import './task_form_screen.dart';

enum FilterOptions {
  Done,
  ToDo,
}

class HomeScreen extends StatefulWidget {
  static const route = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _showOnlyToDo = true;

  void _addNewTask(String title, DateTime date) {
    final newTs = Task(id: DateTime.now().toString(), title: title, date: date);
    setState(() {});
  }

  void showNewTaskModal(BuildContext ctx) {}

  @override
  Widget build(BuildContext context) {
    final tasksData = Provider.of<TaskProvider>(context);
    final tasks = _showOnlyToDo ? tasksData.toDoTasks : tasksData.doneTasks;
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, User'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.ToDo) {
                  _showOnlyToDo = true;
                } else {
                  _showOnlyToDo = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Show to do'),
                value: FilterOptions.ToDo,
              ),
              PopupMenuItem(
                child: Text('Show done'),
                value: FilterOptions.Done,
              )
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(TaskFormScreen.route);
        },
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, i) => TaskItem(
          id: tasks[i].id,
          title: tasks[i].title,
          date: tasks[i].date,
          projectId: tasks[i].projectId,
          isDone: tasks[i].isDone,
        ),
      ),
    );
  }
}
