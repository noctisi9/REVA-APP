import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/resource_directory_screen.dart';
import '../theme/reva_theme.dart';

/// Shown once per device on first launch after sign-in. Cheap, and it's
/// the kind of thing reviewers/press expect from a mental-health-adjacent
/// app — see REVA's legal/trust decision.
class DisclaimerGate extends StatefulWidget {
  const DisclaimerGate({super.key, required this.child});

  final Widget child;

  @override
  State<DisclaimerGate> createState() => _DisclaimerGateState();
}

class _DisclaimerGateState extends State<DisclaimerGate> {
  static const _prefKey = 'has_seen_disclaimer_v1';
  bool _checked = false;
  bool _hasSeen = false;

  @override
  void initState() {
    super.initState();
    _checkPrefs();
  }

  Future<void> _checkPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hasSeen = prefs.getBool(_prefKey) ?? false;
      _checked = true;
    });
  }

  Future<void> _dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, true);
    if (mounted) setState(() => _hasSeen = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_checked) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_hasSeen) {
      return Scaffold(
        backgroundColor: RevaTheme.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.info_outline, color: RevaTheme.accent, size: 40),
                const SizedBox(height: 16),
                const Text(
                  'Before you begin',
                  style: TextStyle(
                    color: RevaTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'REVA shares educational content about complex trauma. '
                  'It is not therapy, and it\'s not a substitute for '
                  'professional support or crisis care.\n\n'
                  'If you\'re in crisis or need immediate support, help is '
                  'available — see Resources any time from the Community tab.',
                  style: TextStyle(color: RevaTheme.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ResourceDirectoryScreen()),
                  ),
                  child: const Text('View resources'),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: RevaTheme.accent),
                  onPressed: _dismiss,
                  child: const Text('I understand, continue'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return widget.child;
  }
}
