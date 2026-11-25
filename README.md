# Boring App — Flutter demo

This phone-friendly Flutter demo includes:

- Sign in, create account, and local password reset screens
- A feed with example posts, search, and profile pages
- Text-only posts or photo posts; Android photo posts appear in the feed and profile
- The pixel-style Boring App mark, theme colors, and bundled font

Account details and new posts are kept in memory for the current app session. There is no server, real authentication, or password-reset email. A built-in demo account is ready to use:

- Email: `demo@boring.app`
- Password: `boring123`

## Run on Android

Start an Android emulator or connect an Android phone with USB debugging enabled. In this folder, run:

```sh
flutter pub get
flutter run
```

The photo picker is connected to Android's system photo chooser. The web build can display the feed, but photo picking is available in the Android app.
