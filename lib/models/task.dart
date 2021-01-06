import 'package:flutter/foundation.dart';

class Task {
  final String id;
  String title;
  DateTime date;
  String projectId;
  bool isDone = false;

  Task({
    @required this.id,
    @required this.title,
    this.date,
    this.projectId,
    bool isDone,
  });
}
