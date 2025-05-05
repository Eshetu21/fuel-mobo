import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';

class OnboardingButton extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onPressed;
  final double width;
  final bool? isShade;

  const OnboardingButton({
    super.key,
    required this.text,
    required this.isPrimary,
    required this.onPressed,
    required this.width,
    this.isShade,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle primaryStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: AppPallete.primaryColor,
      elevation: 0,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );

    final ButtonStyle secondaryStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.white.withOpacity(0.2),
      foregroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withOpacity(0.2)),
      ),
      textStyle: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );

    final ButtonStyle? buttonStyle =
        isShade == true
            ? secondaryStyle
            : isPrimary
            ? primaryStyle
            : secondaryStyle;

    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

