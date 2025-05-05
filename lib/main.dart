import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fuel_finder/core/injection_container.dart';
import 'package:fuel_finder/core/themes/app_theme.dart';
import 'package:fuel_finder/core/utils/token_services.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fuel_finder/features/auth/presentation/pages/login_page.dart';
import 'package:fuel_finder/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:fuel_finder/features/feedback/presentation/bloc/feed_back_bloc.dart';
import 'package:fuel_finder/features/fuel_price/presentation/bloc/fuel_price_bloc.dart';
import 'package:fuel_finder/features/gas_station/presentation/bloc/gas_station_bloc.dart';
import 'package:fuel_finder/features/map/presentation/bloc/geolocation_bloc.dart';
import 'package:fuel_finder/features/map/presentation/pages/home_page.dart';
import 'package:fuel_finder/features/onboarding/onboarding_page.dart';
import 'package:fuel_finder/features/route/presentation/bloc/route_bloc.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final prefs = await SharedPreferences.getInstance();
  final tokenService = TokenService(prefs);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Permission.locationWhenInUse.request();
  setUpDependencies();

  runApp(MainApp(tokenService: tokenService));
}

class MainApp extends StatelessWidget {
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
  final TokenService tokenService;

  const MainApp({super.key, required this.tokenService});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<UserBloc>()),
        BlocProvider(create: (_) => sl<GeolocationBloc>()),
        BlocProvider(create: (_) => sl<RouteBloc>()),
        BlocProvider(create: (_) => sl<GasStationBloc>()),
        BlocProvider(create: (_) => sl<FavoriteBloc>()),
        BlocProvider(create: (_) => sl<FuelPriceBloc>()),
        BlocProvider(create: (_) => sl<FeedBackBloc>()),
      ],
      child: MaterialApp(
        title: 'Fuel Finder',
        theme: AppTheme.lightThemeMode,
        darkTheme: AppTheme.darkThemeMode,
        themeMode: ThemeMode.system,
        home: FutureBuilder<String?>(
          future: tokenService.getToken(),
          builder: (context, snapshot) {
            final hasToken = snapshot.data != null;
            final seenOnboarding = tokenService.getSeenOnboarding() ?? false;
            final userId = tokenService.getUserId();

            if (!seenOnboarding) {
              return const OnboardingPage();
            }

            if (hasToken) {
              if (userId != null) {
                return HomePage(userId: userId);
              } else {
                return const LoginPage();
              }
            } else {
              return const LoginPage();
            }
          },
        ),
        navigatorObservers: [routeObserver],
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
