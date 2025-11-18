import 'package:flutter/material.dart';
import 'package:animal_kart_demo2/screens/splash_screen.dart';
import 'package:animal_kart_demo2/screens/login_screen.dart';
import 'package:animal_kart_demo2/screens/otp_screen.dart';
import 'package:animal_kart_demo2/screens/profile_form_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String profileForm = '/profile-form';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case otp:
        return MaterialPageRoute(builder: (_) => const OtpScreen());
      case profileForm:
        final phoneNumber = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => ProfileFormScreen(mobileNumber: phoneNumber),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
