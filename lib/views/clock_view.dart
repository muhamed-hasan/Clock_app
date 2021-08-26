import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ClockView extends StatefulWidget {
  // const ClockView({Key? key}) : super(key: key);

  @override
  _ClockViewState createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  Timer? timer;
  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('clock view widget');

    return FittedBox(
      child: Container(
        width: 250,
        height: 250,
        child: Transform.rotate(
          angle: -pi / 2,
          child: CustomPaint(
            painter: ClockPainter(),
          ),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final dateTime = DateTime.now();
  @override
  void paint(Canvas canvas, Size size) {
    //
    final centerX = size.width / 2;
    final centerY = size.width / 2;
    final center = Offset(centerX, centerY);
    final radius = min(centerX, centerY);

    final fillBrush = Paint()..color = Color(0xFF444974);
    final outLineBrush = Paint()
      ..color = Color(0xFFEAECff)
      ..strokeWidth = 13
      ..style = PaintingStyle.stroke;
    final centerBrush = Paint()..color = Color(0xFFEAECff);

    final secHand = Paint()
      ..color = Colors.orange.shade300
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;
    final outerDash = Paint()
      ..color = Colors.grey.shade300
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final minHand = Paint()
      ..strokeCap = StrokeCap.round
      ..shader = RadialGradient(colors: [Colors.lightBlue, Colors.pink])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;
    final hoursHand = Paint()
      ..strokeCap = StrokeCap.round
      ..shader = RadialGradient(colors: [Color(0xFF748ef6), Color(0xff77ddff)])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 13
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius - 40, fillBrush);
    canvas.drawCircle(center, radius - 40, outLineBrush);
////////////////////!
    final hourHandX = centerX +
        60 * cos((dateTime.hour * 30 + dateTime.minute * .5) * pi / 180);
    final hourHandY = centerX +
        60 * sin((dateTime.hour * 30 + dateTime.minute * .5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hoursHand);

    ///
    final minHandX = centerX + 70 * cos(dateTime.minute * 6 * pi / 180);
    final minHandY = centerX + 70 * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHand);

    ///
    final secHandX = centerX + 70 * cos(dateTime.second * 6 * pi / 180);
    final secHandY = centerX + 70 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHand);
    canvas.drawCircle(center, 16, centerBrush);

    final outerCircleRadius = radius;
    final innerCircleRadius = radius - 14;
    for (var i = 0; i < 360; i += 12) {
      final x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      final y1 = centerX + outerCircleRadius * sin(i * pi / 180);
      final x2 = centerX + innerCircleRadius * cos(i * pi / 180);
      final y2 = centerX + innerCircleRadius * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), outerDash);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
