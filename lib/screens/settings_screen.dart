import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/reva_theme.dart';
import 'legal/cookies_screen.dart';
import 'legal/privacy_screen.dart';
import 'legal/terms_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.authService});

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RevaTheme.background,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Terms & Conditions', style: TextStyle(color: RevaTheme.textPrimary)),
            trailing: const Icon(Icons.chevron_right, color: RevaTheme.textSecondary),
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const TermsScreen())),
          ),
          ListTile(
            title: const Text('Privacy Policy', style: TextStyle(color: RevaTheme.textPrimary)),
            trailing: const Icon(Icons.chevron_right, color: RevaTheme.textSecondary),
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const PrivacyScreen())),
          ),
          ListTile(
            title: const Text('Cookies Policy', style: TextStyle(color: RevaTheme.textPrimary)),
            trailing: const Icon(Icons.chevron_right, color: RevaTheme.textSecondary),
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const CookiesScreen())),
          ),
          const Divider(color: RevaTheme.surface),
          ListTile(
            title: const Text('Sign out', style: TextStyle(color: Colors.redAccent)),
            onTap: authService.signOut,
          ),
        ],
      ),
    );
  }
}
