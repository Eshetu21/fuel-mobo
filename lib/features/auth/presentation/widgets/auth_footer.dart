import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';

Widget authFooterText(
  BuildContext context,
  String text,
  String ?actionText,
  Widget navigateTo,
  bool popCurrentPage,
) {
  final theme = Theme.of(context);
  return GestureDetector(
    onTap: () {
      if (popCurrentPage) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => navigateTo),
        );
      }
    },
    child: RichText(
      text: TextSpan(
        text: text,
        style: theme.textTheme.bodyMedium,
        children: [
          TextSpan(
            text: actionText,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppPallete.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

