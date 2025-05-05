import 'package:flutter/material.dart';
import 'package:fuel_finder/features/map/presentation/widgets/bottom_nav_bar_item.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  void updateIndex(int index) {
    widget.onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(color: Colors.grey[100]),
      child: Row(
        children: List.generate(
          _bottomNavigationBarLabels.length,
          (index) => BottomNavBarItem(
            label: _bottomNavigationBarLabels[index],
            icon: _bottomNavigationBarIcons[index],
            isSelected: widget.currentIndex == index,
            onTap: () => updateIndex(index),
          ),
        ),
      ),
    );
  }
}

final List<String> _bottomNavigationBarLabels = [
  "Home",
  "Favorite",
  "Price",
  "Profile",
];

final List<IconData> _bottomNavigationBarIcons = [
  Icons.home,
  Icons.favorite,
  Icons.price_change,
  Icons.person,
];
