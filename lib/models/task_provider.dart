import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pomodoro_app/models/httpException.dart';

import './task.dart';
import 'package:http/http.dart' as http;

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [
    // Task(
    //     id: 't1',
    //     title: 'task1',
    //     projectId: 'c1',
    //     date: DateTime.now(),
    //     isDone: true),
    // Task(
    //     id: 't2',
    //     title: 'task2',
    //     projectId: 'c1',
    //     date: DateTime.now(),
    //     isDone: false),
    // Task(
    //   id: 't3',
    //   title: 'task3',
    //   projectId: 'c1',
    //   isDone: true,
    // ),
    // Task(
    //   id: 't4',
    //   title: 'task4',
    //   projectId: 'c2',
    //   isDone: true,
    // ),
    // Task(
    //   id: 't5',
    //   title: 'task5',
    //   projectId: 'c2',
    //   isDone: false,
    // ),
    // Task(
    //   id: 't6',
    //   title: 'task6',
    //   projectId: 'c3',
    //   isDone: false,
    // ),
    // Task(
    //   id: 't7',
    //   title: 'task7',
    //   projectId: 'c3',
    //   isDone: false,
    // ),
    // Task(
    //   id: 't8',
    //   title: 'task8',
    //   date: DateTime.now(),
    //   isDone: false,
    // ),
    // Task(id: 't9', title: 'task9', isDone: false),
  ];
  List<Task> get tasks {
    return [..._tasks];
  }

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

  double getProjectProgress(String projectId) {
    double done = 0;
    double todo = 0;
    for (int i = 0; i < _tasks.length; i++) {
      if (_tasks[i].projectId == projectId) {
        todo++;
        if (_tasks[i].isDone == true) {
          done++;
        }
      }
    }
    if (todo == 0) {
      return 0;
    }
    return (done / todo * 100);
  }

  Future<void> changeStatus(String id) async {
    var taskIndex = _tasks.indexWhere((ts) => ts.id == id);
    _tasks[taskIndex].toggleIsDone();
    notifyListeners();
    final url =
        'https://getitdone-fc7d7-default-rtdb.europe-west1.firebasedatabase.app/tasks/$id.json';
    //(_tasks.firstWhere((ts) => ts.id == id)).toggleIsDone();
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isDone': _tasks[taskIndex].isDone,
          'doneDate': _tasks[taskIndex].doneDate != null
              ? _tasks[taskIndex].doneDate.toIso8601String()
              : null,
        }),
      );
      if (response.statusCode >= 400) {
        _tasks[taskIndex].toggleIsDone();
        notifyListeners();
      }
    } catch (error) {
      print(error);
      _tasks[taskIndex].toggleIsDone();
      notifyListeners();
    }
  }

  Future<void> fetchTasks() async {
    const url =
        'https://getitdone-fc7d7-default-rtdb.europe-west1.firebasedatabase.app/tasks.json';
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<Task> loadedTasks = [];
      if (data != null) {
        data.forEach((taskId, taskData) {
          loadedTasks.add(Task(
              id: taskId,
              title: taskData['title'],
              isDone: taskData['isDone'],
              date: taskData['date'] == null
                  ? null
                  : DateTime.parse(taskData['date']),
              projectId: taskData['projectId'],
              doneDate: taskData['doneDate'] == null
                  ? null
                  : DateTime.parse(taskData['doneDate'])));
        });
      }
      _tasks = loadedTasks;

      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException('fetch failed');
    }
  }

  Future<void> addTask(Task task) async {
    const url =
        'https://getitdone-fc7d7-default-rtdb.europe-west1.firebasedatabase.app/tasks.json';
    try {
      //http post
      final response = await http.post(url,
          body: json.encode({
            'title': task.title,
            'date': task.date != null ? task.date.toIso8601String() : null,
            'projectId': task.projectId,
            'isDone': task.isDone,
            'doneDate':
                task.doneDate != null ? task.doneDate.toIso8601String() : null
          }));

      final newTask = Task(
          id: json.decode(response.body)['name'],
          title: task.title,
          date: task.date,
          isDone: task.isDone,
          projectId: task.projectId);
      _tasks.add(newTask);

      notifyListeners();
    } catch (error) {
      throw HttpException('Task creating failed. Please, try again later');
    }
  }

  Future<void> updateTask(String id, Task updatedTask) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    final url =
        'https://getitdone-fc7d7-default-rtdb.europe-west1.firebasedatabase.app/tasks/$id.json';
    try {
      await http.patch(url,
          body: json.encode({
            'title': updatedTask.title,
            'date': updatedTask.date == null
                ? null
                : updatedTask.date.toIso8601String(),
            'projectId': updatedTask.projectId,
            'isDone': updatedTask.isDone,
            'doneDate':
                updatedTask.doneDate == null ? null : updatedTask.doneDate
          }));
    } catch (error) {
      print(error);
      throw HttpException('Task edit failed, try again later');
    }
    _tasks[taskIndex] = updatedTask;
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    final url =
        'https://getitdone-fc7d7-default-rtdb.europe-west1.firebasedatabase.app/tasks/$id.json';
    final existingTaskIndex = _tasks.indexWhere((ts) => ts.id == id);
    var existingTask = _tasks[existingTaskIndex];
    _tasks.removeAt(existingTaskIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _tasks.insert(existingTaskIndex, existingTask);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingTask = null;
  }

  Future<void> deleteTasksWithProjectId(String projectId) async {
    for (var i = 0; i < _tasks.length; i++) {
      if (_tasks[i].projectId == projectId) {
        final url =
            'https://getitdone-fc7d7-default-rtdb.europe-west1.firebasedatabase.app/tasks/${_tasks[i].id}.json';
        var existingTask = _tasks[i];
        _tasks.removeAt(i);
        notifyListeners();
        final response = await http.delete(url);
        if (response.statusCode >= 400) {
          _tasks.insert(i, existingTask);
          notifyListeners();
          throw HttpException('Could not delete product');
        }
        existingTask = null;
      }
    }
  }

  Future<void> setTasksProjectIdToNull(String projectId) async {
    for (var i = 0; i < _tasks.length; i++) {
      if (_tasks[i].projectId == projectId) {
        var deletedProjectId = _tasks[i].projectId;
        final url =
            'https://getitdone-fc7d7-default-rtdb.europe-west1.firebasedatabase.app/tasks/${_tasks[i].id}.json';
        try {
          var response =
              await http.patch(url, body: json.encode({'projectId': null}));
          if (response.statusCode >= 400) {
            _tasks[i] = Task(
                id: _tasks[i].id,
                title: _tasks[i].title,
                isDone: _tasks[i].isDone,
                doneDate: _tasks[i].doneDate,
                projectId: deletedProjectId);
            notifyListeners();
          }
        } catch (error) {
          print(error);
          throw HttpException(
              'Projects`s tasks editing failed, try again later');
        }
      }
    }
    notifyListeners();
  }
}
