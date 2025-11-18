
import 'package:animal_kart_demo2/providers/auth_provider.dart';
import 'package:animal_kart_demo2/screens/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Login",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),

              const SizedBox(height: 14),
              const Text("Enter your phone number",
                  style: TextStyle(fontSize: 16, color: Colors.grey)),

              const SizedBox(height: 30),

              /// Phone Input
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  prefixText: "+91 ",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  errorText: auth.error.isEmpty ? null : auth.error,
                ),
                maxLength: 10,
              ),

              const SizedBox(height: 20),

              /// Generate OTP Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref
                        .read(authProvider.notifier)
                        .sendOtp(phoneController.text.trim());

                    if (ref.read(authProvider).otpSent) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OtpScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14))),
                  child: const Text(
                    "Generate OTP",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
