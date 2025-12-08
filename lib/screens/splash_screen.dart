import 'package:animal_kart_demo2/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_constants.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, AppRouter.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRouter.onBoardingScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color animalKartGreen = Color(0xFF3A8F8A);

    return Scaffold(
      backgroundColor: animalKartGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo inside branded circle
            Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                color: animalKartGreen,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  AppConstants.appLogoAssert,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // App Name
            Text(
              AppConstants.kAppName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                height: 1.1,
                color: animalKartGreen,
              ),
            ),
            const SizedBox(height: 40),

            // Loader
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(animalKartGreen),
            ),
          ],
        ),
      ),
    );
  }
}
