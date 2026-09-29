import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../models/content_item.dart';
import '../services/content_service.dart';
import '../services/user_prefs_service.dart';
import '../theme/reva_theme.dart';

class ContentDetailScreen extends StatefulWidget {
  const ContentDetailScreen({super.key, required this.item});

  final ContentItem item;

  @override
  State<ContentDetailScreen> createState() => _ContentDetailScreenState();
}

class _ContentDetailScreenState extends State<ContentDetailScreen> {
  final _prefsService = UserPrefsService();
  final _contentService = ContentService();
  VideoPlayerController? _videoController;
  bool _isSaved = false;
  String? _selectedReaction;

  static const _reactions = {
    'resonated': 'This resonated',
    'helped': 'This helped',
    'needed_today': 'Needed this today',
  };

  @override
  void initState() {
    super.initState();
    if (widget.item.type == ContentType.video && widget.item.mediaUrl != null) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.item.mediaUrl!))
        ..initialize().then((_) => setState(() {}));
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  Future<void> _toggleSave() async {
    final uid = _uid;
    if (uid == null) return;
    setState(() => _isSaved = !_isSaved);
    await _prefsService.toggleSaved(uid, widget.item.id, _isSaved);
  }

  Future<void> _react(String key) async {
    final uid = _uid;
    if (uid == null) return;
    setState(() => _selectedReaction = key);
    await _prefsService.setReaction(uid, widget.item.id, key);
  }

  Future<void> _reportContent() async {
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => _ReportDialog(),
    );
    if (reason == null || reason.isEmpty) return;
    final uid = _uid;
    if (uid == null) return;

    await _contentService.reportContent(
      contentId: widget.item.id,
      reporterUid: uid,
      reason: reason,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thanks — this has been flagged for review.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      backgroundColor: RevaTheme.background,
      appBar: AppBar(
        title: Text(item.title, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            tooltip: 'Report',
            onPressed: _reportContent,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMedia(item),
            const SizedBox(height: 16),
            Text(
              item.title,
              style: const TextStyle(
                color: RevaTheme.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(item.description, style: const TextStyle(color: RevaTheme.textSecondary)),
            const SizedBox(height: 24),
            Row(
              children: [
                IconButton(
                  onPressed: _toggleSave,
                  icon: Icon(
                    _isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: RevaTheme.accent,
                  ),
                ),
                const Text('Save for later', style: TextStyle(color: RevaTheme.textSecondary)),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _reactions.entries.map((entry) {
                final isSelected = _selectedReaction == entry.key;
                return ChoiceChip(
                  label: Text(entry.value),
                  selected: isSelected,
                  onSelected: (_) => _react(entry.key),
                  selectedColor: RevaTheme.accent,
                  backgroundColor: RevaTheme.surface,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : RevaTheme.textSecondary,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedia(ContentItem item) {
    if (item.type == ContentType.video && _videoController != null) {
      if (!_videoController!.value.isInitialized) {
        return const AspectRatio(
          aspectRatio: 16 / 9,
          child: Center(child: CircularProgressIndicator()),
        );
      }
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_videoController!),
            IconButton(
              iconSize: 56,
              color: Colors.white70,
              icon: Icon(
                _videoController!.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
              ),
              onPressed: () => setState(() {
                _videoController!.value.isPlaying
                    ? _videoController!.pause()
                    : _videoController!.play();
              }),
            ),
          ],
        ),
      );
    }

    if (item.externalUrl != null) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          icon: const Icon(Icons.open_in_new),
          label: Text(
            item.sourceType == SourceType.youtube ? 'Watch on YouTube' : 'Open source',
          ),
          onPressed: () => launchUrl(
            Uri.parse(item.externalUrl!),
            mode: LaunchMode.externalApplication,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _ReportDialog extends StatefulWidget {
  @override
  State<_ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<_ReportDialog> {
  String _reason = 'Inaccurate or misleading';

  static const _options = [
    'Inaccurate or misleading',
    'Potentially retraumatizing content',
    'Broken link or media',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: RevaTheme.surface,
      title: const Text('Report this content', style: TextStyle(color: RevaTheme.textPrimary)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: _options
            .map((option) => RadioListTile<String>(
                  value: option,
                  groupValue: _reason,
                  onChanged: (value) => setState(() => _reason = value!),
                  title: Text(option, style: const TextStyle(color: RevaTheme.textPrimary)),
                  activeColor: RevaTheme.accent,
                ))
            .toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_reason),
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
