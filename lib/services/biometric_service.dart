// lib/services/biometric_service.dart
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  // lib/services/biometric_session.dart

  static bool isUnlocked = false;

  static void unlock() => isUnlocked = true;
  static void lock() => isUnlocked = false;

  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      return canCheck && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    try {
      final can = await _auth.canCheckBiometrics;
      if (!can) return false;

      final enrolled = await _auth.getAvailableBiometrics();
      if (enrolled.isEmpty) return false;

      return await _auth.authenticate(
        localizedReason: 'Verify your identity to continue',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      print('Biometric auth error: $e');
      return false;
    }
  }
}
