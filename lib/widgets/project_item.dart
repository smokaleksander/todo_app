//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './../screens/ProjectDetailScreen.dart';

class ProjectItem extends StatelessWidget {
  //specify data we need as parameter for single project item
  final String title;
  final String id;

  ProjectItem(this.id, this.title);

  void goToProjectDetailsScreen(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(ProjectDetailScreen.route, arguments: {
      'id': id,
      'title': title,
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => goToProjectDetailsScreen(context),
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
