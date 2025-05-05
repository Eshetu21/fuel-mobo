import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/features/feedback/presentation/pages/station_detail_page.dart';

class StationInfoCard extends StatelessWidget {
  final Map<String, dynamic> station;
  final VoidCallback onClose;
  final VoidCallback onShowRoute;
  final double? distance;
  final double? duration;
  final List<LatLng> routePoints;

  const StationInfoCard({
    super.key,
    required this.station,
    required this.onClose,
    required this.onShowRoute,
    this.distance,
    this.duration,
    required this.routePoints,
  });

  String _formatDistance(double? meters) {
    if (meters == null) return 'Loading...';
    if (meters < 1000) return '${meters.toStringAsFixed(0)} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  String _formatDuration(double? seconds) {
    if (seconds == null) return 'Loading...';
    if (seconds < 60) return '${seconds.toStringAsFixed(0)} sec';
    if (seconds < 3600) return '${(seconds / 60).toStringAsFixed(0)} min';
    return '${(seconds / 3600).toStringAsFixed(1)} hr';
  }

  @override
  Widget build(BuildContext context) {
    final stationData = station['data'] ?? station;
    final name = stationData['name'] ?? 'Gas Station';
    final fuels =
        (stationData['available_fuel'] as List<dynamic>?)?.join(', ') ??
        'No fuel info';

    if (routePoints.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: const Icon(Icons.close, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on, color: Colors.blue, size: 18),
                    const SizedBox(width: 4),
                    Text(_formatDistance(distance)),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.access_time_filled,
                      color: Colors.blue,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(_formatDuration(duration)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.local_gas_station,
                  color: Colors.orange,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text('$fuels available'),
              ],
            ),
          ],
        ),
      );
    }

    final averageRate = stationData['averageRate']?.toString() ?? 'Not rated';
    final isSuggested = stationData['suggestion'] == true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: const Icon(Icons.close, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(averageRate),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, color: Colors.blue, size: 18),
                  const SizedBox(width: 4),
                  Text(_formatDistance(distance)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.access_time_filled,
                    color: Colors.blue,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(_formatDuration(duration)),
                ],
              ),
              if (isSuggested)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Suggested'),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              "This suggestion is made based on the station's ratings and user votes",
                              style: TextStyle(color: Colors.white),
                            ),
                            duration: const Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.info_outline,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.local_gas_station,
                color: Colors.orange,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text('$fuels available'),
            ],
          ),
          const Divider(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onTap: onShowRoute,
                  child: Row(
                    children: [
                      Icon(
                        Icons.route,
                        color: AppPallete.primaryColor,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Show route',
                        style: TextStyle(
                          color: AppPallete.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[400],
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => StationDetailPage(
                            station: station,
                            distance: distance,
                            duration: duration,
                          ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.black87,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'More details',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[400],
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
