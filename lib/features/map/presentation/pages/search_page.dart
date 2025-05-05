import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/features/map/presentation/widgets/search_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPallete.primaryColor,
        titleSpacing: 0,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: SearchWidget(
            controller: _searchController,
            autoFocus: true,
            onCancelTap: () {
              _searchController.clear();
              setState(() {});
            },
            onSubmitted: (value) {},
            onChange: (value) {
              setState(() {});
            },
          ),
        ),
      ),
      body: const Column(children: [
        ],
      ),
    );
  }
}

