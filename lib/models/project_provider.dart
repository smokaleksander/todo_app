import 'package:flutter/material.dart';
import 'package:pomodoro_app/models/project.dart';

class ProjectProvider with ChangeNotifier {
  List<Project> _projects = [
    Project(id: 'c1', title: 'Italian'),
    Project(id: 'c2', title: 'Q uick & Easy'),
    Project(id: 'c3', title: 'Hamburgers'),
  ];

  Project findById(String id) {
    return _projects.firstWhere((project) => project.id == id);
  }

  //getter for fetching copy of list of projects
  List<Project> get projects {
    return [..._projects]; //get copy of list intead of reference
  }

  void addProject(Project project) {
    final newProject = Project(
      id: DateTime.now().toString(),
      title: project.title,
    );
    _projects.add(newProject);
    notifyListeners();
  }

  void updateProject(String id, Project updatedProject) {
    final projectIndex = _projects.indexWhere((project) => project.id == id);
    _projects[projectIndex] = updatedProject;
    notifyListeners();
  }

  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    notifyListeners();
  }
}
