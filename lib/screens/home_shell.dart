import 'package:flutter/material.dart';
import '../services/admin_config.dart';
import '../services/auth_service.dart';
import '../services/content_service.dart';
import '../theme/reva_theme.dart';
import 'admin_upload_screen.dart';
import 'community_screen.dart';
import 'discovery_screen.dart';
import 'healing_screen.dart';
import 'saved_screen.dart';
import 'settings_screen.dart';

/// Replace with your actual Facebook Page URL.
const String kFacebookPageUrl = 'https://facebook.com/yourrevapage';

/// Main bottom-nav shell wiring together all tabs. This replaces the
/// Milestone 2 placeholder body of HomeShell with the real feed/community/
/// saved/settings screens, plus the admin-only upload FAB.
class MainNavScaffold extends StatefulWidget {
  const MainNavScaffold({super.key, required this.authService});

  final AuthService authService;

  @override
  State<MainNavScaffold> createState() => _MainNavScaffoldState();
}

class _MainNavScaffoldState extends State<MainNavScaffold> {
  int _index = 0;
  final _contentService = ContentService();

  @override
  Widget build(BuildContext context) {
    final uid = widget.authService.currentUser?.uid;
    final isAdmin = AdminConfig.isAdmin(uid);

    final screens = [
      DiscoveryScreen(contentService: _contentService),
      HealingScreen(contentService: _contentService),
      const CommunityScreen(facebookPageUrl: kFacebookPageUrl),
      SavedScreen(),
      SettingsScreen(authService: widget.authService),
    ];

    return Scaffold(
      backgroundColor: RevaTheme.background,
      appBar: AppBar(title: const Text('REVA')),
      body: IndexedStack(index: _index, children: screens),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              backgroundColor: RevaTheme.accent,
              tooltip: 'Upload content (admin)',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AdminUploadScreen()),
              ),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: RevaTheme.surface,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.explore_outlined), label: 'Discovery'),
          NavigationDestination(icon: Icon(Icons.spa_outlined), label: 'Healing'),
          NavigationDestination(icon: Icon(Icons.groups_outlined), label: 'Community'),
          NavigationDestination(icon: Icon(Icons.bookmark_outline), label: 'Saved'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}
