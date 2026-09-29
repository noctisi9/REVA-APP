import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/content_item.dart';
import '../services/user_prefs_service.dart';
import '../theme/reva_theme.dart';
import 'content_detail_screen.dart';

class SavedScreen extends StatelessWidget {
  SavedScreen({super.key});

  final _prefsService = UserPrefsService();

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Scaffold(body: Center(child: Text('Please sign in.')));
    }

    return Scaffold(
      backgroundColor: RevaTheme.background,
      appBar: AppBar(title: const Text('Saved')),
      body: StreamBuilder<Set<String>>(
        stream: _prefsService.streamSavedIds(uid),
        builder: (context, snapshot) {
          final ids = snapshot.data ?? {};
          if (ids.isEmpty) {
            return const Center(
              child: Text(
                'Nothing saved yet — tap the bookmark icon on any content to keep it here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: RevaTheme.textSecondary),
              ),
            );
          }

          return FutureBuilder<List<ContentItem>>(
            future: _fetchItems(ids.toList()),
            builder: (context, itemSnapshot) {
              if (!itemSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final items = itemSnapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    color: RevaTheme.surface,
                    child: ListTile(
                      title: Text(item.title, style: const TextStyle(color: RevaTheme.textPrimary)),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ContentDetailScreen(item: item)),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<ContentItem>> _fetchItems(List<String> ids) async {
    if (ids.isEmpty) return [];
    final snap = await FirebaseFirestore.instance
        .collection('content_items')
        .where(FieldPath.documentId, whereIn: ids.take(10).toList())
        .get();
    return snap.docs.map(ContentItem.fromFirestore).toList();
  }
}
