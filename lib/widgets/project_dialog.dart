import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import './../models/project_provider.dart';
import './../models/project.dart';

class ProjectDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final projectsData = Provider.of<ProjectProvider>(context);
    final projects = projectsData.projects;
    return SimpleDialog(
        title: const Text('Assign task to project'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, Project(id: null, title: 'null'));
            },
            child: Text('No project'),
          ),
          for (int i = 0; i < projects.length; i++)
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context,
                    Project(id: projects[i].id, title: projects[i].title));
              },
              child: Text(projects[i].title),
            ),
        ]);
  }
}
