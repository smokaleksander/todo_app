import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro_app/models/task_provider.dart';
import 'package:pomodoro_app/models/project_provider.dart';
import 'package:pomodoro_app/screens/pomodoroTimer.dart';
import 'package:provider/provider.dart';
import './../screens/taskFormScreen.dart';

class TaskItem extends StatelessWidget {
  final String id;
  final String title;
  final DateTime date;
  final bool isDone;
  String projectId;

  TaskItem({this.title, this.date, this.isDone, this.projectId, this.id});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<TaskProvider>(context, listen: false).deleteTask(id);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('Do you want to delete this task?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                    )
                  ],
                ));
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 20,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
      ),
      child: InkWell(
        onLongPress: () {
          Navigator.of(context).pushNamed(PomodoroTimer.route, arguments: id);
        },
        onTap: () {
          Navigator.of(context).pushNamed(TaskFormScreen.route,
              arguments: {'taskId': id, 'projectId': null});
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
          margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    if (date != null)
                      Text(
                        DateFormat('dd/MM/yyyy').format(date),
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w200),
                      ),
                    if (projectId != null)
                      Text(
                        Provider.of<ProjectProvider>(context, listen: false)
                            .findById(projectId)
                            .title
                            .toString(),
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w200),
                      )
                  ],
                ),
              ),
              IconButton(
                icon: Icon(isDone
                    ? Icons.check_circle_rounded
                    : Icons.check_circle_outline_rounded),
                color: isDone
                    ? Theme.of(context).accentColor
                    : Theme.of(context).scaffoldBackgroundColor,
                onPressed: () {
                  Provider.of<TaskProvider>(context, listen: false)
                      .changeStatus(id);
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: isDone
                        ? Text(title + " still nedd to be done")
                        : Text(title + " completed!"),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        Provider.of<TaskProvider>(context, listen: false)
                            .changeStatus(id);
                      },
                    ),
                  ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
