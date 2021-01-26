import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';

enum TimerStatus { running, paused, stopped }

class Clock {
  int seconds = 0;
  int minutes = 25;
  Timer timer;
  TimerStatus timerStatus = TimerStatus.stopped;
}

class ClockProvider with ChangeNotifier {
  Clock clock = Clock();
  var _timeFormatter = NumberFormat('00');

  Clock get getClock {
    return clock;
  }

  void startTimer() {
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
        }
      }
      notifyListeners();
    });
  }

  void stopTimer() {
    clock.timerStatus = TimerStatus.stopped;
    clock.timer.cancel();
    clock.seconds = 0;
    clock.minutes = 25;
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
}
