import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'theme/reva_theme.dart';
import 'screens/auth_gate.dart';
import 'services/push_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Must be registered before runApp — handles notifications that arrive
  // while the app is backgrounded or fully terminated.
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const RevaApp());
}

class RevaApp extends StatelessWidget {
  const RevaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REVA',
      debugShowCheckedModeBanner: false,
      theme: RevaTheme.dark,
      home: AuthGate(),
    );
  }
}
