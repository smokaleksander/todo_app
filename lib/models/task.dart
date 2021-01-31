import 'package:flutter/foundation.dart';

class Task with ChangeNotifier {
  final String id;
  final String title;
  final DateTime date;
  final String projectId;
  DateTime doneDate;
  bool isDone;

  Task({
    @required this.id,
    @required this.title,
    this.date,
    this.projectId,
    this.isDone = false,
    this.doneDate,
  });

  void toggleIsDone() {
    if (isDone == false) {
      isDone = !isDone;
      doneDate = DateTime.now();
    } else {
      isDone = !isDone;
      doneDate = null;
    }

    notifyListeners();
  }
}
