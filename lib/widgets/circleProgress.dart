import 'package:flutter/material.dart';
import 'dart:math';

class CircleProgress extends CustomPainter {
  double currentProgress;
  BuildContext context;
  CircleProgress({this.currentProgress, this.context});
  @override
  void paint(Canvas canvas, Size size) {
    //base cirlce
    Paint outerCircle = Paint()
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..color = Theme.of(context).scaffoldBackgroundColor;

    Paint completeArc = Paint()
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = Theme.of(context).accentColor;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) - 7;
    //drawing main outer circle
    canvas.drawCircle(center, radius, outerCircle);
    //
    double angle = 2 * pi * (currentProgress / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
