import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro_app/models/task.dart';

class TaskList extends StatefulWidget {
  final List<Task> tasks;

  TaskList(this.tasks);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return Card(
            margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: <Widget>[
                Container(
                  child: Checkbox(
                    value: widget.tasks[index].isDone,
                    onChanged: (bool value) {
                      setState(() {
                        widget.tasks[index].isDone = value;
                      });
                    },
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.tasks[index].title,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                )
              ],
            ),
          );
        },
        itemCount: widget.tasks.length,
      ),
    );
  }
}
