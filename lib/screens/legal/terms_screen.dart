import 'package:flutter/material.dart';
import '../../theme/reva_theme.dart';

/// Placeholder legal copy. Replace with text reviewed against your
/// actual jurisdiction/business setup before public launch — this is
/// scaffolding, not legal advice.
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RevaTheme.background,
      appBar: AppBar(title: const Text('Terms & Conditions')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            'Terms & Conditions\n\n'
            '1. About REVA\n'
            'REVA provides educational content about complex trauma, sourced '
            'from third-party platforms and original research. REVA is not a '
            'medical, psychiatric, or therapeutic service and does not provide '
            'diagnosis or treatment.\n\n'
            '2. Accounts\n'
            'You are responsible for maintaining the security of your account '
            'credentials. Notify us if you suspect unauthorized access.\n\n'
            '3. Acceptable use\n'
            'Do not use REVA to harass others, share illegal content, or '
            'attempt to bypass app security.\n\n'
            '4. Content ownership\n'
            'Original content is owned by REVA/its creator. Third-party '
            'content is linked to, not rehosted, and remains the property of '
            'its original creators.\n\n'
            '5. Changes\n'
            'These terms may be updated; continued use constitutes acceptance '
            'of the current version.\n\n'
            '[Placeholder — have this reviewed before public launch.]',
            style: TextStyle(color: RevaTheme.textSecondary, height: 1.5),
          ),
        ),
      ),
    );
  }
}
