import 'package:flutter/material.dart';
import 'package:pomodoro_app/models/project_provider.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro_app/models/task_provider.dart';
import 'package:pomodoro_app/widgets/task_item.dart';

enum FilterOptions {
  Done,
  ToDo,
}

class ProjectDetailScreen extends StatefulWidget {
  //variable for storing path
  static const route = '/project-details';

  @override
  _ProjectDetailScreenState createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  var _showOnlyToDo = true;
  @override
  Widget build(BuildContext context) {
    //project id passed when screen detail is pushed to show the correct project
    final passedProjectId = ModalRoute.of(context).settings.arguments as String;
    // get the correct project data by its id
    final project =
        Provider.of<ProjectProvider>(context).findById(passedProjectId);
    // actual ui build
    final tasksData = Provider.of<TaskProvider>(context);
    final tasks = _showOnlyToDo
        ? tasksData.toDoInProject(passedProjectId)
        : tasksData.doneInProject(passedProjectId);
    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
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
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text('project description'),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, i) => TaskItem(
                id: tasks[i].id,
                title: tasks[i].title,
                date: tasks[i].date,
                projectId: tasks[i].projectId,
                isDone: tasks[i].isDone,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
