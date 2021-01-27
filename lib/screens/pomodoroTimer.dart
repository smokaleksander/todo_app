import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pomodoro_app/models/clock.dart';
import 'package:pomodoro_app/models/project_provider.dart';
import 'package:pomodoro_app/models/task.dart';
import 'package:pomodoro_app/models/task_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:intl/intl.dart';

enum TimerStatus { running, paused, stopped }

class PomodoroTimer extends StatefulWidget {
  static const route = '/timer';

  @override
  _PomodoroTimerState createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  var _timeFormatter = NumberFormat('00');
  bool _isPassedTaskLoaded = false;
  Clock clock;
  var _task =
      Task(id: null, title: '', date: null, isDone: false, projectId: null);

  @override
  void dispose() {
    _isPassedTaskLoaded = true;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final passedTaskId = ModalRoute.of(context).settings.arguments as String;
    if (passedTaskId != null && _isPassedTaskLoaded == false) {
      _isPassedTaskLoaded = true;
      _task = Provider.of<TaskProvider>(context, listen: false)
          .findById(passedTaskId);
    }
    super.didChangeDependencies();
  }

  Future<bool> _stopDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Stop this pomodoro?'),
              content: Text('Do you want to stop and save this pomodoro?'),
              actions: <Widget>[
                FlatButton(
                    child: Text('Stop and discard'),
                    onPressed: () {
                      Provider.of<ClockProvider>(context, listen: false)
                          .stopTimer();
                      Navigator.of(ctx).pop();
                    }),
                FlatButton(
                  child: Text('Stop and save'),
                  onPressed: () {
                    clock.savePomodoro();
                    Provider.of<ClockProvider>(context, listen: false)
                        .stopTimer();

                    //save this pomodoro
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final clockProvider = Provider.of<ClockProvider>(context);
    clock = clockProvider.getClock;
    clock.context = context;
    clock.taskId = _task.id;
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_down_rounded),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    iconSize: 40,
                    color: Theme.of(context).accentColor,
                  )
                ],
              ),
              if (_task.id != null)
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _task.title,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            if (_task.date != null)
                              Text(
                                DateFormat('dd/MM/yyyy').format(_task.date),
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w200),
                              ),
                            if (_task.projectId != null)
                              Text(
                                Provider.of<ProjectProvider>(context,
                                        listen: false)
                                    .findById(_task.projectId)
                                    .title
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w200),
                              )
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.cancel_rounded),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        onPressed: () {
                          clock.taskId = null;
                          _task = Task(
                              id: null,
                              title: null,
                              isDone: null,
                              projectId: null,
                              date: null);
                          setState(() {});
                        },
                      )
                    ],
                  ),
                ),
            ]),
            Container(
              child: Column(children: [
                Text(
                  '${_timeFormatter.format(clock.minutes)}:${_timeFormatter.format(clock.seconds)}',
                  style: TextStyle(fontSize: 50),
                ),
                Container(
                  margin: EdgeInsets.only(top: 14),
                  child: Text(
                    clock.isBreakTime ? 'Break time' : '',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              ]),
            ),
            if (clock.timerStatus.index == TimerStatus.stopped.index)
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.08,
                      ),
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25)),
                          color: Theme.of(context).accentColor,
                          textColor: Theme.of(context).primaryColor,
                          child: Text(
                            'Start',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w500),
                          ),
                          onPressed: () =>
                              Provider.of<ClockProvider>(context, listen: false)
                                  .startTimer(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            if (clock.timerStatus.index == TimerStatus.running.index)
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.08,
                      ),
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25)),
                          color: Theme.of(context).accentColor,
                          textColor: Theme.of(context).primaryColor,
                          child: Text(
                            'Pause',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w500),
                          ),
                          onPressed: () =>
                              Provider.of<ClockProvider>(context, listen: false)
                                  .pauseTimer(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            if (clock.timerStatus.index == TimerStatus.paused.index)
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.08,
                      ),
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25)),
                          color: Theme.of(context).accentColor,
                          textColor: Theme.of(context).primaryColor,
                          child: Text(
                            'Continue',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                          onPressed: () =>
                              Provider.of<ClockProvider>(context, listen: false)
                                  .continueTimer(),
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.08,
                        ),
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: OutlineButton(
                            textColor: Theme.of(context).accentColor,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(25)),
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor, width: 4),
                            child: Text(
                              clock.isBreakTime ? 'Skip' : 'Stop',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w500),
                            ),
                            onPressed: () => clock.isBreakTime
                                ? Provider.of<ClockProvider>(context,
                                        listen: false)
                                    .skipBreak()
                                : _stopDialog(context),
                          ),
                        ))
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
