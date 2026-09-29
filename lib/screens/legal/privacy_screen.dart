import 'package:flutter/material.dart';
import '../../theme/reva_theme.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RevaTheme.background,
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            'Privacy Policy\n\n'
            '1. What we collect\n'
            'When you sign in, we receive your name and email address from '
            'your chosen sign-in provider (Google). We store which content '
            'you\'ve saved and reacted to, tied to your account.\n\n'
            '2. What we don\'t collect\n'
            'We do not collect payment information, precise location, or '
            'sensitive health details beyond what you choose to share with us '
            'directly.\n\n'
            '3. How we use your data\n'
            'Solely to operate the app: showing your saved items, personalizing '
            'your feed, and improving content based on aggregate (anonymized) '
            'reaction data.\n\n'
            '4. Data storage & security\n'
            'Data is stored with Google Firebase and protected by access '
            'controls restricting who can read or write it. We do not sell '
            'user data to third parties.\n\n'
            '5. Your rights\n'
            'You may request deletion of your account and associated data at '
            'any time.\n\n'
            '[Placeholder — have this reviewed before public launch.]',
            style: TextStyle(color: RevaTheme.textSecondary, height: 1.5),
          ),
        ),
      ),
    );
  }
}
