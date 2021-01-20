import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  static const route = '/statistics';
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Text('projects screen')));
  }
}
