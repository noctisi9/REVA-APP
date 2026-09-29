import 'package:flutter/material.dart';
import '../../theme/reva_theme.dart';

class CookiesScreen extends StatelessWidget {
  const CookiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RevaTheme.background,
      appBar: AppBar(title: const Text('Cookies Policy')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            'Cookies Policy\n\n'
            'This policy applies to the REVA companion website (River). The '
            'mobile app itself does not use browser cookies, but uses '
            'equivalent local device storage for keeping you signed in.\n\n'
            '1. Essential cookies\n'
            'Used to keep you signed in and remember basic preferences. These '
            'cannot be disabled without affecting core functionality.\n\n'
            '2. Analytics cookies\n'
            'May be used to understand aggregate usage patterns (e.g. which '
            'pages are visited). No personally identifying data is sold.\n\n'
            '3. Managing cookies\n'
            'You can control or delete cookies through your browser settings '
            'at any time.\n\n'
            '[Placeholder — have this reviewed before public launch.]',
            style: TextStyle(color: RevaTheme.textSecondary, height: 1.5),
          ),
        ),
      ),
    );
  }
}
