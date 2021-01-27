import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Pomodoro with ChangeNotifier {
  final String id;
  final DateTime finishedDate;
  final String taskId;
  final Duration length;

  Pomodoro({this.id, this.finishedDate, this.length, this.taskId});
}
