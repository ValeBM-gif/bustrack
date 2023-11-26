import 'package:bustrackk/constants.dart';
import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = kPrimaryColor;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.55);
    path.quadraticBezierTo(
        size.width *.25, size.height *.62, size.width * .5, size.height * 0.54);
    path.quadraticBezierTo(
        size.width *.75, size.height *.45, size.width, size.height * 0.52);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CurvePainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = kSecondaryColor;
    paint.style = PaintingStyle.fill; // Change this to fill


    var path = Path();

    path.moveTo(0, size.height * 0.57);
    path.quadraticBezierTo(
        size.width *.25, size.height *.67, size.width * .55, size.height * 0.555);
    path.quadraticBezierTo(
        size.width *.80, size.height *.47, size.width, size.height * 0.53);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}