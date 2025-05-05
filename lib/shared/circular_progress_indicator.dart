import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  final double size;
  final double strokeWidth;

  const AppLoader({
    super.key,
    this.size = 24.0,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: const AlwaysStoppedAnimation<Color>(
          Colors.white,
        ),
      ),
    );
  }
}

