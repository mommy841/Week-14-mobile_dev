import 'package:material_ui/material_ui.dart';

void main() => runApp(const DemoApp());

const _ink = Color(0xFF161616);
const _blue = Color(0xFF6664F5);
const _muted = Color(0xFF78839A);

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Boring App',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'DemoSans',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: _blue, primary: _blue),
      ),
      home: const LoginPage(),
    );
  }
}

// Screen 1: a static login mockup. The Log in button only opens the feed page.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(child: _BoringBrand()),
                        const SizedBox(height: 42),
                        const _LoginField(label: 'Email Address'),
                        const SizedBox(height: 20),
                        const _LoginField(label: 'Password', isPassword: true),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: null,
                            style: TextButton.styleFrom(
                              foregroundColor: _blue,
                              disabledForegroundColor: _blue,
                              padding:
                                  const EdgeInsets.only(top: 8, bottom: 10),
                              textStyle: const TextStyle(fontSize: 11),
                            ),
                            child: const Text('Forgot password?'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FilledButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (_) => const HomePage()),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: _blue,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(44),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7)),
                          ),
                          child: const Text('Log in',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(height: 30),
                        const _OrDivider(),
                        const SizedBox(height: 22),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _SocialButton(label: 'Google'),
                            SizedBox(width: 22),
                            _SocialButton(label: 'Facebook'),
                          ],
                        ),
                        const SizedBox(height: 54),
                        const Center(
                          child: Text.rich(
                            TextSpan(
                              style: TextStyle(color: _muted, fontSize: 14),
                              children: [
                                TextSpan(text: "Don't have an account? "),
                                TextSpan(
                                    text: 'Sign up',
                                    style: TextStyle(
                                        color: _blue,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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

// Recreates the blocky person mark from the reference using simple rectangles.
class _BoringBrand extends StatelessWidget {
  const _BoringBrand();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 82,
          height: 82,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 26,
                child: Container(
                  width: 30,
                  height: 30,
                  color: _ink,
                  alignment: Alignment.center,
                  child: Container(width: 15, height: 15, color: Colors.white),
                ),
              ),
              const Positioned(top: 39, left: 9, child: _PixelBlock(size: 10)),
              const Positioned(top: 39, right: 9, child: _PixelBlock(size: 10)),
              Positioned(
                left: 0,
                bottom: 1,
                child: Container(
                  width: 82,
                  height: 30,
                  color: _ink,
                  alignment: Alignment.topCenter,
                  child: Container(width: 60, height: 17, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text('Boring App',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
      ],
    );
  }
}

class _PixelBlock extends StatelessWidget {
  const _PixelBlock({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) =>
      SizedBox(width: size, height: size, child: const ColoredBox(color: _ink));
}

class _LoginField extends StatelessWidget {
  const _LoginField({required this.label, this.isPassword = false});
  final String label;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 7),
          child: Text(label,
              style: const TextStyle(
                  color: _muted, fontSize: 13, fontWeight: FontWeight.w700)),
        ),
        Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF555555)),
            borderRadius: BorderRadius.circular(9),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              const Expanded(child: SizedBox()),
              if (isPassword)
                const Icon(Icons.visibility_outlined, size: 18, color: _muted),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: Color(0xFF8A8A8A))),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text('OR',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
        Expanded(child: Divider(color: Color(0xFF8A8A8A))),
      ],
    );
  }
}

// These outlined labels are visual examples, not social login actions.
class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.8),
          borderRadius: BorderRadius.circular(6)),
      child: Text(label,
          style: const TextStyle(fontSize: 11, color: Colors.black)),
    );
  }
}

// Screen 2: a static social feed with stories, example posts and a bottom bar.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // Use the screen's full height for the feed and keep navigation below it.
        child: Column(
          children: [
            const _FeedHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                children: const [
                  _PostCard(
                    name: 'Mia Rivera',
                    initials: 'MR',
                    avatarColor: Color(0xFFE4C9B2),
                    likes: '89',
                    caption:
                        'A quiet place by the sea. Taking a moment to enjoy the view.',
                    image: _LandscapePostImage(),
                  ),
                  SizedBox(height: 14),
                  _PostCard(
                    name: 'Sam Kim',
                    initials: 'SK',
                    avatarColor: Color(0xFFD9D7C6),
                    likes: '42',
                    caption:
                        'Simple shapes and thoughtful spaces. Architecture inspiration for today.',
                    image: _ArchitecturePostImage(),
                  ),
                  SizedBox(height: 18),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _FeedBottomBar(),
    );
  }
}

class _FeedHeader extends StatelessWidget {
  const _FeedHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 4),
      child: Column(
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
                          color: _ink))),
              const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.search_rounded, color: _ink)),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const Padding(
                      padding: EdgeInsets.all(8),
                      child:
                          Icon(Icons.notifications_none_rounded, color: _ink)),
                  Positioned(
                      right: 7,
                      top: 7,
                      child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 2),
          const _StoriesRow(),
        ],
      ),
    );
  }
}

class _StoriesRow extends StatelessWidget {
  const _StoriesRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF288CFF), width: 1.5)),
      child: const Row(
        children: [
          Expanded(
              child: _StoryTile(
                  name: 'My profile',
                  initials: '+',
                  color: Color(0xFFE9ECFF),
                  isAdd: true)),
          Expanded(
              child: _StoryTile(
                  name: 'saram_k...', initials: 'S', color: Color(0xFFD7E7D8))),
          Expanded(
              child: _StoryTile(
                  name: 'saram_k...', initials: 'J', color: Color(0xFFEADBD8))),
          Expanded(
              child: _StoryTile(
                  name: 'alex_m...', initials: 'A', color: Color(0xFFDCE5F3))),
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
          radius: 21,
          backgroundColor: color,
          child: Text(initials,
              style: TextStyle(
                  color: isAdd ? _blue : _ink, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 3),
        Text(name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: _ink)),
      ],
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard(
      {required this.name,
      required this.initials,
      required this.avatarColor,
      required this.likes,
      required this.caption,
      required this.image});
  final String name;
  final String initials;
  final Color avatarColor;
  final String likes;
  final String caption;
  final Widget image;

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
                  backgroundColor: avatarColor,
                  child: Text(initials,
                      style: const TextStyle(
                          fontSize: 11,
                          color: _ink,
                          fontWeight: FontWeight.w700))),
              const SizedBox(width: 9),
              Text(name,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700, color: _ink)),
              const Spacer(),
              const Icon(Icons.more_horiz, color: _muted),
            ],
          ),
          const SizedBox(height: 9),
          ClipRRect(borderRadius: BorderRadius.circular(2), child: image),
          const SizedBox(height: 7),
          Row(
            children: [
              const Icon(Icons.favorite_border_rounded,
                  color: Colors.redAccent, size: 19),
              const SizedBox(width: 4),
              Text(likes, style: const TextStyle(fontSize: 12, color: _ink)),
              const SizedBox(width: 12),
              const Icon(Icons.chat_bubble_outline_rounded,
                  size: 18, color: _muted),
              const SizedBox(width: 12),
              const Icon(Icons.open_in_new_rounded, size: 18, color: _muted),
            ],
          ),
          const SizedBox(height: 8),
          Text(caption,
              style: const TextStyle(fontSize: 11, height: 1.35, color: _ink)),
        ],
      ),
    );
  }
}

class _LandscapePostImage extends StatelessWidget {
  const _LandscapePostImage();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 170,
      child: Image.asset('assets/images/learning_landscape.png',
          fit: BoxFit.cover),
    );
  }
}

// A small geometric illustration provides a second sample post without a new package.
class _ArchitecturePostImage extends StatelessWidget {
  const _ArchitecturePostImage();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 170,
      child: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFB8D9EF), Color(0xFFE8EFF2)])),
            ),
          ),
          const Positioned(
              left: 20,
              bottom: 0,
              child:
                  _Building(width: 118, height: 128, color: Color(0xFF9A9FA2))),
          const Positioned(
              right: 22,
              bottom: 0,
              child:
                  _Building(width: 112, height: 98, color: Color(0xFF777F84))),
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

class _FeedBottomBar extends StatelessWidget {
  const _FeedBottomBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 54,
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFFF0EEEE)))),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.home_outlined, color: _blue),
            Icon(Icons.search_rounded, color: _muted),
            Icon(Icons.add_box_outlined, color: _muted),
            Icon(Icons.notifications_none_rounded, color: _muted),
            Icon(Icons.account_circle_outlined, color: _muted),
          ],
        ),
      ),
    );
  }
}
