# Retail Shop Desktop App (Flutter Frontend)

Flutter frontend for the Retail Shop POS & management system. This repository contains the client application and its GitHub collaboration/CI configuration.

## 1. Project Architecture

- `lib/` - Flutter application source
  - `lib/core/` - constants, theme, utilities
  - `lib/models/` - data models
  - `lib/services/` - service/API layer
  - `lib/state/` - application state
  - `lib/ui/` - layouts, responsive helpers, screens, widgets
  - `lib/main.dart` - application entry point
- `test/` - Flutter widget/unit tests
- `android/`, `ios/`, `linux/`, `macos/`, `windows/`, `web/` - platform targets
- `.github/workflows/flutter-ci.yml` - Flutter CI workflow
- `.github/pull_request_template.md` - PR template
- `.github/ISSUE_TEMPLATE/task.md` - task issue template

## 2. Prerequisites

- Git
- Flutter SDK (stable channel; project currently uses Dart `^3.11.5` per `pubspec.yaml`)
- Dart SDK (bundled with Flutter)
- For Android builds: Android SDK + JDK 17
- For platform-specific builds:
  - Linux: GTK/CMake/Ninja/clang/pkg-config deps
  - Windows: Visual Studio with Desktop development with C++
  - iOS/macOS: Xcode on macOS
  - Web: Chrome/browser tooling

Verify:

```bash
git --version
flutter --version
dart --version
flutter doctor
```

## 3. Local Development Setup

Clone the repository:

```bash
git clone https://github.com/Segun-Retail/desktop-app.git
cd desktop-app
```

Install dependencies:

```bash
flutter pub get
```

## 4. Environment Configuration

This app currently has no committed `.env` file. If you add environment-specific configuration:

1. Create `.env.example` with non-sensitive placeholder values.
2. Copy it locally: `cp .env.example .env`.
3. Never commit `.env` or secrets.
4. Store CI/CD secrets in GitHub Secrets / environment secrets.

`.gitignore` ignores `.env`, `.env.*` (except `.env.example`), local databases, and build artifacts.

## 5. Running the App

List available devices/targets:

```bash
flutter devices
```

Run on a target:

```bash
flutter run -d <device-id>
```

Examples:

```bash
flutter run -d linux
flutter run -d windows
flutter run -d chrome
flutter run -d android
```

> Use platform-appropriate hosts/runners: iOS/macOS builds require macOS; Windows builds require Windows.

## 6. Running Automated Tests and Checks

```bash
flutter analyze --no-fatal-infos
flutter test
```

Platform build validation (as applicable):

```bash
flutter build apk --debug        # Android
flutter build linux              # Linux
flutter build windows            # Windows
flutter build ios --no-codesign  # iOS (macOS only)
flutter build web                # Web
```

## 7. Git Branching Strategy

| Branch | Purpose |
|---|---|
| `main` | Stable, production-ready code. Protected; no direct pushes. |
| `feature/*` | New features |
| `fix/*` | Bug fixes |
| `refactor/*` | Code restructuring without behavior change |
| `docs/*` | Documentation changes |

Rules:

- Do **not** push directly to `main`.
- Create every task branch from the latest `main`.
- Submit a Pull Request before merging into `main`.
- Delete task branches after merge.
- Avoid permanent developer-specific branches.

## 8. Branch Naming Conventions

```text
feature/<short-description>
fix/<short-description>
refactor/<short-description>
docs/<short-description>
```

Examples: `feature/customer-search`, `fix/invoice-total-rounding`, `refactor/inventory-service`, `docs/setup-guide`.

## 9. Creating Feature Branches

```bash
git checkout main
git pull origin main
git checkout -b feature/your-task-name
```

## 10. Committing and Pushing Changes

```bash
git add <specific-files>
git status
git commit -m "feat: short description"
git push -u origin feature/your-task-name
```

Suggested prefixes: `feat:`, `fix:`, `refactor:`, `test:`, `docs:`, `chore:`.

Do not commit secrets, `.env` files, credentials, local databases, or generated build artifacts.

## 11. Creating Pull Requests

1. Push your branch to GitHub.
2. Open a PR with **base: `main`** and **compare: your branch**.
3. Complete `.github/pull_request_template.md`.
4. Ensure CI passes and request review from another developer.

## 12. Code Review Requirements

- Every change enters `main` through a Pull Request.
- At least **one approval** from another developer is required.
- Developers **cannot approve their own PRs**.
- Required CI checks must pass.
- Review comments must be resolved before merging.
- PRs must not contain unresolved merge conflicts.

## 13. CI Workflow and What It Checks

### Flutter CI (`.github/workflows/flutter-ci.yml`)

Triggers: PRs to `main`/`master` and pushes to `main`/`master`.

Jobs:

- **Analyze and Test** (ubuntu-latest): `flutter pub get`, `flutter analyze --no-fatal-infos`, `flutter test`
- **Build Android (Debug APK)** (ubuntu-latest): Java 17 + `flutter build apk --debug`; uploads `android-debug-apk`
- **Build Linux** (ubuntu-latest): installs Linux desktop deps + `flutter build linux`; uploads `linux-release-bundle`
- **Build Windows** (windows-latest): `flutter build windows`; uploads `windows-release-bundle`
- **Build iOS (no codesign)** (macos-latest): `flutter build ios --no-codesign`; uploads `ios-unsigned-app`

> iOS CI uses `--no-codesign` for validation (no Apple signing secrets required). Android CI builds a debug APK. Release/signing is handled separately in CD.

### Where to Download CI Builds

GitHub repo -> **Actions** -> open the workflow run -> **Artifacts**. Download the artifact for your platform. Artifacts are retained for 14 days and require GitHub repo access.

For public/user-facing downloads, use a Release/CD workflow that attaches signed/release assets to GitHub Releases.

## 14. CD Workflow and Deployment Process

No deployment workflow is included yet because release targets, signing credentials, and distribution channels are not configured.

Recommended CD plan:

- **Android**: store keystore/signing secrets in GitHub Secrets; build signed AAB/APK; publish to Play internal track or GitHub Releases.
- **iOS**: requires macOS runner, Apple certificates/profiles, and App Store Connect credentials.
- **Windows/Linux**: build release bundles/installers; attach to GitHub Releases or distribute via chosen channel.
- **Web**: `flutter build web`; deploy to configured hosting (Firebase Hosting, S3/CloudFront, Nginx, etc.).

Do not publish releases automatically without required credentials and explicit deployment requirements.

## 15. GitHub Repository Protection Settings

A repository admin should configure:

1. Ruleset targeting `main`.
2. Require pull request before merging.
3. Require at least 1 approval.
4. Dismiss stale approvals on new commits.
5. Require conversation resolution.
6. Require status checks: `Flutter CI / Analyze and Test`, `Build Android (Debug APK)`, `Build Linux`, `Build Windows`, `Build iOS (no codesign)` (and any other required checks your org uses).
7. Require branches up to date before merging.
8. Block force pushes and deletions.
9. Restrict direct pushes.
10. Enable automatic deletion of head branches.

> Do not assume branch protection is active until verified in GitHub settings.

## 16. Resolving Merge Conflicts

```bash
git checkout main
git pull origin main
git checkout feature/your-task-name
git merge main
# resolve conflicts
git add <resolved-files>
git commit -m "merge: resolve conflicts with main"
git push
```

Re-run `flutter analyze --no-fatal-infos` and `flutter test` after resolving conflicts.

## 17. Troubleshooting Failed GitHub Actions

- **Read the failing step log** in Actions; expand the first red step.
- **Dependencies**: run `flutter pub get`; confirm `pubspec.yaml`/`pubspec.lock`.
- **Analyze**: run `flutter analyze --no-fatal-infos`.
- **Tests**: run `flutter test` locally.
- **Build failures**: reproduce the target build locally (`flutter build apk --debug`, `flutter build linux`, `flutter build windows`, `flutter build ios --no-codesign`); check platform toolchains/JDK/Xcode/GTK.
- **Missing secrets**: CI should not require production secrets; CD secrets belong in GitHub Secrets/Environments.
- **Required check waiting**: ensure ruleset status check names match actual workflow job names.

## Team Expectations

- One task, one branch, one PR.
- Keep PRs focused and small.
- No direct pushes to `main`.
- No secrets in code or commits.
- Treat `main` as the source of truth.
