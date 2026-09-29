import 'package:flutter/material.dart';
import '../models/content_item.dart';
import '../services/content_service.dart';
import '../theme/reva_theme.dart';
import 'content_detail_screen.dart';

class ContentFeed extends StatelessWidget {
  const ContentFeed({
    super.key,
    required this.category,
    required this.contentService,
  });

  final ContentCategory category;
  final ContentService contentService;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ContentItem>>(
      stream: contentService.streamByCategory(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Something went wrong loading content. Pull to refresh.',
              style: TextStyle(color: RevaTheme.textSecondary),
            ),
          );
        }

        final items = snapshot.data ?? const [];
        if (items.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'Nothing here yet — new content is on the way.',
                textAlign: TextAlign.center,
                style: TextStyle(color: RevaTheme.textSecondary),
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = items[index];
            return _ContentCard(item: item);
          },
        );
      },
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({required this.item});

  final ContentItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: RevaTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          backgroundColor: RevaTheme.accent.withOpacity(0.2),
          child: Icon(_iconFor(item.type), color: RevaTheme.accent),
        ),
        title: Text(item.title, style: const TextStyle(color: RevaTheme.textPrimary)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            item.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: RevaTheme.textSecondary),
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ContentDetailScreen(item: item)),
          );
        },
      ),
    );
  }

  IconData _iconFor(ContentType type) {
    switch (type) {
      case ContentType.video:
        return Icons.play_circle_outline;
      case ContentType.article:
        return Icons.article_outlined;
      case ContentType.quote:
        return Icons.format_quote;
      case ContentType.externalLink:
        return Icons.open_in_new;
    }
  }
}
