import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  //http get to get projects from firebase
  Future<void> fetchProjects() async {
    const url =
        'https://getitdone-fc7d7-default-rtdb.europe-west1.firebasedatabase.app/projects.json';
    try {
      http.get(url);
    } catch (error) {}
  }

  //http post to add project to firebase
  Future<void> addProject(Project project) async {
    const url =
        'https://getitdone-fc7d7-default-rtdb.europe-west1.firebasedatabase.app/projects.json';
    http.post(url,
        body: json.encode({
          'title': project.title,
        }));
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
