import 'package:flutter/material.dart';
import '../models/content_item.dart';
import '../services/content_service.dart';
import '../widgets/content_feed.dart';

class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({super.key, required this.contentService});

  final ContentService contentService;

  @override
  Widget build(BuildContext context) {
    return ContentFeed(
      category: ContentCategory.discovery,
      contentService: contentService,
    );
  }
}
