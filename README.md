# Beanster Android App OCR Acceptance

This repository is the working Android test/build project for **Beanster Sips** (`com.beanstersips.v11`).

## Current goal

The release gate is intentionally strict: an Android build must run the Beanster OCR path **inside the app**, load the user's original coffee-cup photo, and return `桂花米酿拿铁`. External Python/Tesseract-only success is not accepted as a release pass.

## Repository layout

- `app/` — Gradle Android application used for APK-level acceptance testing.
- `.github/workflows/android-acceptance.yml` — Android emulator acceptance workflow.
- `ci/` — test harness inputs and diagnostics scripts.
- `legacy_source/v17_7/` — public-safe snapshot of the pre-Gradle Beanster V17.7 codebase and regression tests.

## Source/security policy

The historical release keystore is **not** committed. Signing passwords are **not** stored in this repository. The public-safe legacy build script reads signing credentials from environment variables. CI artifacts are debug/unsigned-test builds; final release signing stays local.

Large third-party OCR binaries are fetched from their official upstream sources in CI rather than duplicated in Git history. Historical artwork binaries are not required by the OCR acceptance harness; their mapping/hash information remains documented in the legacy source snapshot.
