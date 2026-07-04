# Firebase Setup — ALU Internship Connect

Firebase is configured for this project.

| Item | Status |
|------|--------|
| Project ID | `room-12-a26c7` |
| Android app | `com.alu.launchpad_alu` |
| `firebase_options.dart` | Generated via FlutterFire CLI |
| `google-services.json` | Present in `android/app/` |
| Gradle plugin | `com.google.gms.google-services` applied |

## Enable these in the Firebase Console

If not done already:

1. **Authentication** → Sign-in method → enable **Email/Password**
2. **Firestore Database** → Create database (test mode is fine for development)
3. **Storage** → Get started (required for CV, logo, and profile photo uploads)

## Reconfigure (optional)

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

## Firestore collections used by the app

- `users` — student/startup/admin profiles
- `startups` — startup organisation profiles
- `opportunities` — Phase 3
- `applications` — Phase 4
- `bookmarks`, `notifications`, `messages` — later phases

Security rules will be added in Phase 5.
