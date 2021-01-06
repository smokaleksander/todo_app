import 'package:flutter/material.dart';

class ProjectDetailScreen extends StatelessWidget {
  //variable for storing path
  static const route = 'project-details';

  @override
  Widget build(BuildContext context) {
    //args passed when screen detail is pushed to show the correct project
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final passedProjectId = routeArgs['id'];
    final passedProjectTitle = routeArgs['title'];

    // actual ui build
    return Scaffold(
      body: Center(
        child: Text(passedProjectTitle),
      ),
    );
  }
}
