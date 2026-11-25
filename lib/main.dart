import 'package:material_ui/material_ui.dart';

import 'models/demo_store.dart';
import 'screens/login_page.dart';
import 'theme/app_theme.dart';

void main() => runApp(DemoApp(store: DemoStore()));

class DemoApp extends StatelessWidget {
  const DemoApp({super.key, this.store});

  // Tests can omit the store; the app creates one local demo account by default.
  final DemoStore? store;

  @override
  Widget build(BuildContext context) {
    final appStore = store ?? DemoStore();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Boring App',
      theme: buildAppTheme(),
      home: LoginPage(store: appStore),
    );
  }
}
