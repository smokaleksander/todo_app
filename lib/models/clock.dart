import 'package:flutter/material.dart';
import 'package:pomodoro_app/models/pomodoro.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:pomodoro_app/models/pomodoroProvider.dart';

enum TimerStatus { running, paused, stopped }

class Clock {
  int pomodoroLength = 1;
  int breakLength = 5;
  int seconds = 0;
  int minutes = 0;
  bool isBreakTime = false;
  Timer timer;
  TimerStatus timerStatus = TimerStatus.stopped;
  String taskId;
  BuildContext context;
  Clock() {
    minutes = pomodoroLength;
  }

  void savePomodoro() {
    Pomodoro newPomo = Pomodoro(
        id: DateTime.now().toString(),
        finishedDate: DateTime.now(),
        taskId: taskId,
        length: Duration(
            seconds: (pomodoroLength * 60) - (minutes * 60) - seconds));
    print(newPomo.taskId);
    print(newPomo.length);
    Provider.of<PomodoroProvider>(context, listen: false).addPomodoro(newPomo);
  }
}

class ClockProvider with ChangeNotifier {
  Clock clock = Clock();

  Clock get getClock {
    return clock;
  }

  void startTimer() {
    if (clock.timerStatus != TimerStatus.paused && clock.isBreakTime == false) {
      clock.minutes = clock.pomodoroLength;
    }
    clock.timerStatus = TimerStatus.running;
    if (clock.timer != null) {
      //if timer is runnig
      clock.timer.cancel();
    }
    // if (_minutes > 0) {
    //   _seconds = (_minutes * 60) + _seconds;
    // }
    // if (_seconds > 60) {
    //   _minutes = (_seconds / 60).floor();
    //   _seconds -= (_minutes * 60);
    // }

    clock.timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (clock.seconds > 0) {
        clock.seconds--;
      } else {
        if (clock.minutes > 0) {
          clock.seconds = 59;
          clock.minutes--;
        } else {
          //timer finished
          clock.timer.cancel();
          //create and save pomodoro
          clock.savePomodoro();
          //start a break
          clock.minutes = clock.breakLength;
          clock.isBreakTime = !clock.isBreakTime;
          startTimer();
        }
      }
      notifyListeners();
    });
  }

  void stopTimer() {
    clock.timerStatus = TimerStatus.stopped;
    clock.timer.cancel();
    clock.seconds = 0;
    clock.minutes = clock.pomodoroLength;
    notifyListeners();
  }

  void pauseTimer() {
    clock.timerStatus = TimerStatus.paused;
    clock.timer.cancel();
    notifyListeners();
  }

  void continueTimer() {
    clock.minutes = clock.minutes;
    clock.seconds = clock.seconds;
    startTimer();
    notifyListeners();
  }

  void skipBreak() {
    clock.isBreakTime = !clock.isBreakTime;
    clock.seconds = 0;
    clock.minutes = clock.pomodoroLength;
    startTimer();
  }
}
