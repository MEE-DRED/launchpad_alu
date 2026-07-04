# ALU Internship Connect

A Flutter + Firebase mobile app connecting ALU students with student-led
startups for internships and collaboration.

> Not a job board — an ecosystem for startup growth, experiential learning, and
> community building within the African Leadership University.

## Tech stack

| Layer | Choice |
|-------|--------|
| Frontend | Flutter (Material 3) |
| Auth | Firebase Authentication (email/password) |
| Database | Cloud Firestore (real-time) |
| Storage | Cloud Storage (CVs, logos, resumes) |
| State | Riverpod |
| Routing | go_router |
| Architecture | Feature-first clean architecture |

## Project structure

```
lib/
├── core/                # cross-cutting concerns
│   ├── constants/       # app + Firestore constants, UserRole
│   ├── error/           # Failure + Firebase error mapping
│   ├── providers/       # app-wide providers (firebaseReady)
│   ├── router/          # go_router config + routes
│   └── theme/           # colours + Material 3 theme
├── features/            # one folder per feature
│   ├── auth/            # data/ + presentation/
│   ├── onboarding/
│   ├── home/
│   ├── opportunities/
│   ├── applications/
│   ├── notifications/
│   ├── profile/
│   └── splash/
├── shared/widgets/      # loading, empty, error states, snackbars
├── app.dart             # root MaterialApp.router
├── bootstrap.dart       # Firebase init (preview-safe)
├── firebase_options.dart# placeholder until `flutterfire configure`
└── main.dart            # entry point + ProviderScope
```

## Getting started

```bash
flutter pub get
flutter run
```

The app runs in **preview mode** until Firebase is configured — see
[`FIREBASE_SETUP.md`](FIREBASE_SETUP.md).

## Implementation phases

- [x] **Phase 1** — Setup, architecture, theming, routing, Riverpod, Firebase scaffolding
- [x] **Phase 2** — Auth & onboarding (register, login, profiles)
- [ ] **Phase 3** — Startups & opportunities (post, browse, search, filter)
- [ ] **Phase 4** — Applications, bookmarks, notifications, real-time
- [ ] **Phase 5** — Admin, security rules, polish, error handling
- [ ] **Phase 6** — Stretch features, tests, demo, technical report

See [`PROJECT_SPEC.md`](PROJECT_SPEC.md) for the full specification.
