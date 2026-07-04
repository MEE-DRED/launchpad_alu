# Cloudinary Setup — Launchpad ALU

The app uses **Cloudinary** for file uploads (profile photos, CVs, resumes, startup logos). Only the **secure URL** is saved in Firestore — no Firebase Storage.

## 1. Create a Cloudinary account

Sign up at [cloudinary.com](https://cloudinary.com) (free tier is enough for development).

## 2. Create an unsigned upload preset

1. Open **Settings → Upload**
2. Click **Add upload preset**
3. Set **Signing mode** to **Unsigned**
4. Save and note the **preset name** (e.g. `launchpad_unsigned`)

## 3. Add credentials to the app

Edit `lib/core/config/cloudinary_config.dart`:

```dart
static const String cloudName = 'x8k2dmzk';      // from Cloudinary dashboard
static const String uploadPreset = 'launchpad_unsigned'; // your preset name
```

## 4. Hot restart the app

```bash
flutter run
```

Uploads go to folders like `launchpad_alu/profile_images/{uid}/`.

## What gets stored where

| File | Cloudinary folder | Firestore field |
|------|-------------------|-----------------|
| Profile photo | `profile_images/{uid}` | `users.profileImageUrl` |
| CV | `cvs/{uid}` | `users.cvUrl` |
| Resume (apply) | `resumes/{uid}` | `applications.resumeUrl` |
| Startup logo | `logos/{uid}` | `startups.logoUrl` |

Firestore only stores the URL string — Cloudinary holds the actual file.

## Optional uploads

If Cloudinary is not configured yet, onboarding still works **without** photos/CVs. Apply flow falls back to the CV URL from the student profile if no new resume is uploaded.
