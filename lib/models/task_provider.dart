import 'package:flutter/material.dart';
import 'package:pomodoro_app/models/project.dart';
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
      id: 't5',
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

  Task findById(id) {
    return _tasks.firstWhere((ts) => ts.id == id);
  }

  List<Task> findbyDate(DateTime date) {
    List<Task> returnList = List<Task>();
    for (int i = 0; i < _tasks.length; i++) {
      if (_tasks[i].date != null) {
        if (_tasks[i].date.year == date.year &&
            _tasks[i].date.month == date.month &&
            _tasks[i].date.day == date.day) {
          returnList.add(_tasks[i]);
        }
      }
    }
    return returnList;
  }

  List<Task> findbyDateAndDone(DateTime date) {
    List<Task> returnList = List<Task>();
    for (int i = 0; i < _tasks.length; i++) {
      if (_tasks[i].date != null) {
        if (_tasks[i].date.year == date.year &&
            _tasks[i].date.month == date.month &&
            _tasks[i].date.day == date.day &&
            _tasks[i].isDone == true) {
          returnList.add(_tasks[i]);
        }
      }
    }
    return returnList;
  }

  List<Task> findbyDateAndToDo(DateTime date) {
    List<Task> returnList = List<Task>();
    for (int i = 0; i < _tasks.length; i++) {
      if (_tasks[i].date != null) {
        if (_tasks[i].date.year == date.year &&
            _tasks[i].date.month == date.month &&
            _tasks[i].date.day == date.day &&
            _tasks[i].isDone == false) {
          returnList.add(_tasks[i]);
        }
      }
    }
    return returnList;
  }
  //getter for fetching copy of list of task

  void changeStatus(String id) {
    (_tasks.firstWhere((ts) => ts.id == id)).toggleIsDone();
    notifyListeners();
  }

  void addTask(Task task) {
    final newTask = Task(
        id: DateTime.now().toString(),
        title: task.title,
        date: task.date,
        isDone: task.isDone,
        projectId: task.projectId);
    _tasks.add(newTask);

    notifyListeners();
  }

  void updateTask(String id, Task updatedTask) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    _tasks[taskIndex] = updatedTask;
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((ts) => ts.id == id);
    notifyListeners();
  }

  void deleteTasksWithProjectId(String projectId) {
    _tasks.removeWhere((ts) => ts.projectId == projectId);
    notifyListeners();
  }

  void setTasksProjectIdToNull(String projectId) {
    for (var i = 0; i < _tasks.length; i++) {
      if (_tasks[i].projectId == projectId) {
        Task oldtask = _tasks[i];
        _tasks[i] = Task(
            projectId: null,
            id: oldtask.id,
            title: oldtask.title,
            date: oldtask.date,
            isDone: oldtask.isDone);
      }
    }
    notifyListeners();
  }
}
