# Retail Shop Desktop App (Flutter Frontend)

Flutter desktop/mobile/web frontend for the Retail Shop POS & management system. This repository is configured for a two-developer GitHub workflow with Pull Request enforcement and CI automation.

## 1. Project Architecture

### Repository layout

- `lib/` - Flutter application source
  - `lib/core/` - constants, theme, utilities
  - `lib/models/` - data models
  - `lib/services/` - service/API layer
  - `lib/state/` - application state
  - `lib/ui/` - layouts, responsive helpers, screens, widgets
  - `lib/main.dart` - application entry point
- `test/` - Flutter widget/unit tests
- `android/`, `ios/`, `linux/`, `macos/`, `windows/`, `web/` - platform targets
- `.github/workflows/` - GitHub Actions CI workflows
- `.github/pull_request_template.md` - PR template
- `.github/ISSUE_TEMPLATE/task.md` - task issue template

### Related backend (separate repository/directory)

The backend lives outside this git repository at `../retail_shop_backend` in the local workspace and is a Django/DRF project (`pyproject.toml`, `uv.lock`, `manage.py`, Django apps: `users`, `products`, `inventory`, `invoices`, `receipt`, `transaction`, `notification`). It uses SQLite by default in `config/settings.py` and exposes API routes under `/api/...` with Swagger at `/api/docs/`.

This frontend repo contains a **Backend CI workflow** that checks out the backend repository for PR validation. Because the backend is a separate GitHub repository, the workflow may require a `BACKEND_REPO_TOKEN` secret if the backend repo is private.

## 2. Prerequisites

- Git
- Flutter SDK (stable channel; project currently uses Dart `^3.11.5` per `pubspec.yaml`)
- Dart SDK (bundled with Flutter)
- For Android builds: Android SDK + JDK 17
- For platform-specific builds: relevant platform toolchains (Xcode for iOS/macOS, Visual Studio/C++ workload for Windows, Linux desktop deps for Linux)

Verify:

```bash
git --version
flutter --version
dart --version
```

## 3. Local Development Setup

Clone the repository:

```bash
git clone https://github.com/Segun-Retail/desktop-app.git
cd desktop-app
```

Check your current branch and remotes:

```bash
git branch --show-current
git remote -v
```

> This repository currently uses `master` locally and has `main` on the remote. The team should standardize on **`main`** as the protected production branch. Until that migration is completed, CI workflows trigger on both `main` and `master`.

## 4. Dependency Installation

```bash
flutter pub get
```

## 5. Environment Configuration

This Flutter app currently has no committed `.env` file. If you add environment-specific configuration:

1. Create `.env.example` with non-sensitive placeholder values.
2. Copy it locally: `cp .env.example .env`.
3. Never commit `.env` or secrets.
4. Store production secrets in GitHub Secrets / environment secrets.

`.gitignore` already ignores `.env`, `.env.*` (except `.env.example`), and local databases.

## 6. Running the Frontend

Run on an available device/target:

```bash
flutter devices
flutter run -d <device-id>
```

Common examples:

```bash
flutter run -d linux
flutter run -d chrome
flutter run -d windows
```

## 7. Running the Backend (sibling project)

The backend is not in this repository. If you have the sibling `retail_shop_backend` checked out locally:

```bash
cd ../retail_shop_backend
# Backend uses uv + pyproject.toml
uv sync
uv run python manage.py migrate
uv run python manage.py runserver
```

Backend API docs (when running): `http://127.0.0.1:8000/api/docs/`.

## 8. Running Automated Tests

Frontend checks:

```bash
flutter analyze
flutter test
```

Build validation (Android debug):

```bash
flutter build apk --debug
```

Other build targets as applicable:

```bash
flutter build web
flutter build linux
flutter build windows
```

> Use platform-appropriate runners/hosts: do not build iOS on Linux runners.

## 9. Git Branching Strategy

| Branch | Purpose |
|---|---|
| `main` | Stable, production-ready code. Protected; no direct pushes. |
| `feature/*` | New features |
| `fix/*` | Bug fixes |
| `refactor/*` | Code restructuring without behavior change |
| `docs/*` | Documentation changes |

Rules:

- Developers must **not** push directly to `main`.
- Every task gets its own branch created from the latest `main`.
- Submit a Pull Request before merging into `main`.
- Delete feature/fix/refactor/docs branches after merge.
- Avoid permanent developer-specific branches (e.g., `dev-john`).

## 10. Branch Naming Conventions

```text
feature/<short-description>
fix/<short-description>
refactor/<short-description>
docs/<short-description>
```

Examples:

- `feature/customer-search`
- `fix/invoice-total-rounding`
- `refactor/inventory-service`
- `docs/setup-guide`

## 11. Creating Feature Branches

```bash
git checkout main
git pull origin main
git checkout -b feature/your-task-name
```

If the repository is still using `master` as the default branch, replace `main` with `master` until the migration is complete.

## 12. Committing and Pushing Changes

```bash
git add <specific-files>
git status
git commit -m "feat: short description"
git push -u origin feature/your-task-name
```

Suggested commit prefixes: `feat:`, `fix:`, `refactor:`, `test:`, `docs:`, `chore:`.

Do not commit secrets, `.env` files, credentials, local databases, or generated build artifacts.

## 13. Creating Pull Requests

1. Push your branch to GitHub.
2. Open a PR with **base: `main`** (or `master` until migrated) and **compare: your branch**.
3. Complete `.github/pull_request_template.md`.
4. Ensure CI passes and request review from the other developer.

## 14. Code Review Requirements

- Every change enters `main` through a Pull Request.
- At least **one approval** from another developer is required.
- Developers **cannot approve their own PRs**.
- Automated CI checks must pass.
- Review comments must be addressed before merging.
- PRs must not contain unresolved merge conflicts.

## 15. CI Workflow and What It Checks

### Flutter CI (`.github/workflows/flutter-ci.yml`)

Triggers: PRs to `main`/`master` and pushes to `main`/`master`.

Jobs (platform-aware):
- **Analyze and Test** (ubuntu-latest): `flutter pub get`, `flutter analyze --no-fatal-infos`, `flutter test`
- **Build Android (Debug APK)** (ubuntu-latest): Java 17 + `flutter build apk --debug`; uploads `android-debug-apk` artifact
- **Build Linux** (ubuntu-latest): installs Linux desktop deps + `flutter build linux`; uploads `linux-release-bundle` artifact
- **Build Windows** (windows-latest): `flutter build windows`; uploads `windows-release-bundle` artifact
- **Build iOS (no codesign)** (macos-latest): `flutter build ios --no-codesign`; zips and uploads `ios-unsigned-app` artifact

> iOS builds run on macOS runners and use `--no-codesign` for CI validation (no Apple signing secrets required). Release/signing is handled separately in CD.

**Where to download CI builds:** GitHub repo -> **Actions** -> open the workflow run -> scroll to **Artifacts**. Download `android-debug-apk`, `linux-release-bundle`, `windows-release-bundle`, or `ios-unsigned-app`. Artifacts are retained for 14 days and require GitHub repo access. For public/user-facing downloads, use a Release/CD workflow that attaches assets to GitHub Releases.

### Backend CI (`.github/workflows/backend-ci.yml`)

Triggers: PRs to `main`/`master` and pushes to `main`/`master`.

Checks (in checked-out backend repo):
- Setup Python 3.12 and `uv`
- `uv sync --frozen`
- `python manage.py check`
- `python manage.py makemigrations --check --dry-run`
- `python manage.py test`

**Important:** Backend CI checks out `Segun-Retail/retail_shop_backend`. If that repo is private, configure a repository secret `BACKEND_REPO_TOKEN` (PAT with repo read access) and uncomment the `token:` line in the workflow. Without access, backend CI will fail at checkout.

## 16. CD Workflow and Deployment Process

No deployment workflow is included yet because deployment/hosting details (VPS target, SSH strategy, Flutter release target, signing credentials) are not configured in this repository.

### Recommended CD implementation plan

**Backend (VPS)**:
- Use GitHub Actions environment secrets for SSH host/user/key, app path, and env vars.
- Deploy only from protected `main` after CI passes.
- Steps: SSH to VPS, pull tagged/released commit, install deps (`uv sync --frozen`), run `manage.py migrate` with backup/maintenance plan, collect static files if needed, restart app service (gunicorn/uvicorn/systemd), run health check.
- Document rollback (previous release artifact/commit + DB backup restore procedure).

**Flutter Android**:
- Store keystore/signing secrets in GitHub Secrets; generate signed AAB/APK in CI/CD.
- Publish to Play internal track or GitHub Releases only when credentials are configured.

**Flutter Web**:
- Build with `flutter build web`; deploy to configured host (e.g., Nginx/VPS, Firebase Hosting, S3/CloudFront) via secrets.

**iOS**:
- Requires macOS runner, Apple certificates/profiles, and App Store Connect credentials; do not run on Linux.

## 17. GitHub Repository Protection Settings (Manual Setup)

These settings cannot be fully enforced from code alone. A repository admin should configure them in GitHub:

1. **Settings → Branches / Rules → Rulesets**: create ruleset targeting `main`.
2. Require a pull request before merging.
3. Require at least **1 approval**.
4. Require review from Code Owners (optional, if CODEOWNERS added).
5. Dismiss stale pull request approvals when new commits are pushed.
6. Require conversation resolution before merging.
7. Require status checks to pass before merging. Select the Flutter CI jobs you want required (recommended: `Flutter CI / Analyze and Test`, `Flutter CI / Build Android (Debug APK)`, `Flutter CI / Build Linux`, `Flutter CI / Build Windows`, `Flutter CI / Build iOS (no codesign)`) and `Backend CI / Django Checks and Tests` (after they run at least once).
8. Require branches to be up to date before merging (recommended).
9. Block force pushes and deletions for `main`.
10. Restrict who can push to matching branches; do not allow direct pushes.
11. Do not allow bypassing rules unless the team explicitly accepts admin bypass risk.
12. **Settings → General → Pull Requests**: enable "Automatically delete head branches".
13. **Settings → Actions → General**: allow required actions; review third-party actions.

> Do not assume branch protection is active until verified in GitHub settings.

## 18. How Developers Should Resolve Merge Conflicts

```bash
git checkout main
git pull origin main
git checkout feature/your-task-name
git merge main
# resolve conflicts in files
git add <resolved-files>
git commit -m "merge: resolve conflicts with main"
git push
```

After resolving, re-run local checks (`flutter analyze`, `flutter test`) before requesting re-review.

## 19. Troubleshooting Failed GitHub Actions Workflows

- **Read the failing step logs** in the Actions tab; expand the first red step.
- **Dependency issues**: run `flutter pub get` locally; confirm `pubspec.yaml`/`pubspec.lock` are consistent.
- **Analyze failures**: run `flutter analyze` locally and fix reported issues.
- **Test failures**: run `flutter test` locally; inspect widget/test expectations.
- **Build failures**: reproduce locally with the target build command (`flutter build apk --debug`, `flutter build linux`, `flutter build windows`, or `flutter build ios --no-codesign` on macOS); verify platform toolchains/JDK/Xcode/GTK compatibility.
- **Backend checkout fails**: ensure `Segun-Retail/retail_shop_backend` exists and `BACKEND_REPO_TOKEN` secret is set for private repos.
- **Backend dependency failures**: backend uses `uv sync --frozen`; ensure `uv.lock` is up to date in backend repo.
- **Migration check fails**: run `uv run python manage.py makemigrations --check --dry-run` in backend and commit missing migrations.
- **Missing secrets**: workflows should not require production secrets for CI; CD secrets must be configured in GitHub Environments/Secrets.
- **Path-filtered workflow didn't run**: ensure changed files match workflow `paths` filters; status checks required by branch protection should be configured carefully to avoid "Expected — Waiting for status".

## Team Expectations

- One task, one branch, one PR.
- Keep PRs focused and small.
- No direct pushes to `main`.
- No secrets in code or commits.
- Treat `main` as the source of truth.
