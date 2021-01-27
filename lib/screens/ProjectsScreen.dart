import 'package:flutter/material.dart';
import 'package:pomodoro_app/widgets/project_item.dart';
import './../models/project_provider.dart';
import 'package:provider/provider.dart';
import './projectFormScreen.dart';

class ProjectsScreen extends StatefulWidget {
  //bar for storting screen path
  static const route = '/projects';

  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  @override
  Widget build(BuildContext context) {
    final projectsData = Provider.of<ProjectProvider>(context);
    final projects = projectsData.projects;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Projects'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: GridView.builder(
          itemCount: projects.length,
          itemBuilder: (context, i) => ProjectItem(
              id: projects[i].id,
              title: projects[i].title,
              allTasks: 10,
              doneTasks: 5),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 2.3 / 2.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.of(context).pushNamed(ProjectFormScreen.route);
      //   },
      // ),
    );
  }
}
