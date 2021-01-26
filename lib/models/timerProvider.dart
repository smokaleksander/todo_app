import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';

enum TimerStatus { none, running, paused, stopped }

class TimerProvider with ChangeNotifier {
  int _seconds = 0;
  int _minutes = 25;
  Timer _timer;
  var _timeFormatter = NumberFormat('00');
  TimerStatus _timerStatus = TimerStatus.stopped;

  void _startTimer() {
    _timerStatus = TimerStatus.running;
    if (_timer != null) {
      //if timer is runnig
      _timer.cancel();
    }
    // if (_minutes > 0) {
    //   _seconds = (_minutes * 60) + _seconds;
    // }
    // if (_seconds > 60) {
    //   _minutes = (_seconds / 60).floor();
    //   _seconds -= (_minutes * 60);
    // }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        _seconds--;
      } else {
        if (_minutes > 0) {
          _seconds = 59;
          _minutes--;
        } else {
          //timer finished
          _timer.cancel();
        }
      }
    });
  }

  void _stopTimer() {
    _timerStatus = TimerStatus.stopped;
    _timer.cancel();
    _seconds = 0;
    _minutes = 25;
    setState(() {});
  }

  void _pauseTimer() {
    _timerStatus = TimerStatus.paused;
    _timer.cancel();
    setState(() {});
  }

  void _continueTimer() {
    _minutes = _minutes;
    _seconds = _seconds;
    _startTimer();
    setState(() {});
  }
}
