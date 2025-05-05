import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/features/fuel_price/presentation/bloc/fuel_price_bloc.dart';
import 'package:fuel_finder/features/fuel_price/presentation/bloc/fuel_price_event.dart';
import 'package:fuel_finder/features/fuel_price/presentation/bloc/fuel_price_state.dart';
import 'package:fuel_finder/features/map/presentation/widgets/custom_app_bar.dart';

class PricePage extends StatefulWidget {
  const PricePage({super.key});

  @override
  State<PricePage> createState() => _PricePageState();
}

class _PricePageState extends State<PricePage> {
  @override
  void initState() {
    super.initState();
    _getFuelPrices();
  }

  void _getFuelPrices() {
    context.read<FuelPriceBloc>().add(GetFuelPricesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: CustomAppBar(title: "Fuel Prices", centerTitle: true),
      body: BlocBuilder<FuelPriceBloc, FuelPriceState>(
        builder: (context, state) {
          if (state is FuelPriceLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppPallete.primaryColor),
            );
          } else if (state is FuelPriceFailure) {
            return Center(child: _buildErrorState("Failed to get prices"));
          } else if (state is FuelPriceSucess) {
            final fuelPrices = state.fuelPrices['data'] as List;
            return _buildFuelPriceLayout(theme, isLargeScreen, fuelPrices);
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildFuelPriceLayout(
    ThemeData theme,
    bool isLargeScreen,
    List<dynamic> fuelPrices,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isLargeScreen ? 24 : 16,
            vertical: 16,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLargeScreen)
                  _buildLargeLayout(theme, fuelPrices)
                else
                  _buildMobileLayout(theme, fuelPrices),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(ThemeData theme, List<dynamic> fuelPrices) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: fuelPrices.map((fuel) => _buildFuelCard(fuel, theme)).toList(),
    );
  }

  Widget _buildLargeLayout(ThemeData theme, List<dynamic> fuelPrices) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children:
          fuelPrices
              .map(
                (fuel) =>
                    SizedBox(width: 400, child: _buildFuelCard(fuel, theme)),
              )
              .toList(),
    );
  }

  Widget _buildFuelCard(Map<String, dynamic> fuel, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_gas_station,
                  color: AppPallete.primaryColor,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fuel['fuel_type'],
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${fuel['price']} Br/L',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppPallete.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(thickness: 0.8),
            const SizedBox(height: 12),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: _buildInfoItem(
                      Icons.calendar_today,
                      'Last updated',
                      _formatDate(fuel['updated_at']),
                      theme,
                    ),
                  ),
                  const VerticalDivider(
                    thickness: 1,
                    width: 20,
                    color: Colors.grey,
                  ),
                  Flexible(
                    child: _buildInfoItem(
                      Icons.event_available,
                      'Created at',
                      _formatDate(fuel['created_at']),
                      theme,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(thickness: 0.8),
            const SizedBox(height: 12),
            _buildInfoItem(
              Icons.business,
              'Source',
              'Ministry of Mines and Petroleum',
              theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value,
    ThemeData theme,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppPallete.primaryColor, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return dateString;
    }
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
        ElevatedButton(onPressed: _getFuelPrices, child: const Text("Retry")),
      ],
    );
  }
}

