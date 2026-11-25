# Contributing Guide

This project is maintained by a two-developer team. All changes must go through Pull Requests and pass CI before merging into `main`.

## Core Rules

- **No direct pushes to `main`**.
- One task = one branch = one PR.
- Keep PRs focused and reviewable.
- Never commit secrets, credentials, `.env` files, or local databases.
- Do not approve your own PR.

## Branching Strategy

| Branch | Purpose |
|---|---|
| `main` | Stable, production-ready code |
| `feature/*` | New features |
| `fix/*` | Bug fixes |
| `refactor/*` | Code restructuring |
| `docs/*` | Documentation changes |

Create branches from the latest `main`:

```bash
git checkout main
git pull origin main
git checkout -b feature/short-description
```

Branch naming examples:

- `feature/product-search`
- `fix/invoice-total`
- `refactor/inventory-state`
- `docs/api-setup`

## Development Workflow

1. **Sync main**
   ```bash
   git checkout main
   git pull origin main
   ```
2. **Create task branch**
   ```bash
   git checkout -b feature/your-task
   ```
3. **Implement and test locally**
   ```bash
   flutter pub get
   flutter analyze --no-fatal-infos
   flutter test
   # Platform build validation as relevant:
   flutter build apk --debug        # Android
   flutter build windows            # Windows
   flutter build ios --no-codesign  # iOS (macOS only)
   ```
4. **Commit focused changes**
   ```bash
   git add <files>
   git commit -m "feat: describe change"
   ```
5. **Push and open PR**
   ```bash
   git push -u origin feature/your-task
   ```
   Open a PR targeting `main`, complete the PR template, and request review.
6. **Address review feedback** on the same branch; push updates.
7. **Merge after approval + green CI**. Delete the branch after merge.

## Commit Message Conventions

Use clear, imperative messages:

- `feat: add customer search`
- `fix: correct invoice total calculation`
- `refactor: simplify inventory service`
- `test: add billing widget coverage`
- `docs: update setup instructions`
- `chore: update CI workflow`

## Pull Request Requirements

Before requesting review:

- [ ] PR description is complete (what/why/how/testing).
- [ ] `flutter analyze` passes locally.
- [ ] `flutter test` passes locally.
- [ ] Relevant platform build checks pass (Android/Windows/iOS as applicable).
- [ ] No secrets or unrelated files included.
- [ ] No unresolved merge conflicts.

Before merging:

- [ ] At least one approval from another developer.
- [ ] All required CI checks pass.
- [ ] Review comments addressed.

## Resolving Merge Conflicts

```bash
git checkout main
git pull origin main
git checkout your-branch
git merge main
# resolve conflicts
git add <resolved-files>
git commit -m "merge: resolve conflicts with main"
git push
```

Re-run tests after resolving conflicts.

## CI Expectations

GitHub Actions runs on PRs targeting `main`/`master` and pushes to `main`/`master`.

- **Flutter CI**: analyze/test + platform builds - Android (`apk --debug`), Windows (`build windows`), iOS (`build ios --no-codesign` on macOS).
- **Backend CI**: checks out backend repo and runs Django checks, migration check, and tests via `uv`.

Do not merge if required checks fail. If CI fails, inspect logs in the GitHub Actions tab, reproduce locally, fix, and push.

## Secrets and Environment Safety

- Keep secrets in GitHub Secrets/environment secrets, never in git.
- Use `.env.example` for non-sensitive placeholders.
- Do not hardcode API keys, passwords, or tokens.
- Rotate any credential accidentally exposed.

## Code Style

- Follow existing Dart/Flutter conventions and `analysis_options.yaml` (`flutter_lints`).
- Keep changes minimal and consistent with surrounding code.
- Add comments only when necessary; prefer clear code.

## Getting Help

- Open a task issue using `.github/ISSUE_TEMPLATE/task.md`.
- For CI failures, include the failing workflow/job/step and relevant log excerpt in the PR discussion.
