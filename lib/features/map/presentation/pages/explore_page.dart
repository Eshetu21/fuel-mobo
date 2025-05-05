import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fuel_finder/features/gas_station/presentation/bloc/gas_station_bloc.dart';
import 'package:fuel_finder/features/gas_station/presentation/bloc/gas_station_event.dart';
import 'package:fuel_finder/features/gas_station/presentation/bloc/gas_station_state.dart';
import 'package:fuel_finder/features/map/presentation/bloc/geolocation_bloc.dart';
import 'package:fuel_finder/features/map/presentation/pages/search_page.dart';
import 'package:fuel_finder/features/map/presentation/widgets/custom_app_bar.dart';
import 'package:fuel_finder/features/map/presentation/widgets/explore_widgets/track_location_button.dart';
import 'package:fuel_finder/features/route/presentation/bloc/route_bloc.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_bloc.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_event.dart';
import 'package:fuel_finder/shared/show_snackbar.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/features/map/presentation/widgets/explore_widgets/gas_station_bottom_sheet.dart';
import 'package:fuel_finder/features/map/presentation/widgets/explore_widgets/station_info_card.dart';

class ExplorePage extends StatefulWidget {
  final String userId;
  const ExplorePage({super.key, required this.userId});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final MapController mapController = MapController();
  List<LatLng> _routePoints = [];
  LatLng? _selectedLocation;
  double? _distance;
  double? _duration;
  bool _showStationInfo = false;
  Map<String, dynamic>? _selectedStation;
  bool _initialZoomDone = false;
  bool _isCalculatingRoute = false;
  bool _showRouteOnMap = false;
  AnimationController? _animationController;

  final String _mapTypeUrl =
      'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=MHrVVdsKyXBzKmc1z9Oo';

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _fetchUserData();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    mapController.dispose();
    super.dispose();
  }

  void _checkLocationPermission() async {
    PermissionStatus status = await Permission.locationWhenInUse.request();

    if (status.isGranted && mounted) {
      context.read<GeolocationBloc>().add(FetchUserLocation());
    } else if (status.isDenied && mounted) {
      ShowSnackbar.show(
        context,
        "Location permission is required to access your location",
      );
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  void _centerMapOnUserLocation() async {
    final state = context.read<GeolocationBloc>().state;
    if (state is GeolocationLoaded) {
      _zoomToLocation(state.latitude, state.longitude);
      _getGasStations(state.latitude, state.longitude);
    } else {
      context.read<GeolocationBloc>().add(FetchUserLocation());
    }
  }

  void _zoomToLocation(double latitude, double longitude) {
    if (!mounted) return;

    final target = LatLng(latitude, longitude);
    final zoom = getZoomLevel(context);

    _animationController?.dispose();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    final curveAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );

    final startCenter = mapController.camera.center;
    final startZoom = mapController.camera.zoom;

    _animationController!.addListener(() {
      if (!mounted) return;
      final progress = curveAnimation.value;
      final newLat =
          startCenter.latitude +
          (target.latitude - startCenter.latitude) * progress;
      final newLng =
          startCenter.longitude +
          (target.longitude - startCenter.longitude) * progress;
      final newZoom = startZoom + (zoom - startZoom) * progress;

      mapController.move(LatLng(newLat, newLng), newZoom);
    });

    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController?.dispose();
        _animationController = null;
      }
    });

    _animationController!.forward();

    setState(() {
      _initialZoomDone = true;
    });
  }

  void _fetchUserData() {
    context.read<UserBloc>().add(GetUserByIdEvent(userId: widget.userId));
  }

  void _getGasStations(double latitude, double longitude) {
    context.read<GasStationBloc>().add(
      GetGasStationsEvent(
        latitude: latitude.toString(),
        longitude: longitude.toString(),
      ),
    );
  }

  void _getRoute(LatLng destination) {
    final state = context.read<GeolocationBloc>().state;
    if (state is GeolocationLoaded) {
      setState(() {
        _isCalculatingRoute = true;
      });
      final userLocation = LatLng(state.latitude, state.longitude);
      context.read<RouteBloc>().add(
        CalculateRoute(
          waypoints: [userLocation, destination],
          profile: 'driving',
          steps: true,
          overview: 'full',
          geometries: 'polyline',
        ),
      );
    }
  }

  void _showRoute() {
    setState(() {
      _showRouteOnMap = true;
    });
    if (_selectedLocation != null) {
      _getRoute(_selectedLocation!);
    }
  }

  void _handleStationTap(Map<String, dynamic> station) {
    final lat =
        station['latitude'] != null
            ? double.tryParse(station['latitude'].toString())
            : null;
    final lng =
        station['longitude'] != null
            ? double.tryParse(station['longitude'].toString())
            : null;

    if (lat != null && lng != null) {
      setState(() {
        _selectedStation = station;
        _selectedLocation = LatLng(lat, lng);
        _showStationInfo = true;
        _routePoints = [];
        _showRouteOnMap = false;
        _distance = null;
        _duration = null;
        _isCalculatingRoute = true;
      });
      _animatedMoveToLocation(LatLng(lat, lng));
      _getRoute(LatLng(lat, lng));
    }
  }

  void _hideStationInfo() {
    setState(() {
      _showStationInfo = false;
      _routePoints = [];
      _showRouteOnMap = false;
      _selectedLocation = null;
    });
  }

  double getZoomLevel(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1200) return 14.5;
    if (width > 800) return 14.0;
    return 13.5;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double zoomLevel = getZoomLevel(context);

    return Scaffold(
      appBar: CustomAppBar(
        userId: widget.userId,
        showUserInfo: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            icon: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          BlocListener<RouteBloc, RouteState>(
            listener: (context, state) {
              if (state is RouteLoaded) {
                setState(() {
                  _routePoints = _showRouteOnMap ? state.route.coordinates : [];
                  _distance = state.route.distance;
                  _duration = state.route.duration;
                  _isCalculatingRoute = false;
                });
              } else if (state is RouteError) {
                setState(() {
                  _isCalculatingRoute = false;
                });
                ShowSnackbar.show(context, state.message);
              }
            },
            child: _buildMap(zoomLevel),
          ),
          if (_showStationInfo && _selectedStation != null)
            Positioned(
              bottom: 120,
              right: 15,
              child: TrackLocationButton(onTap: _centerMapOnUserLocation),
            ),
          if (!(_showStationInfo && _selectedStation != null))
            Positioned(
              bottom: 50,
              right: 15,
              child: TrackLocationButton(onTap: _centerMapOnUserLocation),
            ),
          if (!(_showStationInfo && _selectedStation != null))
            Positioned(
              bottom: 120,
              right: 25,
              child: FloatingActionButton(
                backgroundColor: AppPallete.primaryColor,
                onPressed: () {
                  final state = context.read<GasStationBloc>().state;
                  if (state is GasStationSucess) {
                    _showGasStationsBottomSheet(state.gasStation ?? []);
                  }
                },
                child: const Icon(Icons.local_gas_station_rounded),
              ),
            ),
          if (_showStationInfo && _selectedStation != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: StationInfoCard(
                station: _selectedStation!,
                onClose: _hideStationInfo,
                onShowRoute: _showRoute,
                distance: _distance,
                duration: _duration,
                routePoints: _routePoints,
              ),
            ),
        ],
      ),
      bottomNavigationBar: BlocBuilder<GeolocationBloc, GeolocationState>(
        builder: (context, state) {
          final isLoading =
              state is GeolocationLoading || state is GeolocationInitial;
          return isLoading
              ? const LinearProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppPallete.primaryColor,
                ),
              )
              : const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildMap(double zoomLevel) {
    return BlocConsumer<GeolocationBloc, GeolocationState>(
      listener: (context, geoState) {
        if (geoState is GeolocationLoaded && !_initialZoomDone) {
          _zoomToLocation(geoState.latitude, geoState.longitude);
          _getGasStations(geoState.latitude, geoState.longitude);
        }
      },
      builder: (context, geoState) {
        final userLocation =
            geoState is GeolocationLoaded
                ? LatLng(geoState.latitude, geoState.longitude)
                : null;

        return BlocBuilder<GasStationBloc, GasStationState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, gasStationState) {
            final gasStationMarkers = _buildGasStationMarkers(gasStationState);

            return FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: userLocation ?? const LatLng(9.01, 38.75),
                initialZoom: zoomLevel,
                maxZoom: 18,
                minZoom: 6,
              ),
              children: [
                TileLayer(
                  urlTemplate: _mapTypeUrl,
                  userAgentPackageName: 'com.example.fuel_finder',
                ),
                if (userLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: userLocation,
                        width: 20,
                        height: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppPallete.primaryColor.withOpacity(0.2),
                            border: Border.all(
                              color: AppPallete.primaryColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: AppPallete.primaryColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ...gasStationMarkers,
                    ],
                  ),
                if (_selectedLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selectedLocation!,
                        width: 40,
                        height: 40,
                        child: const SizedBox(),
                      ),
                    ],
                  ),
                if (_showRouteOnMap && _routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _routePoints,
                        strokeWidth: 2.5,
                        color: Colors.blueAccent,
                      ),
                    ],
                  ),
              ],
            );
          },
        );
      },
    );
  }

  List<Marker> _buildGasStationMarkers(GasStationState state) {
    if (state is! GasStationSucess) return [];

    final stations = state.gasStation;
    if (stations == null) return [];

    return stations
        .map((station) {
          final stationData = station["data"] ?? station;
          final lat =
              stationData['latitude'] != null
                  ? double.tryParse(stationData['latitude'].toString())
                  : null;
          final lng =
              stationData['longitude'] != null
                  ? double.tryParse(stationData['longitude'].toString())
                  : null;

          if (lat == null || lng == null) return null;

          return Marker(
            point: LatLng(lat, lng),
            width: 40,
            height: 40,
            child: GestureDetector(
              onTap: () => _handleStationTap(station),
              child: Icon(
                Icons.local_gas_station,
                color:
                    station['suggestion'] == true
                        ? AppPallete.primaryColor
                        : AppPallete.secondaryColor,
                size: 30,
              ),
            ),
          );
        })
        .whereType<Marker>()
        .toList();
  }

  void _showGasStationsBottomSheet(List<Map<String, dynamic>> stations) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return GasStationBottomSheet(
          stations: stations,
          onStationTap: _handleStationTap,
        );
      },
    );
  }

  void _animatedMoveToLocation(LatLng target) {
    if (!mounted) return;

    final zoom = getZoomLevel(context);
    
    _animationController?.dispose();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    final curveAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );

    final startCenter = mapController.camera.center;
    final startZoom = mapController.camera.zoom;

    _animationController!.addListener(() {
      if (!mounted) return;
      final progress = curveAnimation.value;
      final newLat =
          startCenter.latitude +
          (target.latitude - startCenter.latitude) * progress;
      final newLng =
          startCenter.longitude +
          (target.longitude - startCenter.longitude) * progress;
      final newZoom = startZoom + (zoom - startZoom) * progress;

      mapController.move(LatLng(newLat, newLng), newZoom);
    });

    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController?.dispose();
        _animationController = null;
      }
    });

    _animationController!.forward();
  }

  @override
  bool get wantKeepAlive => true;
}