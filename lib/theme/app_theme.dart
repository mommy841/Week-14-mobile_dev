import 'package:material_ui/material_ui.dart';

const appInk = Color(0xFF161616);
const appBlue = Color(0xFF6664F5);
const appMuted = Color(0xFF78839A);

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'DemoSans',
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(seedColor: appBlue, primary: appBlue),
  );
}
