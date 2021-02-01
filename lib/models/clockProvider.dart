import 'package:flutter/material.dart';
import './clock.dart';

class ClockProvider with ChangeNotifier {
  Clock clock = Clock();

  Clock get getClock {
    return clock;
  }
}
