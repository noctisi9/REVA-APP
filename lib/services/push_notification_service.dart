import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// New content is broadcast to everyone subscribed to the "new_content"
/// topic — see functions/index.js, which publishes to this topic whenever
/// a content_items document is created. No per-device token bookkeeping
/// needed on the client side.
class PushNotificationService {
  PushNotificationService({FirebaseMessaging? messaging})
      : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  static const _topic = 'new_content';
  static const _channel = AndroidNotificationChannel(
    'new_content_channel',
    'New content',
    description: 'Notifies you when new REVA content is published',
    importance: Importance.high,
  );

  Future<void> initialize() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
    await _messaging.subscribeToTopic(_topic);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    await _localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    // App is in the foreground: FCM won't show a system banner on its own,
    // so we surface it via local notifications instead.
    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> unsubscribe() => _messaging.unsubscribeFromTopic(_topic);
}

/// Must be a top-level function — handles notifications that arrive while
/// the app is fully backgrounded/terminated. Registered in main.dart.
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // No-op: FCM + the OS handle displaying the system notification for
  // background/terminated state automatically since our payload includes
  // a `notification` block. This hook exists for future data-only
  // processing (e.g. updating a local cache) if needed later.
}
