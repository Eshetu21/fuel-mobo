import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';

class BottomNavBarItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Function onTap;
  const BottomNavBarItem({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Column(
          children: [
            AnimatedContainer(
              width: isSelected ? 80 : 30,
              height: 35,
              duration: Duration(milliseconds: 50),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFFE7E7E7) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? AppPallete.primaryColor : Colors.black54,
              ),
            ),
            SizedBox(width: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppPallete.primaryColor : Colors.black54,
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
