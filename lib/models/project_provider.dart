import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pomodoro_app/models/httpException.dart';
import 'package:pomodoro_app/models/project.dart';

class ProjectProvider with ChangeNotifier {
  final String authToken;
  List<Project> _projects = [
    // Project(id: 'c1', title: 'Italian'),
    // Project(id: 'c2', title: 'Q uick & Easy'),
    // Project(id: 'c3', title: 'Hamburgers'),
  ];

  ProjectProvider(this.authToken, this._projects);
  Project findById(String id) {
    return _projects.firstWhere((project) => project.id == id);
  }

  //getter for fetching copy of list of projects
  List<Project> get projects {
    return [..._projects]; //get copy of list intead of reference
  }

  //http get to get projects from firebase
  Future<void> fetchProjects() async {
    final url =
        'https://getitdone-fc7d7-default-rtdb.europe-west1.firebasedatabase.app/projects.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<Project> loadedProjects = [];
      if (data != null) {
        data.forEach((projectId, projectData) {
          loadedProjects
              .add(Project(id: projectId, title: projectData['title']));
        });
      }
      _projects = loadedProjects;
      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException('Loading projects failed. Please, try again later');
    }
  }

  //http post to add project to firebase
  Future<void> addProject(Project project) async {
    final url =
        'https://getitdone-fc7d7-default-rtdb.europe-west1.firebasedatabase.app/projects.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': project.title,
          }));
      final newProject =
          Project(id: json.decode(response.body)['name'], title: project.title);
      _projects.add(newProject);
      notifyListeners();
    } catch (error) {
      print('error:');
      print(error);
      throw HttpException('Project creating failed. Please, try again later');
    }
  }

  Future<void> updateProject(String id, Project updatedProject) async {
    final projectIndex = _projects.indexWhere((project) => project.id == id);
    final url =
        'https://getitdone-fc7d7-default-rtdb.europe-west1.firebasedatabase.app/projects/$id.json?auth=$authToken';

    try {
      await http.patch(url, body: json.encode({'title': updatedProject.title}));
    } catch (error) {
      print(error);
      throw HttpException('Project edit failed. Please, try again later');
    }
    _projects[projectIndex] = updatedProject;
    notifyListeners();
  }

  Future<void> deleteProject(String id) async {
    final url =
        'https://getitdone-fc7d7-default-rtdb.europe-west1.firebasedatabase.app/projects/$id.json?auth=$authToken';
    final exisitingProjectIndex =
        _projects.indexWhere((project) => project.id == id);
    var existingProject = _projects[exisitingProjectIndex];
    _projects.removeAt(exisitingProjectIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _projects.insert(exisitingProjectIndex, existingProject);
      notifyListeners();
      throw HttpException('Could not delete project');
    }
    existingProject = null;
  }
}
