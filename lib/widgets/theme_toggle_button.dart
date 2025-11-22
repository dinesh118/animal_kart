import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animal_kart_demo2/theme/theme_provider.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeNotifierProvider);

    return IconButton(
      icon: Icon(
        themeNotifier.isDarkMode ? Icons.light_mode : Icons.dark_mode,
        color: Theme.of(context).appBarTheme.foregroundColor,
      ),
      onPressed: () {
        ref.read(themeNotifierProvider.notifier).toggleTheme();
      },
      tooltip: themeNotifier.isDarkMode ? 'Light Mode' : 'Dark Mode',
    );
  }
}
