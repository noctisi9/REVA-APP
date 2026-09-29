import 'package:cloud_firestore/cloud_firestore.dart';

enum ContentType { video, article, quote, externalLink }

enum SourceType { self, youtube, external }

enum ContentCategory { discovery, healing }

ContentType contentTypeFromString(String value) =>
    ContentType.values.firstWhere((e) => e.name == value, orElse: () => ContentType.article);

SourceType sourceTypeFromString(String value) =>
    SourceType.values.firstWhere((e) => e.name == value, orElse: () => SourceType.external);

ContentCategory categoryFromString(String value) => ContentCategory.values
    .firstWhere((e) => e.name == value, orElse: () => ContentCategory.discovery);

/// A single piece of REVA content — a video, article, quote, or link.
/// New items appear in the app the moment they're written to Firestore;
/// no app rebuild required.
class ContentItem {
  const ContentItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.sourceType,
    required this.category,
    required this.tags,
    required this.createdAt,
    this.mediaUrl,
    this.externalUrl,
  });

  final String id;
  final String title;
  final String description;
  final ContentType type;
  final SourceType sourceType;
  final ContentCategory category;
  final List<String> tags;
  final DateTime createdAt;

  /// Set when the file lives in Firebase Storage (self-uploaded media).
  final String? mediaUrl;

  /// Set when the content points off-platform (e.g. a YouTube video).
  final String? externalUrl;

  factory ContentItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ContentItem(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      type: contentTypeFromString(data['type'] as String? ?? 'article'),
      sourceType: sourceTypeFromString(data['sourceType'] as String? ?? 'external'),
      category: categoryFromString(data['category'] as String? ?? 'discovery'),
      tags: List<String>.from(data['tags'] as List? ?? const []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      mediaUrl: data['mediaUrl'] as String?,
      externalUrl: data['externalUrl'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'type': type.name,
      'sourceType': sourceType.name,
      'category': category.name,
      'tags': tags,
      'createdAt': FieldValue.serverTimestamp(),
      if (mediaUrl != null) 'mediaUrl': mediaUrl,
      if (externalUrl != null) 'externalUrl': externalUrl,
    };
  }
}
