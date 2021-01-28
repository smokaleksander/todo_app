//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_app/models/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro_app/screens/ProjectDetailScreen.dart';
import './../screens/projectFormScreen.dart';
import './circleProgress.dart';

class ProjectItem extends StatelessWidget {
  final String id;
  final String title;
  final int doneTasks;
  final int allTasks;

  ProjectItem({this.id, this.title, this.allTasks, this.doneTasks});
  void goToProjectDetailsScreen(BuildContext ctx, String id) {
    Navigator.of(ctx).pushNamed(
      ProjectDetailScreen.route,
      arguments: id,
    );
  }

  @override
  Widget build(BuildContext context) {
    double _currProgress =
        Provider.of<TaskProvider>(context).getProjectProgress(id);
    return InkWell(
      onLongPress: () => Navigator.of(context)
          .pushNamed(ProjectFormScreen.route, arguments: id),
      onTap: () => goToProjectDetailsScreen(context, id),
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: CustomPaint(
                  foregroundPainter: CircleProgress(
                      context: context, currentProgress: _currProgress),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    width: MediaQuery.of(context).size.height * 0.15,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Center(child: Text('${_currProgress.round()}%')),
                  ),
                ),
              ),
              Text(title)
            ]),
      ),
    );
  }
}
