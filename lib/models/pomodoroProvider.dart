import 'package:flutter/material.dart';
import 'package:pomodoro_app/models/pomodoro.dart';
import './pomodoro.dart';

class PomodoroProvider with ChangeNotifier {
  List<Pomodoro> _pomodoros = List();

  void addPomodoro(Pomodoro passedPomo) {
    final newPom = Pomodoro(
        id: DateTime.now().toString(),
        finishedDate: DateTime.now(),
        taskId: passedPomo.taskId,
        length: passedPomo.length);

    _pomodoros.add(newPom);
    notifyListeners();
  }

  //return pomodoro numbers and all duration
  Map getStatsForTask(String taskId) {
    int pomoNum = 0;
    Duration length = Duration(seconds: 0);
    for (int i = 0; i < _pomodoros.length; i++) {
      if (_pomodoros[i].taskId == taskId) {
        pomoNum++;
        length = length + _pomodoros[i].length;
      }
    }
    return {'pomoNum': pomoNum, 'length': length};
  }
}
