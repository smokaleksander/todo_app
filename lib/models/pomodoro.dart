import 'package:flutter/foundation.dart';

class Pomodoro with ChangeNotifier {
  final String id;
  final DateTime finishedDate;
  final String taskId;
  final int length;

  Pomodoro({this.id, this.finishedDate, this.length, this.taskId});
}
