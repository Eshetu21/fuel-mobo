import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';

class TrackLocationButton extends StatelessWidget {
  final VoidCallback onTap;
  const TrackLocationButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppPallete.whiteColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppPallete.greyColor.withOpacity(0.4),
              blurRadius: 5.0,
              spreadRadius: 0.5,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            FontAwesomeIcons.locationCrosshairs,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

