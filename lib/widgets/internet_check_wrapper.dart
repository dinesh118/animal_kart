import 'package:animal_kart_demo2/theme/app_theme.dart';
import 'package:animal_kart_demo2/utils/connectivity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InternetCheckWrapper extends ConsumerWidget {
  final Widget child;
  final bool showSnackbar;
  final bool showFullPage;

  const InternetCheckWrapper({
    super.key,
    required this.child,
    this.showSnackbar = false,
    this.showFullPage = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (showSnackbar) {
      ref.listen(connectivityProvider, (previous, next) {
        next.whenData((status) {
          if (status == ConnectionStatus.disconnected) {
            _showSnackbar(context);
          } else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        });
      });
    }

    final connectionStatus = ref.watch(connectivityProvider);

    return connectionStatus.when(
      data: (status) {
        if (status == ConnectionStatus.disconnected && showFullPage) {
          return _buildNoInternetPage(ref);
        }
        return child;
      },
      loading: () => child,
      error: (error, stack) => child,
    );
  }

  Widget _buildNoInternetPage(WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                size: 100,
                color: kPrimaryDarkColor,
              ),
              const SizedBox(height: 30),
              const Text(
                'No Internet Connection',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Text(
                'It seems you are offline. Please check your internet settings and try again to continue using the app.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 160,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    // This will trigger a refresh of the provider
                    ref.invalidate(connectivityProvider);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryDarkColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context) {
    // Show persistent snackbar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.wifi_off_rounded, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text('You are offline. Please check your connection.'),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        duration: const Duration(days: 1), // Persistent
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        action: SnackBarAction(
          label: 'DISMISS',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
