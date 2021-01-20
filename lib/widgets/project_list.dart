import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro_app/models/project_provider.dart';
import 'package:pomodoro_app/widgets/project_item.dart';

class ProjectList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //provider implementation
    final projectsData = Provider.of<ProjectProvider>(context);
    final projects = projectsData.projects;

    //actual widget ui build
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: projects[index],
        child: ProjectItem(
            // taskItemId: tasks[index].id,
            // taskItemTitle: tasks[index].title,
            // taskItemIsDone: tasks[index].isDone,
            ),
      ),
    );
  }
}
