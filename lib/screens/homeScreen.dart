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
  List<DateTime> _calendarDates;
  List<Task> tasks = List<Task>();
  var _dayListItemSize = 45.0;
  int _daylistCurrIndex = 14;
  //var _curDate = DateTime.now();
  var _showOnlyToDo = true;
  ScrollController _dayListScrollController;
  var _isInit = true;
  var _isLoading = false;
  // generate 14 days before and after today

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      print('fetching');
      Provider.of<TaskProvider>(context).fetchTasks().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
    final tasksData = Provider.of<TaskProvider>(context);
    tasks = tasksData.tasks;
    // tasks = _showOnlyToDo
    //     ? tasksData.findbyDateAndToDo(_calendarDates[_daylistCurrIndex])
    //     : tasksData.findbyDateAndDone(_calendarDates[_daylistCurrIndex]);
    super.didChangeDependencies();
  }

  List<DateTime> generateCalendarDates() {
    List<DateTime> days = List<DateTime>();
    for (int i = -14; i < 8; i++) {
      days.add(DateTime.now().add(Duration(days: i)));
    }
    return days;
  }

  @override
  void initState() {
    _dayListScrollController = ScrollController(
        initialScrollOffset: 14 * (_dayListItemSize + 8.0) - 8.0);
    _calendarDates = generateCalendarDates();
    super.initState();
  }

  //function to move to next day in calendar dates list
  _nextDay(itemSize) {
    _calendarDates
        .add(DateTime.now().add(Duration(days: _daylistCurrIndex + 1)));
    setState(() {
      _dayListScrollController.animateTo(
          _dayListScrollController.offset + itemSize + 8,
          curve: Curves.linear,
          duration: Duration(milliseconds: 200));
      _daylistCurrIndex++;
    });
  }

  //function to move to prev day in calendar dates list
  _prevDay(itemSize) {
    setState(() {
      _dayListScrollController.animateTo(
          _dayListScrollController.offset - itemSize - 8,
          curve: Curves.linear,
          duration: Duration(milliseconds: 200));
      if (_daylistCurrIndex > 0) {
        _daylistCurrIndex--;
      }
    });
  }

  List<Task> _filterDone(List<Task> list) {
    return list.where((ts) => ts.isDone == true).toList();
  }

  List<Task> _filterTodo(List<Task> list) {
    return list.where((ts) => ts.isDone == false).toList();
  }

  @override
  Widget build(BuildContext context) {
    var _dayListItemSize = 45.0;
    // final tasksData = Provider.of<TaskProvider>(context)
    //     .findbyDate(_calendarDates[_daylistCurrIndex]);
    // final tasks =
    //     _showOnlyToDo ? _filterTodo(tasksData) : _filterDone(tasksData);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: (MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.bottom -
                            MediaQuery.of(context).padding.top) *
                        0.02,
                  ),
                  height: (MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.bottom -
                          MediaQuery.of(context).padding.top) *
                      0.08,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          DateFormat("EEEE, MMM d")
                              .format(DateTime.now())
                              .toString(),
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_rounded),
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          _prevDay(_dayListItemSize);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios_rounded),
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          _nextDay(_dayListItemSize);
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: (MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.bottom -
                            MediaQuery.of(context).padding.top) *
                        0.01,
                  ),
                  height: (MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.bottom -
                          MediaQuery.of(context).padding.top) *
                      0.08,
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _dayListScrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: _calendarDates.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Container(
                        width: _dayListItemSize,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: (i != _daylistCurrIndex)
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).accentColor),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(DateFormat('d').format(_calendarDates[i]),
                                style: TextStyle(
                                    color: (i != _daylistCurrIndex)
                                        ? Theme.of(context).accentColor
                                        : Theme.of(context).primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600)),
                            Text(DateFormat('MMMM').format(_calendarDates[i]),
                                style: TextStyle(
                                    color: (i != _daylistCurrIndex)
                                        ? Theme.of(context).accentColor
                                        : Theme.of(context).primaryColor,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w400)),
                            Text(DateFormat('EEE').format(_calendarDates[i]),
                                style: TextStyle(
                                    color: (i != _daylistCurrIndex)
                                        ? Theme.of(context).accentColor
                                        : Theme.of(context).primaryColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600))
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int i) {
                      return SizedBox(
                        width: 8,
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: (MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.bottom -
                            MediaQuery.of(context).padding.top) *
                        0.02,
                  ),
                  height: (MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.bottom -
                          MediaQuery.of(context).padding.top) *
                      0.08,
                  child: Row(
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          Text(
                            'Your tasks',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                          PopupMenuButton(
                            onSelected: (FilterOptions selectedValue) {
                              setState(() {
                                if (selectedValue == FilterOptions.ToDo) {
                                  _showOnlyToDo = true;
                                } else if (selectedValue ==
                                    FilterOptions.Done) {
                                  _showOnlyToDo = false;
                                }
                              });
                            },
                            icon: Icon(
                              Icons.more_vert,
                              color: Theme.of(context).accentColor,
                            ),
                            itemBuilder: (_) => [
                              PopupMenuItem(
                                child: Text('Show to do'),
                                value: FilterOptions.ToDo,
                              ),
                              PopupMenuItem(
                                child: Text('Show done'),
                                value: FilterOptions.Done,
                              )
                            ],
                          ),
                        ],
                      )),
                      IconButton(
                        icon: Icon(
                          Icons.add_rounded,
                        ),
                        iconSize: 32,
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          Navigator.of(context).pushNamed(TaskFormScreen.route,
                              arguments: {'taskId': null, 'projectId': null});
                        },
                      )
                    ],
                  ),
                ),
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          Provider.of<TaskProvider>(context, listen: false)
                              .fetchTasks();
                        },
                        child: Container(
                          height: (MediaQuery.of(context).size.height -
                                  MediaQuery.of(context).padding.bottom -
                                  MediaQuery.of(context).padding.top) *
                              0.82,
                          child: (tasks.isEmpty && _showOnlyToDo)
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                      ),
              ]),
        ),
      ),
    );
  }
}
