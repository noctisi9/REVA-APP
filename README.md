# REVA

A Flutter app for complex trauma awareness and healing content, with a
Firestore-backed content feed you can update by uploading — no app
rebuild required.

## What's included

- Flutter project scaffold + dark theme (`lib/theme/reva_theme.dart`)
- Google Sign-In auth (`lib/services/auth_service.dart`, `lib/screens/auth_gate.dart`)
- Firestore content model + feed (`lib/models/content_item.dart`, `lib/widgets/content_feed.dart`)
- Discovery / Healing / Community / Saved / Settings tabs (`lib/screens/`)
- Admin-only upload screen, gated by your Firebase UID (`lib/screens/admin_upload_screen.dart`)
- Save-for-later + preset reactions, no free-text comments (`lib/services/user_prefs_service.dart`)
- Report-content flow (writes to a `reports` collection for you to review)
- First-launch disclaimer + crisis resource directory (`lib/widgets/disclaimer_gate.dart`, `lib/screens/resource_directory_screen.dart`)
- Terms / Privacy / Cookies placeholder pages (`lib/screens/legal/`)
- Firestore + Storage Security Rules enforcing admin-only writes (`firebase/`)
- Push notifications on new content via a Cloud Function + FCM topic (`functions/`, `lib/services/push_notification_service.dart`)
- GitHub Actions CI building a release APK (`.github/workflows/flutter-build.yml`)
- Companion website in `website/` — SEO/meta, favicon, mobile menu, cookie
  banner, legal pages, and fixes for a few real issues found in the
  original prototype (see `website/README.md`)

## Setup steps (do these before first run)

**Note:** your `website/index.html` already has a live Firebase project
wired up (project ID `reva-c414f`, with real API keys in its embedded
script). Use that same project for the Flutter app below rather than
creating a new one — that keeps your website sign-in and app sign-in on
one shared user base from day one.

1. **Use your existing Firebase project** (`reva-c414f`) at
   console.firebase.google.com. Enable Firestore and Storage on it if you
   haven't already (Authentication with Google is already set up, per
   the website).
2. **Run `flutterfire configure`** from the project root, pointed at that
   project. This generates `lib/firebase_options.dart`, which isn't
   included here since it's specific to your Firebase project.
3. **Find your admin UID**: sign into the app once with the Google
   account you want as admin, then copy your UID from Firebase Console →
   Authentication → Users.
4. **Replace `REPLACE_WITH_YOUR_FIREBASE_UID`** in all three places:
   - `lib/services/admin_config.dart`
   - `firebase/firestore.rules`
   - `firebase/storage.rules`
5. **Deploy the rules**: `firebase deploy --only firestore:rules,storage:rules`
   (requires the Firebase CLI, logged in and `firebase init` run once
   against this project).
6. **Set your Facebook Page URL** in `lib/screens/home_shell.dart`
   (`kFacebookPageUrl`).
7. **Deploy the notification function**: `cd functions && npm install`,
   then from the project root `firebase deploy --only functions`. This
   is what fires a push notification to everyone whenever you publish
   new content via the admin upload screen — no per-device setup needed
   on your end, the app subscribes each device to the `new_content` topic
   automatically on sign-in.
8. **Set a Firebase budget alert** (Console → Billing) before you go live
   — Firestore/Storage/Functions are pay-as-you-go, and this matters more
   once real users are reading/uploading.

## Still ahead

- Legal pages are placeholder copy — have them reviewed for your
  jurisdiction before public launch.
- Consider moving the resource directory to Firestore later so it can be
  region-specific and updated without a release, same as content items.
- App Check isn't wired up yet — worth adding once you're past internal
  testing, to stop scripted requests hitting Firestore/Storage directly.
- The website's `robots.txt`/`sitemap.xml`/canonical tags use a
  placeholder domain (`reva-app.com`) — swap in your real domain once you
  have one.
- Website legal pages are the same placeholder copy as the app's — have
  one version reviewed and reuse it in both places.
