//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_app/screens/ProjectDetailScreen.dart';
import 'package:provider/provider.dart';
import './../models/project.dart';

class ProjectItem extends StatelessWidget {
  void goToProjectDetailsScreen(BuildContext ctx, String id) {
    Navigator.of(ctx).pushNamed(
      ProjectDetailScreen.route,
      arguments: id,
    );
  }

  @override
  Widget build(BuildContext context) {
    //provider
    final project = Provider.of<Project>(context);
    //
    return InkWell(
      onTap: () => goToProjectDetailsScreen(context, project.id),
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
          padding: const EdgeInsets.all(15),
          child: Text(project.title),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15))),
    );
  }
}
