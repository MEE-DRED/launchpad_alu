# ALU Internship Connect

A Flutter + Firebase mobile app connecting ALU students with student-led startups for internships and collaboration.

> Not a job board — an ecosystem for startup growth, experiential learning, and community building within the African Leadership University.

Apk link: https://drive.google.com/file/d/1-1LO4tehtOSEa83tuFHiV_OHbzblIDWr/view?usp=sharing

Video Demo: https://drive.google.com/file/d/1ck6OKH7ey24Pizdgw7VPL-LM3bCCZ4Ri/view?usp=sharing

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

## Key features

- **Students:** browse/search/filter opportunities, bookmark, apply, track applications, notifications
- **Startups:** post/edit/delete opportunities, review applicants, update application status
- **Admin:** verify startups (set `role: admin` on a user doc in Firestore)
- **Real-time:** Firestore streams for opportunities, applications, bookmarks, notifications

See [`PROJECT_SPEC.md`](PROJECT_SPEC.md) for the full specification.
