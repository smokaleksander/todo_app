import 'package:flutter/material.dart';
import 'package:pomodoro_app/models/clock.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:intl/intl.dart';

enum TimerStatus { running, paused, stopped }

class PomodotoTimer extends StatefulWidget {
  static const route = '/timer';
  @override
  _PomodotoTimerState createState() => _PomodotoTimerState();
}

class _PomodotoTimerState extends State<PomodotoTimer> {
  var _timeFormatter = NumberFormat('00');
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
    final clock = clockProvider.getClock;
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
            Container(
              child: Text(
                '${_timeFormatter.format(clock.minutes)}:${_timeFormatter.format(clock.seconds)}',
                style: TextStyle(fontSize: 50),
              ),
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
                        vertical: MediaQuery.of(context).size.height * 0.09,
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
                              'Stop',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w500),
                            ),
                            onPressed: () => _stopDialog(context),
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
