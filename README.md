# ASA Server Eye

**ASA Server Eye** is a Flutter companion app for **ARK: Survival Ascended** players. The app helps users inspect official server data, open server details and save important servers as favorites.

The project is built as a real release app with a production-oriented Flutter structure, localization, Firebase integration and public support pages.

## Status

```txt
Android release: published
Development: active
Focus: server overview, favorites, future alerts and better server intelligence
```

## Resources

| Resource | URL |
| --- | --- |
| Repository | https://github.com/jchillah/asa-server-eye |
| Privacy Policy | https://jchillah.github.io/asa-server-eye-privacy-policy/ |
| Developer Website | https://jchillah.github.io/jchillah_company_site/ |

## Core Features

- Official ARK: Survival Ascended server overview
- Server search and filtering
- Server detail screen
- Favorites for important servers
- Firebase-backed user functionality
- Localized app text
- Android release preparation
- Privacy policy support

## Planned Features

- Server population alerts
- Favorite server notifications
- Watchlists
- Better server intelligence and trend detection
- Premium alert options
- More advanced filtering and sorting

## Tech Stack

- Flutter
- Dart
- Riverpod
- Dio
- Firebase
- GitHub Pages
- Feature-first project structure

## Architecture

The project follows a feature-first Flutter structure with clear separation between app setup, shared core functionality and individual features.

```txt
lib/
├── app/
├── core/
├── features/
│   ├── auth/
│   ├── servers/
│   ├── favorites/
│   └── settings/
└── l10n/
```

## Development

Install dependencies:

```bash
flutter pub get
```

Run locally:

```bash
flutter run
```

Analyze code:

```bash
flutter analyze
```

Build Android App Bundle:

```bash
flutter build appbundle --release
```

## Development Workflow

1. Create an issue for the feature or fix.
2. Create a feature branch.
3. Implement and test the change.
4. Open a pull request.
5. Review and merge into `main`.

Project board:

```txt
https://github.com/users/jchillah/projects/41
```

## Disclaimer

ASA Server Eye is an independent companion tool and is not affiliated with Studio Wildcard, Snail Games or ARK: Survival Ascended. All trademarks belong to their respective owners.

## Developer

Michael Winkler  
Jchillah’s Design & Coding Forge

```txt
jchillah@gmail.com
```
