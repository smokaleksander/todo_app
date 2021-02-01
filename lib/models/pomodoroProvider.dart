import 'package:flutter/material.dart';
import 'package:pomodoro_app/models/httpException.dart';
import 'dart:convert';
import 'package:pomodoro_app/models/pomodoro.dart';
import 'package:http/http.dart' as http;
import './pomodoro.dart';

class PomodoroProvider with ChangeNotifier {
  List<Pomodoro> _pomodoros = List();

  Future<void> fetchPomodoros() async {
    const url =
        'https://getitdone-fc7d7-default-rtdb.europe-west1.firebasedatabase.app/pomodoros.json';
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<Pomodoro> loadedPomodoros = [];
      if (data != null) {
        data.forEach((pomoId, pomoData) {
          loadedPomodoros.add(Pomodoro(
              id: pomoId,
              finishedDate: DateTime.parse(pomoData['finishedDate']),
              taskId: pomoData['taskId'] == null ? null : pomoData['taskId'],
              length: pomoData['length']));
        });
      }
      _pomodoros = loadedPomodoros;
      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException('Loading pomodoros failed. Please, try again later');
    }
  }

  Future<void> addPomodoro(Pomodoro passedPomo) async {
    const url =
        'https://getitdone-fc7d7-default-rtdb.europe-west1.firebasedatabase.app/pomodoros.json';

    try {
      final response = await http.post(url,
          body: json.encode({
            'finishedDate': DateTime.now().toIso8601String(),
            'taskId': passedPomo.taskId,
            'length': passedPomo.length.toString()
          }));
      final newPom = Pomodoro(
          id: json.decode(response.body)['name'],
          finishedDate: passedPomo.finishedDate,
          taskId: passedPomo.taskId,
          length: passedPomo.length);

      _pomodoros.add(newPom);
      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException('Pomodoro saving failed');
    }
  }

  //return pomodoro numbers and all duration
  Map getStatsForTask(String taskId) {
    int pomoNum = 0;
    int length = 0;
    for (int i = 0; i < _pomodoros.length; i++) {
      if (_pomodoros[i].taskId == taskId) {
        pomoNum++;
        length = length + _pomodoros[i].length;
      }
    }
    return {'pomoNum': pomoNum, 'length': length};
  }

  //parse helper method for duration
  Duration parseDuration(String input, {String separator = ':'}) {
    final parts = input.split(separator).map((t) => t.trim()).toList();

    int days;
    int hours;
    int minutes;
    int seconds;
    int milliseconds;
    int microseconds;

    for (String part in parts) {
      final match = RegExp(r'^(\d+)(d|h|m|s|ms|us])$').matchAsPrefix(part);
      if (match == null) throw FormatException('Invalid duration format');

      int value = int.parse(match.group(1));
      String unit = match.group(2);

      switch (unit) {
        case 'd':
          if (days != null) {
            throw FormatException('Days specified multiple times');
          }
          days = value;
          break;
        case 'h':
          if (hours != null) {
            throw FormatException('Days specified multiple times');
          }
          hours = value;
          break;
        case 'm':
          if (minutes != null) {
            throw FormatException('Days specified multiple times');
          }
          minutes = value;
          break;
        case 's':
          if (seconds != null) {
            throw FormatException('Days specified multiple times');
          }
          seconds = value;
          break;
        case 'ms':
          if (milliseconds != null) {
            throw FormatException('Days specified multiple times');
          }
          milliseconds = value;
          break;
        case 'us':
          if (microseconds != null) {
            throw FormatException('Days specified multiple times');
          }
          microseconds = value;
          break;
        default:
          throw FormatException('Invalid duration unit $unit');
      }
    }

    return Duration(
        days: days ?? 0,
        hours: hours ?? 0,
        minutes: minutes ?? 0,
        seconds: seconds ?? 0,
        milliseconds: milliseconds ?? 0,
        microseconds: microseconds ?? 0);
  }
}
