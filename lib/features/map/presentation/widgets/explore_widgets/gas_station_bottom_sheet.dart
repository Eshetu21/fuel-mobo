import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';

class GasStationBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> stations;
  final Function(Map<String, dynamic>) onStationTap;

  const GasStationBottomSheet({
    super.key,
    required this.stations,
    required this.onStationTap,
  });

  @override
  State<GasStationBottomSheet> createState() => _GasStationBottomSheetState();
}

class _GasStationBottomSheetState extends State<GasStationBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _allStations = [];
  List<Map<String, dynamic>> _petrolStations = [];
  List<Map<String, dynamic>> _dieselStations = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _categorizeStations();
  }

  void _categorizeStations() {
    _allStations = widget.stations;
    _petrolStations =
        widget.stations.where((station) {
          final fuels = station['available_fuel'] as List<dynamic>? ?? [];
          return fuels.any(
            (fuel) => fuel.toString().toUpperCase().contains('PETROL'),
          );
        }).toList();
    _dieselStations =
        widget.stations.where((station) {
          final fuels = station['available_fuel'] as List<dynamic>? ?? [];
          return fuels.any(
            (fuel) => fuel.toString().toUpperCase().contains('DIESEL'),
          );
        }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.55,
      child: Column(
        children: [
          const Text(
            'Nearby Gas Stations',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TabBar(
            controller: _tabController,
            labelColor: AppPallete.primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Petrol'),
              Tab(text: 'Diesel'),
            ],
          ),
          const SizedBox(height: 5),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildStationList(_allStations),
                _buildStationList(_petrolStations),
                _buildStationList(_dieselStations),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationList(List<Map<String, dynamic>> stations) {
    if (stations.isEmpty) {
      return const Center(child: Text('No stations found'));
    }

    return ListView.builder(
      itemCount: stations.length,
      itemBuilder: (context, index) {
        final station = stations[index];
        final isSuggestion = station['suggestion'] == true;
        final fuels = station['available_fuel'] as List<dynamic>? ?? [];
        final fuelsText = fuels.join(', ');

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          color: Colors.grey.shade50,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            leading: Icon(
              Icons.local_gas_station,
              color: isSuggestion ? AppPallete.primaryColor : Colors.orange,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    station['name'] ?? 'Gas Station',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                if (isSuggestion)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.info_outline, size: 12),
                      const SizedBox(width: 4),
                      const Text("Suggested", style: TextStyle(fontSize: 10)),
                    ],
                  ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (station['averageRate'] != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade300,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${station['averageRate']}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      if (fuels.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppPallete.primaryColor.withOpacity(0.1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.local_gas_station,
                                size: 14,
                                color: AppPallete.primaryColor,
                              ),
                              const SizedBox(width: 4),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.4,
                                ),
                                child: Text(
                                  fuelsText,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppPallete.primaryColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              widget.onStationTap(station);
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
