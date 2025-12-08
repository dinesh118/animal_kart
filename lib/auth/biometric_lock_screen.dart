import 'package:flutter/material.dart';
import 'package:animal_kart_demo2/services/biometric_service.dart';
import 'package:animal_kart_demo2/services/secure_storage_service.dart';

class BiometricLockScreen extends StatefulWidget {
  final Widget child;

  const BiometricLockScreen({super.key, required this.child});

  @override
  _BiometricLockScreenState createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends State<BiometricLockScreen>
    with WidgetsBindingObserver {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initAuth();
  }

  Future<void> _initAuth() async {
    final isEnabled = await SecureStorageService.isBiometricEnabled();

    //  Already unlocked this session → no biometric popup
    if (!isEnabled || BiometricService.isUnlocked) {
      setState(() => _isInitialized = true);
      return;
    }

    await _authenticate();
  }

  Future<void> _authenticate() async {
    if (!mounted) return;

    final success = await BiometricService.authenticate();

    if (success) {
      BiometricService.unlock(); // remember for the session
    }

    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      BiometricService.lock();
    }
    // Only ask again if app was LOCKED when backgrounded
    if (state == AppLifecycleState.resumed) {
      final isEnabled = await SecureStorageService.isBiometricEnabled();

      if (isEnabled && !BiometricService.isUnlocked && mounted) {
        setState(() => _isInitialized = false);
        await _authenticate();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  If unlocked → show main UI instantly
    if (BiometricService.isUnlocked) {
      return widget.child;
    }

    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Show biometric fallback UI only once
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _authenticate,
          child: const Text("Authenticate"),
        ),
      ),
    );
  }
}
