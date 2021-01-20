import 'package:flutter/material.dart';
import './task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [
    Task(
        id: 't1',
        title: 'task1',
        projectId: 'c1',
        date: DateTime.now(),
        isDone: true),
    Task(
        id: 't2',
        title: 'task2',
        projectId: 'c1',
        date: DateTime.now(),
        isDone: false),
    Task(
      id: 't3',
      title: 'task3',
      projectId: 'c1',
      isDone: true,
    ),
    Task(
      id: 't4',
      title: 'task4',
      projectId: 'c2',
      isDone: true,
    ),
    Task(
      id: 't4',
      title: 'task5',
      projectId: 'c2',
      isDone: false,
    ),
    Task(
      id: 't6',
      title: 'task6',
      projectId: 'c3',
      isDone: false,
    ),
    Task(
      id: 't7',
      title: 'task7',
      projectId: 'c3',
      isDone: false,
    ),
    Task(
      id: 't8',
      title: 'task8',
      date: DateTime.now(),
      isDone: false,
    ),
    Task(id: 't9', title: 'task9', isDone: false),
  ];
  List<Task> toDoInProject(String projectId) {
    return _tasks
        .where((ts) => ts.projectId == projectId && ts.isDone == false)
        .toList();
  }

  List<Task> doneInProject(String projectId) {
    return _tasks
        .where((ts) => ts.projectId == projectId && ts.isDone == true)
        .toList();
  }

  List<Task> get toDoTasks {
    return _tasks.where((ts) => ts.isDone == false).toList();
  }

  List<Task> get doneTasks {
    return _tasks.where((ts) => ts.isDone == true).toList();
  }

  List<Task> findbyDate() {}
  //getter for fetching copy of list of task

  List<Task> get tasks {
    return [..._tasks]; //get copy of list intead of reference
  }

  void deleteTask(String id) {
    _tasks.removeWhere((ts) => ts.id == id);
    notifyListeners();
  }

  void changeStatus(String id) {
    (_tasks.firstWhere((ts) => ts.id == id)).toggleIsDone();
    notifyListeners();
  }
}
