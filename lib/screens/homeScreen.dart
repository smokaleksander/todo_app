import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro_app/widgets/task_item.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro_app/models/task.dart';
import 'package:pomodoro_app/models/task_provider.dart';
import './taskFormScreen.dart';

enum FilterOptions {
  Done,
  ToDo,
}

class HomeScreen extends StatefulWidget {
  static const route = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _curDate = DateTime.now();
  var _showOnlyToDo = true;
  // generate 14 days before and after today
  List<int> generateCalendarDates() {
    List<int> days = List<int>();
    for (int i = -14; i < 15; i++) {
      days.add(i);
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final List<int> _calendarDates = generateCalendarDates();
    for (int i in _calendarDates) {
      print(i);
    }
    final tasksData = Provider.of<TaskProvider>(context);
    final tasks = _showOnlyToDo ? tasksData.toDoTasks : tasksData.doneTasks;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Hi, User'),
      //   actions: <Widget>[
      //     PopupMenuButton(
      //       onSelected: (FilterOptions selectedValue) {
      //         setState(() {
      //           if (selectedValue == FilterOptions.ToDo) {
      //             _showOnlyToDo = true;
      //           } else {
      //             _showOnlyToDo = false;
      //           }
      //         });
      //       },
      //       icon: Icon(
      //         Icons.more_vert,
      //       ),
      //       itemBuilder: (_) => [
      //         PopupMenuItem(
      //           child: Text('Show to do'),
      //           value: FilterOptions.ToDo,
      //         ),
      //         PopupMenuItem(
      //           child: Text('Show done'),
      //           value: FilterOptions.Done,
      //         )
      //       ],
      //     )
      //   ],
      // ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(TaskFormScreen.route,
              arguments: {'taskId': null, 'projectId': null});
        },
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
            height: (MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.bottom -
                    MediaQuery.of(context).padding.top) *
                0.18,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (BuildContext context, int i) {
                return Container(
                  margin: EdgeInsets.only(top: 16, bottom: 8),
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).accentColor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('4',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w600)),
                      Text('January',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400)),
                      Text('Wed',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int i) {
                return SizedBox(
                  width: 15,
                );
              },
            ),
          ),
          Container(
            height: (MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.bottom -
                    MediaQuery.of(context).padding.top) *
                0.82,
            child: (tasks.isEmpty && _showOnlyToDo)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 25),
                        child: Image.asset(
                          'assets/images/no_tasks.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text('You have no tasks for today'),
                    ],
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, i) => TaskItem(
                      id: tasks[i].id,
                      title: tasks[i].title,
                      date: tasks[i].date,
                      projectId: tasks[i].projectId,
                      isDone: tasks[i].isDone,
                    ),
                  ),
          ),
        ]),
      ),
    );
  }
}
