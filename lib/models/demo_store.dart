import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';

class DemoUser {
  const DemoUser(
      {required this.name, required this.email, required this.password});

  final String name;
  final String email;
  final String password;
}

class DemoPost {
  const DemoPost({
    required this.name,
    required this.email,
    required this.caption,
    this.imageAsset,
    this.imageBytes,
    this.architectureIllustration = false,
    this.likes = 0,
  });

  final String name;
  final String email;
  final String caption;
  final String? imageAsset;
  final Uint8List? imageBytes;
  final bool architectureIllustration;
  final int likes;

  bool get hasImage =>
      imageBytes != null || imageAsset != null || architectureIllustration;
}

// A local in-memory store keeps this demo independent of a server or database.
class DemoStore extends ChangeNotifier {
  DemoStore() {
    _accounts['demo@boring.app'] = const DemoUser(
      name: 'Alex Morgan',
      email: 'demo@boring.app',
      password: 'boring123',
    );
    _posts.addAll(const [
      DemoPost(
        name: 'Mia Rivera',
        email: 'mia@example.com',
        caption: 'A quiet place by the sea. Taking a moment to enjoy the view.',
        imageAsset: 'assets/images/learning_landscape.png',
        likes: 89,
      ),
      DemoPost(
        name: 'Sam Kim',
        email: 'sam@example.com',
        caption:
            'Simple shapes and thoughtful spaces. Architecture inspiration for today.',
        architectureIllustration: true,
        likes: 42,
      ),
    ]);
  }

  final Map<String, DemoUser> _accounts = {};
  final List<DemoPost> _posts = [];
  DemoUser? currentUser;

  List<DemoPost> get posts => List.unmodifiable(_posts);

  List<DemoPost> postsBy(String email) => _posts
      .where((post) => post.email.toLowerCase() == email.toLowerCase())
      .toList();

  bool signIn(String email, String password) {
    final user = _accounts[email.trim().toLowerCase()];
    if (user == null || user.password != password) return false;
    currentUser = user;
    notifyListeners();
    return true;
  }

  String? createAccount(String name, String email, String password) {
    final normalizedEmail = email.trim().toLowerCase();
    if (_accounts.containsKey(normalizedEmail)) {
      return 'An account already uses that email.';
    }
    final user =
        DemoUser(name: name.trim(), email: normalizedEmail, password: password);
    _accounts[normalizedEmail] = user;
    currentUser = user;
    notifyListeners();
    return null;
  }

  String? resetPassword(String email, String newPassword) {
    final normalizedEmail = email.trim().toLowerCase();
    final user = _accounts[normalizedEmail];
    if (user == null) return 'No demo account was found for that email.';
    _accounts[normalizedEmail] = DemoUser(
      name: user.name,
      email: user.email,
      password: newPassword,
    );
    return null;
  }

  void addPost({Uint8List? imageBytes, required String caption}) {
    final user = currentUser;
    if (user == null || (imageBytes == null && caption.trim().isEmpty)) return;
    _posts.insert(
      0,
      DemoPost(
        name: user.name,
        email: user.email,
        caption: caption.trim(),
        imageBytes: imageBytes,
      ),
    );
    notifyListeners();
  }

  void signOut() {
    currentUser = null;
    notifyListeners();
  }
}
