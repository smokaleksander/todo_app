import 'package:flutter/material.dart';
import './../models/dummy-data.dart';
import './../widgets/project_item.dart';

class ProjectsScreen extends StatefulWidget {
  //bar for storting screen path
  static const routeName = 'projects';

  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView(
        padding: const EdgeInsets.all(15),
        children:
            //map every project from list to single item to show in grid
            DUMMY_PROJECTS
                .map((project) => ProjectItem(project.id, project.title))
                .toList(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
      ),
    );
  }
}
