# Changelog

All notable changes to MealBox will be documented in this file.

## [1.3.0] - Unreleased
### ✨ Features & Redesign
- **Full Localization (i18n):** The app now natively supports English and German. All hardcoded texts have been removed and notifications are translated dynamically.
- **Anti-Slop Redesign:** Introduced a modern, clean, and low-stimulus design. Standardized squircle shapes, removed harsh drop shadows in favor of subtle borders, and improved color contrast.
- **Therapy Export:** Added a new feature to export meal logs as PDF and CSV for therapists or doctors.

### 🐛 Bugfixes
- Fixed parameter types in `CardTheme` and `DialogTheme`.

---

## [1.1.1] - Hotfix
### 🐛 Bugfixes
- Fixed a RenderFlex overflow in `MealDialog`.
- Improved dark mode contrast.
- Fixed the positioning of the medication toggle.

---

## [1.1.0] - Mega-Update (Neurodivergent Update)
### ✨ Features
- **Medication Tracking:** Added the ability to log medication intake alongside meals.
- **SOS Button:** Emergency button on the home screen with fallback tips (e.g., peanut butter or water) for extremely low-energy days.
- **Photo Diary:** Images of meals can now be saved directly in the app.
- **Weekly Stats:** Visual evaluation of logs including "streaks" to build motivation.
- **Water Tracking & Safe Foods:** Improved hydration overview and a dedicated list for "Safe Foods".
- **Custom Meals:** Added the ability to customize meal names.
- **Simple Mode:** Extremely simplified mode ("Low-executive-function logging") for days with minimal energy.
- **Data Backup:** Full export/import functionality for all local data (Hive), including water, safe foods, and settings.
- **Homescreen Widget:** Quick logging directly from the home screen.
- **Dark Mode:** Fully implemented dark mode design.

### 🐛 Bugfixes
- Resolved Hive Lock Collisions when the homescreen widget was executed in the background (routing via IsolateNameServer).
- Made `home_widget` registration non-blocking and added a global failsafe screen for startup errors.
- Fixed auto-updating of the home screen after changes in settings.
- Fixed crashes caused by faulty notification permission requests (PlatformException).

---

## [1.0.1+4] - F-Droid Compliance Update
### 🔧 Maintenance & Open Source
- **License Update:** Changed from MIT to GPLv3 license.
- **F-Droid Compatibility:** Added `distributionSha256Sum` to Gradle wrapper configuration.
- **Fastlane:** Added F-Droid fastlane metadata and screenshots for `en-US` and `de-DE`.
- Added ProGuard rules to prevent R8 from obfuscating `flutter_local_notifications` and `Gson`.
- Enabled "Core Library Desugaring" for `flutter_local_notifications`.

### 🐛 Bugfixes
- Permissions (POST_NOTIFICATIONS) are now requested directly at app startup instead of only in the settings menu.

---

## [1.0.0] - Initial Release
### ✨ Features
- **MealBox:** Initial release of the simple and low-stimulus meal tracker for neurodivergent people.
- Custom Time Selection: Ability to log past meals with custom times.
- Creation of store assets and app icons.
- Full CI/CD pipeline (GitHub Actions) for automated APK builds and releases.
- Configured keystore for app signing.
