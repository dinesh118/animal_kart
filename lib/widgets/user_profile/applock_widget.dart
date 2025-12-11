import 'package:flutter/material.dart';
import 'package:animal_kart_demo2/l10n/app_localizations.dart';

class AppLockWidget extends StatelessWidget {
  final bool isEnabled;
  final Function(bool) onToggle;

  const AppLockWidget({super.key, required this.isEnabled, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('app_lock_fingerprint'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Switch(value: isEnabled, onChanged: onToggle),
            ],
          ),
          if (isEnabled)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 16, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'App will lock when minimized and reopened',
                      style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
