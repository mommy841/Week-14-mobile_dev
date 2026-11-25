import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../models/demo_store.dart';
import '../services/photo_picker_service.dart';
import '../theme/app_theme.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key, required this.store});

  final DemoStore store;

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _captionController = TextEditingController();
  final _picker = PhotoPickerService();
  Uint8List? _photo;
  bool _isPicking = false;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _choosePhoto() async {
    setState(() => _isPicking = true);
    try {
      final photo = await _picker.pickPhoto();
      if (mounted && photo != null) setState(() => _photo = photo);
    } on PlatformException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(error.message ?? 'Could not open your photos.')),
        );
      }
    } on MissingPluginException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Photo picking is available in the Android app.')),
        );
      }
    } on UnsupportedError catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(error.message ?? 'Photo picking is not available here.')));
      }
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  void _publish() {
    final photo = _photo;
    final caption = _captionController.text.trim();
    if (photo == null && caption.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Write a caption or add a photo.')));
      return;
    }
    widget.store.addPost(imageBytes: photo, caption: caption);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('New post'),
        actions: [
          TextButton(onPressed: _publish, child: const Text('Post')),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Posting as ${widget.store.currentUser?.name ?? 'you'}',
              style:
                  const TextStyle(fontWeight: FontWeight.w700, color: appInk)),
          const SizedBox(height: 14),
          TextField(
            controller: _captionController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Write a caption...',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 14),
          if (_photo != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => setState(() => _photo = null),
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('Remove photo'),
                  style: TextButton.styleFrom(foregroundColor: appMuted),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(_photo!, height: 300, fit: BoxFit.cover),
                ),
              ],
            )
          else
            Container(
              height: 240,
              decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F8),
                  borderRadius: BorderRadius.circular(10)),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.image_outlined, size: 48, color: appMuted),
                    SizedBox(height: 8),
                    Text('Photo is optional',
                        style: TextStyle(color: appMuted)),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: _isPicking ? null : _choosePhoto,
            icon: _isPicking
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.photo_library_outlined),
            label: Text(
                _isPicking ? 'Opening photos...' : 'Add a photo (optional)'),
            style: OutlinedButton.styleFrom(
                foregroundColor: appBlue,
                minimumSize: const Size.fromHeight(46)),
          ),
          const SizedBox(height: 10),
          const Text(
              'Your photo will appear at the top of the feed and on your profile.',
              style: TextStyle(fontSize: 12, color: appMuted)),
        ],
      ),
    );
  }
}
