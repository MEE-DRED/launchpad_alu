# ALU Internship Connect

A Flutter + Firebase mobile app connecting ALU students with student-led startups for internships and collaboration.

> Not a job board — an ecosystem for startup growth, experiential learning, and community building within the African Leadership University.

## Tech stack

| Layer | Choice |
|-------|--------|
| Frontend | Flutter (Material 3) |
| Auth | Firebase Authentication (email/password) |
| Database | Cloud Firestore (real-time) |
| Storage | Cloudinary (URLs in Firestore) |
| State | Riverpod |
| Routing | go_router |
| Architecture | Feature-first clean architecture |

## Getting started

```bash
flutter pub get
flutter run
```

See [`FIREBASE_SETUP.md`](FIREBASE_SETUP.md) for Firebase console setup and [`firebase/firestore.rules`](firebase/firestore.rules) for security rules.

## Implementation phases

- [x] **Phase 1** — Setup, architecture, theming, routing, Riverpod, Firebase
- [x] **Phase 2** — Auth & onboarding (register, login, profiles)
- [x] **Phase 3** — Startups & opportunities (post, browse, search, filter)
- [x] **Phase 4** — Applications, bookmarks, notifications, real-time
- [x] **Phase 5** — Admin verification, security rules, polish patterns
- [ ] **Phase 6** — Demo video, technical report, UI refinement (see [`UI_SCREENSHOTS.md`](UI_SCREENSHOTS.md))

## Key features

- **Students:** browse/search/filter opportunities, bookmark, apply, track applications, notifications
- **Startups:** post/edit/delete opportunities, review applicants, update application status
- **Admin:** verify startups (set `role: admin` on a user doc in Firestore)
- **Real-time:** Firestore streams for opportunities, applications, bookmarks, notifications

See [`PROJECT_SPEC.md`](PROJECT_SPEC.md) for the full specification.
