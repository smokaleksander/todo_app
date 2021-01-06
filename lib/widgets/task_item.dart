import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  String id;
  String title;
  bool isDone;

  TaskItem(this.id, this.title, this.isDone);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(8, 16, 8, 0),
      child: Row(
        children: <Widget>[
          Container(
            child: Checkbox(
              value: isDone,
              onChanged: (bool value) {},
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontSize: 18),
              ),
            ],
          )
        ],
      ),
    );
  }
}
