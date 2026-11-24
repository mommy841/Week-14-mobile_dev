# Boring App — Flutter static UI demo

A beginner-friendly Flutter project with exactly two screens:

1. Login — a simple static sign-in page with the recreated pixel logo.
2. Feed — a phone-sized social page with stories, sample posts, and a bottom icon bar.

The Log in button only navigates to the feed. The fields and social sign-in labels are visual placeholders; there is no authentication, data storage, or other app behavior.

## Topics demonstrated

Static Flutter widgets with `Scaffold`, `Container`, `Text`, and buttons
`Row`, `Column`, sizing, and spacing
`Stack` and `Positioned` for the logo and sample architecture image
Organized image and font assets, displayed with `Image.asset`
A bundled Segoe UI font registered in `pubspec.yaml`
Shared colors and typography through `ThemeData`

## Run

From this folder, install the project packages and start the app on a connected
device or emulator:

```sh
flutter run -d web-server 


For Android, start an emulator from Android Studio's Device Manager or connect
an Android phone with USB debugging enabled, then run `flutter run`. To see
available devices, run `flutter devices`.

To open the web version, run `flutter run -d chrome`.
