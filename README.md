# Afghan Online Bazaar — Complete Flutter Foundation

**Public app name:** Afghan Online Bazaar / افغان آنلاین بازار  
**Android package:** `com.afghanonlinebazaar.app`  
**Languages:** پښتو + دري/فارسي + English  
**Direction:** RTL for پښتو/دري, LTR for English

## What is included
- Correct Flutter project structure with `android/` at the repository root.
- Android application ID `com.afghanonlinebazaar.app`.
- Firebase Authentication foundation (email/password; phone provider can be enabled in Firebase Console).
- Firestore users, sellers, products, orders, favorites, cart, notifications and reports foundation.
- Firestore security rules with customer/seller/admin ownership checks.
- Seller product creation, approval workflow and optional image upload.
- Admin dashboard with counts and product approval.
- Customer marketplace, search, product details, favorites and cart.
- Basic checkout/order creation with address and phone validation.
- FCM initialization foundation.
- Optional Cloudinary unsigned image upload adapter (no secret is stored in the APK).
- Optional AI backend adapter (private AI keys must stay on your server, never in the APK).
- Three-language UI and saved language selection.
- Codemagic workflows for debug APK, release APK and release AAB.

## Important: what cannot be safely pre-created
This ZIP contains the complete code-side foundation, but it cannot create external accounts or private credentials for you. Before a real public launch, you must connect:
1. Firebase project (already prepared in your case).
2. Firebase Authentication providers and admin account.
3. Cloudinary (or another free image provider) cloud name + unsigned upload preset if image upload is required.
4. Your AI backend URL if AI features are enabled. **Never put an OpenAI/other private API key inside Flutter code.**
5. Android release signing credentials for Play Store/AAB production release.
6. Payment/delivery provider if you later add online payments or a delivery company.

## Image upload
The app uses an optional Cloudinary adapter. It reads:
- `CLOUDINARY_CLOUD_NAME`
- `CLOUDINARY_UPLOAD_PRESET`

Example Codemagic/local build flags:
`--dart-define=CLOUDINARY_CLOUD_NAME=... --dart-define=CLOUDINARY_UPLOAD_PRESET=...`

Use an **unsigned upload preset** for the mobile client. Do not put an API secret in the app.

## AI
The app reads `AI_BASE_URL` and sends requests to `/chat`. Your server should authenticate the user, rate-limit requests and keep the AI provider secret on the server.

## Firebase
`android/app/google-services.json` is included for the configured Android app. Do not replace it with a JSON belonging to another package. The package must remain `com.afghanonlinebazaar.app`.

Firestore rules are in `firestore.rules` and can be deployed from the Firebase CLI or Firebase Console.

## Codemagic
Use `android-debug-apk` first. It creates a test APK for direct installation on an Android phone.

For store release, use `android-release-aab` with proper signing credentials.

If Codemagic says `The "android" directory does not exist`, the GitHub repository is flattened incorrectly. The repository root must look like:

```
AOB-app/
  android/
  assets/
  lib/
  pubspec.yaml
  codemagic.yaml
  firestore.rules
```

## Future upgrades
The project is structured so future versions can add:
- Seller verification and store profiles.
- Full order status flow: Pending, Confirmed, Preparing, Shipped, Delivered, Cancelled.
- Seller order dashboard and sales analytics.
- Delivery zones and delivery fees.
- Payment gateway integration.
- Advanced category/brand filters.
- Push notification campaigns.
- AI product descriptions, seller assistant and customer assistant.
- Recommendation engine.
- Admin reports, complaints and moderation tools.
- Release signing and Play Store deployment.
