import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notification_navigation_provider.dart';

class NotificationService {
  static Future<void> init(WidgetRef ref) async {
    final messaging = FirebaseMessaging.instance;

    
    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(ref, initialMessage);
    }

  
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => _handleMessage(ref, message),
    );
  }

  static void _handleMessage(
      WidgetRef ref, RemoteMessage message) {
    final data = message.data;

    if (!data.containsKey('type')) return;

    ref.read(notificationNavigationProvider.notifier).state = {
      'type': data['type'],
      'buffaloId': data['id'],
    };
  }
}
