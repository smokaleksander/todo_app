import 'package:flutter/foundation.dart';

class Task with ChangeNotifier {
  final String id;
  String title;
  DateTime date;
  String projectId;
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
