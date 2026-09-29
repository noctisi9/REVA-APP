import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/reva_theme.dart';
import 'resource_directory_screen.dart';

/// Discussion intentionally lives off-platform on Facebook (existing
/// moderation tools) rather than as in-app comments — see REVA's
/// content-safety decision. In-app stays to reactions/saves only.
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key, required this.facebookPageUrl});

  final String facebookPageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RevaTheme.background,
      appBar: AppBar(title: const Text('Community')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: RevaTheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(Icons.facebook, color: RevaTheme.accent, size: 32),
              title: const Text('Join the conversation', style: TextStyle(color: RevaTheme.textPrimary)),
              subtitle: const Text(
                'Discuss and connect with others on the REVA Facebook page',
                style: TextStyle(color: RevaTheme.textSecondary),
              ),
              trailing: const Icon(Icons.arrow_outward, color: RevaTheme.textSecondary),
              onTap: () => launchUrl(
                Uri.parse(facebookPageUrl),
                mode: LaunchMode.externalApplication,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: RevaTheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(Icons.support, color: RevaTheme.accent, size: 32),
              title: const Text('Find support', style: TextStyle(color: RevaTheme.textPrimary)),
              subtitle: const Text(
                'Crisis lines and trauma-informed care directory',
                style: TextStyle(color: RevaTheme.textSecondary),
              ),
              trailing: const Icon(Icons.chevron_right, color: RevaTheme.textSecondary),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ResourceDirectoryScreen()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
