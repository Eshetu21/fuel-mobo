import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:fuel_finder/features/favorite/presentation/bloc/favorite_event.dart';
import 'package:fuel_finder/features/favorite/presentation/bloc/favorite_state.dart';
import 'package:fuel_finder/features/map/presentation/widgets/custom_app_bar.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  void _fetchFavorites() {
    context.read<FavoriteBloc>().add(GetFavoritesEvent());
  }

  Future<void> fetchFavorites() async {
    context.read<FavoriteBloc>().add(GetFavoritesEvent());
  }

  Future<void> _showRemoveConfirmationDialog(
    BuildContext context,
    String stationId,
    String stationName,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Favorite'),
          content: Text(
            'Are you sure you want to remove $stationName from favorites?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Remove'),
              onPressed: () {
                Navigator.of(context).pop();
                _removeFavorite(stationId);
              },
            ),
          ],
        );
      },
    );
  }

  void _removeFavorite(String stationId) {
    context.read<FavoriteBloc>().add(RemoveFavoriteEvent(stationId: stationId));
    Future.delayed(const Duration(milliseconds: 500), () {
      _fetchFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Favorites", centerTitle: true),
      body: RefreshIndicator(
        onRefresh: fetchFavorites,
        child: BlocConsumer<FavoriteBloc, FavoriteState>(
          listener: (context, state) {
            if (state is FavoriteSucess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is FavoriteFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is FetchFavoriteSucess) {
              final favorites = state.favorites["data"];
              if (favorites == null || favorites.isEmpty) {
                return _buildEmptyFavorite(context);
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final item = favorites[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(
                        Icons.local_gas_station,
                        color: AppPallete.primaryColor,
                      ),
                      title: Text(item['en_name'] ?? 'Gas Station'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['address'] ?? 'Address'),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item['averageRate']?.toString() ?? '0',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.local_gas_station,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatFuelTypes(item['available_fuel']),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          _showRemoveConfirmationDialog(
                            context,
                            item['station_id'],
                            item['en_name'] ?? 'this station',
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (state is FavoriteLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FavoriteFailure) {
              return _buildErrorState(state.error);
            }
            return _buildEmptyFavorite(context);
          },
        ),
      ),
    );
  }

  String _formatFuelTypes(List<dynamic>? fuelTypes) {
    if (fuelTypes == null || fuelTypes.isEmpty) return 'No fuel';
    return fuelTypes.join(', ');
  }

  Widget _buildEmptyFavorite(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/no_fav.png"),
          Text(
            "No Favorites yet",
            style: theme.textTheme.headlineLarge?.copyWith(
              color: AppPallete.primaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              "Tap the heart icon on a gas station to favorite it",
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error, size: 80, color: Colors.red),
        const SizedBox(height: 16),
        Text(
          "Error loading favorites",
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          error,
          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: _fetchFavorites, child: const Text("Retry")),
      ],
    );
  }
}

