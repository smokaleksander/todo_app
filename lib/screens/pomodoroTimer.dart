import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

enum TimerStatus { none, running, paused, stopped }

class PomodotoTimer extends StatefulWidget {
  static const route = '/timer';
  double _seconds = 0;
  double _minutes = 25;
  @override
  _PomodotoTimerState createState() => _PomodotoTimerState();
}

class _PomodotoTimerState extends State<PomodotoTimer> {
  int _seconds = 0;
  int _minutes = 25;
  Timer _timer;
  var _timeFormatter = NumberFormat('00');
  TimerStatus _timerStatus = TimerStatus.stopped;

  void _startTimer() {
    _timerStatus = TimerStatus.running;
    if (_timer != null) {
      //if timer is runnig
      _timer.cancel();
    }
    // if (_minutes > 0) {
    //   _seconds = (_minutes * 60) + _seconds;
    // }
    // if (_seconds > 60) {
    //   _minutes = (_seconds / 60).floor();
    //   _seconds -= (_minutes * 60);
    // }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          if (_minutes > 0) {
            _seconds = 59;
            _minutes--;
          } else {
            //timer finished
            _timer.cancel();
          }
        }
      });
    });
  }

  void _stopTimer() {
    _timerStatus = TimerStatus.stopped;
    _timer.cancel();
    _seconds = 0;
    _minutes = 25;
    setState(() {});
  }

  void _pauseTimer() {
    _timerStatus = TimerStatus.paused;
    _timer.cancel();
    setState(() {});
  }

  void _continueTimer() {
    _minutes = _minutes;
    _seconds = _seconds;
    _startTimer();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
              '${_timeFormatter.format(_minutes)}:${_timeFormatter.format(_seconds)}',
              style: TextStyle(fontSize: 50),
            )),
            if (_timerStatus == TimerStatus.stopped)
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
                          onPressed: () => _startTimer(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            if (_timerStatus == TimerStatus.running)
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
                          onPressed: () => _pauseTimer(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            if (_timerStatus == TimerStatus.paused)
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
                          onPressed: () => _continueTimer(),
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
                          onPressed: () => _stopTimer(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
