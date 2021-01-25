import 'package:flutter/material.dart';
import 'dart:async';

class PomodotoTimer extends StatefulWidget {
  static const route = '/timer';
  @override
  _PomodotoTimerState createState() => _PomodotoTimerState();
}

class _PomodotoTimerState extends State<PomodotoTimer> {
  int _seconds = 0;
  int _minutes = 0;
  Timer _timer;
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
                  onPressed: () {},
                  iconSize: 40,
                  color: Theme.of(context).accentColor,
                )
              ],
            ),
            Container(
                child: Text(
              '25:00',
              style: TextStyle(fontSize: 50),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.08,
                  ),
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).primaryColor,
                        child: Text(
                          'Start',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w500),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
