import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../models/content_item.dart';
import '../services/content_service.dart';
import '../services/media_upload_service.dart';
import '../theme/reva_theme.dart';

/// The whole reason REVA doesn't need an app update per content drop:
/// fill this form, hit publish, it's live in the feed immediately.
class AdminUploadScreen extends StatefulWidget {
  const AdminUploadScreen({super.key});

  @override
  State<AdminUploadScreen> createState() => _AdminUploadScreenState();
}

class _AdminUploadScreenState extends State<AdminUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _externalUrlController = TextEditingController();
  final _tagsController = TextEditingController();

  final _contentService = ContentService();
  final _uploadService = MediaUploadService();

  ContentType _type = ContentType.externalLink;
  SourceType _sourceType = SourceType.youtube;
  ContentCategory _category = ContentCategory.discovery;
  File? _pickedFile;
  bool _isSubmitting = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.media);
    if (result != null && result.files.single.path != null) {
      setState(() => _pickedFile = File(result.files.single.path!));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      String? mediaUrl;
      if (_pickedFile != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${_titleController.text}';
        mediaUrl = await _uploadService.uploadContentFile(_pickedFile!, fileName);
      }

      final item = ContentItem(
        id: '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _type,
        sourceType: _sourceType,
        category: _category,
        tags: _tagsController.text.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList(),
        createdAt: DateTime.now(),
        mediaUrl: mediaUrl,
        externalUrl: _externalUrlController.text.trim().isEmpty
            ? null
            : _externalUrlController.text.trim(),
      );

      await _contentService.addContent(item);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Published — it\'s live in the feed now.')),
        );
        _formKey.currentState!.reset();
        _titleController.clear();
        _descriptionController.clear();
        _externalUrlController.clear();
        _tagsController.clear();
        setState(() => _pickedFile = null);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _externalUrlController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RevaTheme.background,
      appBar: AppBar(title: const Text('Upload content')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Description is required' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ContentCategory>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: ContentCategory.values
                  .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ContentType>(
              value: _type,
              decoration: const InputDecoration(labelText: 'Content type'),
              items: ContentType.values
                  .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                  .toList(),
              onChanged: (v) => setState(() => _type = v!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<SourceType>(
              value: _sourceType,
              decoration: const InputDecoration(labelText: 'Source'),
              items: SourceType.values
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                  .toList(),
              onChanged: (v) => setState(() => _sourceType = v!),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _externalUrlController,
              decoration: const InputDecoration(
                labelText: 'External URL (YouTube link, article link, etc.)',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _tagsController,
              decoration: const InputDecoration(labelText: 'Tags (comma-separated)'),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.upload_file),
              label: Text(_pickedFile == null ? 'Attach media (optional)' : 'File selected ✓'),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isSubmitting ? null : _submit,
              style: FilledButton.styleFrom(backgroundColor: RevaTheme.accent),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Publish'),
            ),
          ],
        ),
      ),
    );
  }
}
