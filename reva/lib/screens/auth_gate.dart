import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/push_notification_service.dart';
import '../widgets/disclaimer_gate.dart';
import 'home_shell.dart';
import 'login_screen.dart';

/// Listens to auth state and shows the right screen — no manual
/// navigation calls needed on sign-in/sign-out, the stream handles it.
class AuthGate extends StatefulWidget {
  AuthGate({super.key, AuthService? authService})
      : authService = authService ?? AuthService();

  final AuthService authService;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _pushService = PushNotificationService();
  bool _pushInitialized = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: widget.authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          _pushInitialized = false;
          return LoginScreen(authService: widget.authService);
        }

        // Subscribe once per sign-in, not on every rebuild.
        if (!_pushInitialized) {
          _pushInitialized = true;
          _pushService.initialize();
        }

        return DisclaimerGate(
          child: MainNavScaffold(authService: widget.authService),
        );
      },
    );
  }
}
