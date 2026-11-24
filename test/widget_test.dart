import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_static_ui_demo/main.dart';

void main() {
  testWidgets('shows login and navigates to the demo feed', (tester) async {
    await tester.pumpWidget(const DemoApp());

    expect(find.text('Email Address'), findsOneWidget);

    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Mia Rivera'), findsOneWidget);
  });
}
