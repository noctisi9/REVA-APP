import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/reva_theme.dart';

/// Static list for launch. Consider moving this to Firestore later so it
/// can be region-aware / updated without a release, same as content_items.
class ResourceDirectoryScreen extends StatelessWidget {
  const ResourceDirectoryScreen({super.key});

  static const _resources = [
    _Resource(
      name: 'Crisis support (US) — 988 Suicide & Crisis Lifeline',
      detail: 'Call or text 988, available 24/7',
      uri: 'tel:988',
    ),
    _Resource(
      name: 'Crisis Text Line',
      detail: 'Text HOME to 741741 (US/Canada)',
      uri: 'sms:741741&body=HOME',
    ),
    _Resource(
      name: 'Find a trauma-informed therapist',
      detail: 'Psychology Today therapist directory',
      uri: 'https://www.psychologytoday.com/us/therapists/trauma-and-ptsd',
    ),
    _Resource(
      name: 'International Association of Trauma Professionals',
      detail: 'Provider directory and resources',
      uri: 'https://www.traumapro.net/',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RevaTheme.background,
      appBar: AppBar(title: const Text('Resources')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            color: RevaTheme.surface,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'REVA shares educational content about complex trauma. It is '
                'not therapy and not a substitute for professional care or '
                'crisis support. If you\'re in immediate danger, please '
                'contact local emergency services.',
                style: TextStyle(color: RevaTheme.textSecondary),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ..._resources.map((r) => Card(
                color: RevaTheme.surface,
                child: ListTile(
                  title: Text(r.name, style: const TextStyle(color: RevaTheme.textPrimary)),
                  subtitle: Text(r.detail, style: const TextStyle(color: RevaTheme.textSecondary)),
                  trailing: const Icon(Icons.arrow_outward, color: RevaTheme.accent),
                  onTap: () => launchUrl(Uri.parse(r.uri)),
                ),
              )),
        ],
      ),
    );
  }
}

class _Resource {
  const _Resource({required this.name, required this.detail, required this.uri});
  final String name;
  final String detail;
  final String uri;
}
