import 'package:flutter/foundation.dart';

class Task with ChangeNotifier {
  final String id;
  final String title;
  final DateTime date;
  final String projectId;
  bool isDone;

  Task({
    @required this.id,
    @required this.title,
    this.date,
    this.projectId,
    this.isDone = false,
  });

  void toggleIsDone() {
    isDone = !isDone;
    notifyListeners();
  }
}
