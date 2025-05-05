import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/core/utils/token_services.dart';
import 'package:fuel_finder/features/auth/presentation/pages/login_page.dart';
import 'package:fuel_finder/features/onboarding/widgets/onboarding_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  TokenService? tokenService;
  bool onLastPage = false;

  @override
  void initState() {
    super.initState();
    _initTokenService();
  }

  Future<void> _initTokenService() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tokenService = TokenService(prefs);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 600;

    return Scaffold(
      backgroundColor: AppPallete.primaryColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() {
                      onLastPage = index == 2;
                    });
                  },
                  children: [
                    _buildOnboardingPage(
                      context,
                      'assets/images/onboarding_one.png',
                      "Find Nearby Fuel Stations",
                      "Discover fuel stations near you using only your phone",
                      isSmallScreen,
                    ),
                    _buildOnboardingPage(
                      context,
                      'assets/images/onboarding_two.png',
                      "View Fuel Availability",
                      "Check real-time fuel availability before you go to the station",
                      isSmallScreen,
                    ),
                    _buildOnboardingPage(
                      context,
                      'assets/images/onboarding_three.png',
                      "View Official Fuel Prices",
                      "Stay informed with up-to-date fuel prices across all stations",
                      isSmallScreen,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: isSmallScreen ? 10 : 20,
                ),
                child: Column(
                  children: [
                    SmoothPageIndicator(
                      controller: _controller,
                      count: 3,
                      effect: ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: Colors.white,
                        dotColor: Colors.white.withOpacity(0.5),
                        expansionFactor: 3,
                        spacing: 8,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 15 : 25),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder:
                          (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                      child:
                          onLastPage
                              ? OnboardingButton(
                                key: const ValueKey('get_started'),
                                text: "Get Started",
                                isPrimary: true,
                                width: double.infinity,
                                onPressed: () async {
                                //await tokenService?.setSeenOnboarding(true);
                                  print("Sucessfully saved");
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                },
                              )
                              : Row(
                                key: const ValueKey('navigation_buttons'),
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  OnboardingButton(
                                    text: "Skip",
                                    isPrimary: false,
                                    isShade: true,
                                    width: screenWidth * 0.4,
                                    onPressed: () {
                                      _controller.jumpToPage(2);
                                    },
                                  ),
                                  OnboardingButton(
                                    text: "Continue",
                                    width: screenWidth * 0.4,
                                    isPrimary: true,
                                    onPressed: () {
                                      _controller.nextPage(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                  ),
                                ],
                              ),
                    ),
                    SizedBox(height: isSmallScreen ? 10 : 20),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(
    BuildContext context,
    String imagePath,
    String title,
    String description,
    bool isSmallScreen,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.55,
          width: double.infinity,
          child: Center(
            child: Image.asset(
              imagePath,
              height: screenHeight * 0.45,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 24 : 30,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: isSmallScreen ? 16 : 18,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

