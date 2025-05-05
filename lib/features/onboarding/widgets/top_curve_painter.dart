import 'package:flutter/material.dart';

class TopCurvePainter extends CustomPainter {
  final Color color;

  TopCurvePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
      size.width / 2,
      size.height * 1,
      size.width,
      size.height * 0.75,
    );
    path.lineTo(size.width, 0);
    path.close();
    //canvas.drawShadow(path, Colors.black, 8.0, true);
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

