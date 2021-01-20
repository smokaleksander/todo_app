import 'package:flutter/material.dart';

class Project with ChangeNotifier {
  final String id;
  final String title;

  Project({@required this.id, @required this.title});
}
