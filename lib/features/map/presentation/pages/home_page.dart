import 'package:flutter/material.dart';
import 'package:fuel_finder/features/map/presentation/pages/explore_page.dart';
import 'package:fuel_finder/features/favorite/presentation/pages/favorite_page.dart';
import 'package:fuel_finder/features/fuel_price/presentation/pages/fuel_price_page.dart';
import 'package:fuel_finder/features/map/presentation/pages/profile_page.dart';
import 'package:fuel_finder/features/map/presentation/widgets/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  final String userId;
  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      ExplorePage(
        key: ValueKey('explore_${widget.userId}'),
        userId: widget.userId,
      ),
      const FavoritePage(),
      const PricePage(),
      ProfilePage(userId: widget.userId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

