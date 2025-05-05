import 'package:flutter/material.dart';

class ShowProgressIndicator extends StatelessWidget {
  final double size;

  const ShowProgressIndicator({
    super.key,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        value: size / 2,
      ),
    );
  }
}

