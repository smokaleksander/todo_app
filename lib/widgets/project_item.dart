//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_app/screens/ProjectDetailScreen.dart';
import 'package:provider/provider.dart';
import './../screens/projectFormScreen.dart';
import './../models/project.dart';

class ProjectItem extends StatelessWidget {
  final String id;
  final String title;

  ProjectItem({this.id, this.title});
  void goToProjectDetailsScreen(BuildContext ctx, String id) {
    Navigator.of(ctx).pushNamed(
      ProjectDetailScreen.route,
      arguments: id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () => Navigator.of(context)
          .pushNamed(ProjectFormScreen.route, arguments: id),
      onTap: () => goToProjectDetailsScreen(context, id),
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
          padding: const EdgeInsets.all(15),
          child: Text(title),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15))),
    );
  }
}
