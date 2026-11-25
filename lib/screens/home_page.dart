import 'package:material_ui/material_ui.dart';

import '../models/demo_store.dart';
import '../theme/app_theme.dart';
import 'create_post_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.store});

  final DemoStore store;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTab = 0;

  Future<void> _openCreatePost() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
          builder: (_) => CreatePostPage(store: widget.store)),
    );
    if (mounted) setState(() => _selectedTab = 0);
  }

  void _selectTab(int index) {
    if (index == 2) {
      _openCreatePost();
    } else {
      setState(() => _selectedTab = index);
    }
  }

  void _signOut() {
    widget.store.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => LoginPage(store: widget.store)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      FeedPage(
          store: widget.store,
          onSearch: () => _selectTab(1),
          onNotifications: () => _selectTab(3)),
      SearchPage(store: widget.store),
      const SizedBox.shrink(),
      const NotificationsPage(),
      ProfilePage(store: widget.store, onSignOut: _signOut),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: pages[_selectedTab]),
      bottomNavigationBar:
          _FeedBottomBar(selectedIndex: _selectedTab, onTap: _selectTab),
    );
  }
}

class FeedPage extends StatelessWidget {
  const FeedPage(
      {super.key,
      required this.store,
      required this.onSearch,
      required this.onNotifications});

  final DemoStore store;
  final VoidCallback onSearch;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          _FeedHeader(
              userName: store.currentUser?.name ?? 'Guest',
              onSearch: onSearch,
              onNotifications: onNotifications),
          const SizedBox(height: 10),
          const _StoriesRow(),
          const SizedBox(height: 14),
          for (final post in store.posts) ...[
            FeedPostCard(post: post),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _FeedHeader extends StatelessWidget {
  const _FeedHeader(
      {required this.userName,
      required this.onSearch,
      required this.onNotifications});

  final String userName;
  final VoidCallback onSearch;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Dashboard',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 10),
        Row(
          children: [
            const Expanded(
                child: Text('Boring App',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: appInk))),
            IconButton(
                onPressed: onSearch,
                icon: const Icon(Icons.search_rounded, color: appInk)),
            IconButton(
                onPressed: onNotifications,
                icon: const Icon(Icons.notifications_none_rounded,
                    color: appInk)),
          ],
        ),
        Text('Welcome, $userName',
            style: const TextStyle(fontSize: 12, color: appMuted)),
      ],
    );
  }
}

class _StoriesRow extends StatelessWidget {
  const _StoriesRow();

  @override
  Widget build(BuildContext context) {
    const stories = [
      ('My profile', '+', Color(0xFFE9ECFF)),
      ('saram_k...', 'S', Color(0xFFD7E7D8)),
      ('saram_k...', 'J', Color(0xFFEADBD8)),
      ('alex_m...', 'A', Color(0xFFDCE5F3)),
    ];
    return SizedBox(
      height: 88,
      child: Row(
        children: [
          for (var i = 0; i < stories.length; i++)
            Expanded(
              child: _StoryTile(
                  name: stories[i].$1,
                  initials: stories[i].$2,
                  color: stories[i].$3,
                  isAdd: i == 0),
            ),
        ],
      ),
    );
  }
}

class _StoryTile extends StatelessWidget {
  const _StoryTile(
      {required this.name,
      required this.initials,
      required this.color,
      this.isAdd = false});

  final String name;
  final String initials;
  final Color color;
  final bool isAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 23,
          backgroundColor: color,
          child: Text(initials,
              style: TextStyle(
                  color: isAdd ? appBlue : appInk,
                  fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 3),
        Text(name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: appInk)),
      ],
    );
  }
}

class FeedPostCard extends StatelessWidget {
  const FeedPostCard({super.key, required this.post});

  final DemoPost post;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration:
          BoxDecoration(border: Border.all(color: const Color(0xFFF0EEEE))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                  radius: 17,
                  backgroundColor: const Color(0xFFE4E0F5),
                  child: Text(_initials(post.name),
                      style: const TextStyle(
                          fontSize: 11,
                          color: appInk,
                          fontWeight: FontWeight.w700))),
              const SizedBox(width: 9),
              Text(post.name,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: appInk)),
              const Spacer(),
              const Icon(Icons.more_horiz, color: appMuted),
            ],
          ),
          const SizedBox(height: 9),
          if (post.hasImage) ...[
            ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: _PostImage(post: post)),
            const SizedBox(height: 7),
          ],
          Row(
            children: [
              const Icon(Icons.favorite_border_rounded,
                  color: Colors.redAccent, size: 19),
              const SizedBox(width: 4),
              Text('${post.likes}',
                  style: const TextStyle(fontSize: 12, color: appInk)),
              const SizedBox(width: 12),
              const Icon(Icons.chat_bubble_outline_rounded,
                  size: 18, color: appMuted),
              const SizedBox(width: 12),
              const Icon(Icons.open_in_new_rounded, size: 18, color: appMuted),
            ],
          ),
          const SizedBox(height: 8),
          Text(post.caption,
              style:
                  const TextStyle(fontSize: 11, height: 1.35, color: appInk)),
        ],
      ),
    );
  }
}

class _PostImage extends StatelessWidget {
  const _PostImage({required this.post});

  final DemoPost post;

  @override
  Widget build(BuildContext context) {
    final Widget child;
    if (post.imageBytes != null) {
      child = Image.memory(post.imageBytes!,
          width: double.infinity,
          height: 190,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const _PostImageFallback());
    } else if (post.imageAsset != null) {
      child = Image.asset(post.imageAsset!,
          width: double.infinity,
          height: 190,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const _PostImageFallback());
    } else if (post.architectureIllustration) {
      child = const _ArchitecturePostImage();
    } else {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: double.infinity,
      height: 190,
      child: child,
    );
  }
}

class _PostImageFallback extends StatelessWidget {
  const _PostImageFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFF0F0F5),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.broken_image_outlined, color: appMuted),
            SizedBox(height: 6),
            Text('Image unavailable',
                style: TextStyle(color: appMuted, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  return parts
      .take(2)
      .map((part) => part.isEmpty ? '' : part[0].toUpperCase())
      .join();
}

class _ArchitecturePostImage extends StatelessWidget {
  const _ArchitecturePostImage();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 190,
      child: Stack(
        children: [
          const Positioned.fill(
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFB8D9EF), Color(0xFFE8EFF2)])))),
          const Positioned(
              left: 20,
              bottom: 0,
              child:
                  _Building(width: 118, height: 145, color: Color(0xFF9A9FA2))),
          const Positioned(
              right: 22,
              bottom: 0,
              child:
                  _Building(width: 112, height: 106, color: Color(0xFF777F84))),
          Positioned(
              left: 35,
              right: 28,
              bottom: 0,
              child: Container(height: 9, color: const Color(0xFF525B61))),
        ],
      ),
    );
  }
}

class _Building extends StatelessWidget {
  const _Building(
      {required this.width, required this.height, required this.color});

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(9),
      color: color,
      child: Column(
        children: List.generate(
          4,
          (row) => Expanded(
            child: Row(
              children: List.generate(
                3,
                (column) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    color: (row + column).isEven
                        ? const Color(0xFFD7E2E6)
                        : const Color(0xFF707B81),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.store});
  final DemoStore store;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final query = _query.text.toLowerCase();
        final results = widget.store.posts
            .where((post) =>
                post.name.toLowerCase().contains(query) ||
                post.caption.toLowerCase().contains(query))
            .toList();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _query,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search posts',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Expanded(
                child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                  for (final post in results) ...[
                    FeedPostCard(post: post),
                    const SizedBox(height: 14)
                  ]
                ])),
          ],
        );
      },
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child:
            Text('You are all caught up.', style: TextStyle(color: appMuted)));
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.store, required this.onSignOut});

  final DemoStore store;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final user = store.currentUser;
        if (user == null) return const SizedBox.shrink();
        final posts = store.postsBy(user.email);
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                const Expanded(
                    child: Text('Profile',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: appInk))),
                TextButton(onPressed: onSignOut, child: const Text('Log out')),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                CircleAvatar(
                    radius: 36,
                    backgroundColor: const Color(0xFFE9ECFF),
                    child: Text(_initials(user.name),
                        style: const TextStyle(
                            fontSize: 22,
                            color: appBlue,
                            fontWeight: FontWeight.w700))),
                const SizedBox(width: 18),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(user.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700)),
                  Text(user.email, style: const TextStyle(color: appMuted))
                ]),
              ],
            ),
            const SizedBox(height: 20),
            Text('${posts.length} posts',
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: appInk)),
            const SizedBox(height: 12),
            if (posts.isEmpty)
              const Text('Your photo posts will appear here.',
                  style: TextStyle(color: appMuted)),
            for (final post in posts) ...[
              FeedPostCard(post: post),
              const SizedBox(height: 14)
            ],
          ],
        );
      },
    );
  }
}

class _FeedBottomBar extends StatelessWidget {
  const _FeedBottomBar({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const icons = [
      Icons.home_outlined,
      Icons.search_rounded,
      Icons.add_box_outlined,
      Icons.notifications_none_rounded,
      Icons.account_circle_outlined
    ];
    return SafeArea(
      top: false,
      child: Container(
        height: 56,
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFFF0EEEE)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (var i = 0; i < icons.length; i++)
              IconButton(
                tooltip: [
                  'Home',
                  'Search',
                  'Create post',
                  'Notifications',
                  'Profile'
                ][i],
                onPressed: () => onTap(i),
                icon: Icon(icons[i],
                    color: selectedIndex == i ? appBlue : appMuted),
              ),
          ],
        ),
      ),
    );
  }
}
