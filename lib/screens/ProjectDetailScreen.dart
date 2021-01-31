import 'package:flutter/material.dart';
import 'package:pomodoro_app/models/project_provider.dart';
import 'package:pomodoro_app/screens/taskFormScreen.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro_app/models/task_provider.dart';
import 'package:pomodoro_app/widgets/task_item.dart';
import './projectFormScreen.dart';

enum _popUpMenuOptions {
  Done,
  ToDo,
  Edit,
  Delete,
}

class ProjectDetailScreen extends StatefulWidget {
  //variable for storing path
  static const route = '/project-details';

  @override
  _ProjectDetailScreenState createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  var _deleteOptionTriggered = false;
  var _showOnlyToDo = true;

  void _deleteProjectWithTasks(String id) {
    Provider.of<TaskProvider>(context, listen: false)
        .deleteTasksWithProjectId(id);
    Provider.of<ProjectProvider>(context, listen: false).deleteProject(id);
  }

  void _deleteProjectWithoutTasks(String id) {
    Provider.of<TaskProvider>(context, listen: false)
        .setTasksProjectIdToNull(id);
    Provider.of<ProjectProvider>(context, listen: false).deleteProject(id);
  }

  Future<bool> _deleteDialog(BuildContext context, String projectId) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Delete all tasks in project?'),
              content: Text(
                  'Do you want to delete all tasks in project? If no, tasks will still with exists with no project assigned'),
              actions: <Widget>[
                FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      _deleteProjectWithoutTasks(projectId);
                      Navigator.of(ctx).pop();
                      Navigator.of(ctx).pop();
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Project deleted!"),
                        duration: Duration(seconds: 2),
                        action: SnackBarAction(
                          label: "UNDO",
                          onPressed: () {},
                        ),
                      ));
                    }),
                FlatButton(
                  child: Text('yes'),
                  onPressed: () {
                    _deleteProjectWithTasks(projectId);
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    //project id passed when screen detail is pushed to show the correct project
    final passedProjectId = ModalRoute.of(context).settings.arguments as String;
    // get the correct project data by its id
    var project;
    if (!_deleteOptionTriggered) {
      project = Provider.of<ProjectProvider>(context).findById(passedProjectId);
    }
    // actual ui build
    final tasksData = Provider.of<TaskProvider>(context);
    final tasks = _showOnlyToDo
        ? tasksData.toDoInProject(passedProjectId)
        : tasksData.doneInProject(passedProjectId);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(project.title),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (_popUpMenuOptions selectedValue) {
              setState(() {
                if (selectedValue == _popUpMenuOptions.ToDo) {
                  _showOnlyToDo = true;
                } else if (selectedValue == _popUpMenuOptions.Done) {
                  _showOnlyToDo = false;
                } else if (selectedValue == _popUpMenuOptions.Edit) {
                  Navigator.of(context).pushNamed(
                    ProjectFormScreen.route,
                    arguments: project.id,
                  );
                } else if (selectedValue == _popUpMenuOptions.Delete) {
                  //_deleteOptionTriggered = true;
                  _deleteDialog(context, project.id);
                  //_deleteOptionTriggered = false;
                  // .then((onValue) {
                  //   //_deleteOptionTriggered = true;
                  //   if (onValue) {
                  //     _deleteProjectWithTasks(project.id);
                  //   } else if (!onValue) {
                  //     Navigator.of(context).pop();
                  //     //_deleteProjectWithoutTasks(project.id);
                  //   }
                  // });
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).accentColor,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Show to do'),
                value: _popUpMenuOptions.ToDo,
              ),
              PopupMenuItem(
                child: Text('Show done'),
                value: _popUpMenuOptions.Done,
              ),
              PopupMenuItem(
                child: Text('Edit Project'),
                value: _popUpMenuOptions.Edit,
              ),
              PopupMenuItem(
                child: Text('Delete project'),
                value: _popUpMenuOptions.Delete,
              )
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(TaskFormScreen.route,
              arguments: {'taskId': null, 'projectId': project.id});
        },
      ),
      body: Column(
        children: <Widget>[
          // Card(
          //   margin: EdgeInsets.all(15),
          //   child: Padding(
          //     padding: EdgeInsets.all(8),
          //     child: Text('project description'),
          //   ),
          // ),
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
