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
    for (int i = 0; i < _pomodoros.length; i++) {
      print(_pomodoros[i].id);
      print(_pomodoros[i].finishedDate);
      print(_pomodoros[i].taskId);
      print(_pomodoros[i].length);
    }
    notifyListeners();
  }
}
