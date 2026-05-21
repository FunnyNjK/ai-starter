# Recipe: React Native (Expo)

Last Updated: 2026-05-21
Applies to: Mobile platform + TypeScript language.

## What this template gives you

A cross-platform mobile app (iOS + Android) built with React
Native via Expo's managed workflow. TypeScript, Expo Router for
navigation, AsyncStorage for local persistence, EAS Build for
producing store-ready binaries. Jest for tests.

## Design philosophy

- **Expo managed workflow first.** Native modules come from
  Expo's curated set. If you outgrow managed (need a custom
  native module Expo doesn't have), use `npx expo prebuild` to
  eject into bare workflow — but that's a one-way migration,
  documented as an ADR when it happens.
- **Expo Router for navigation.** File-system routing inside
  `app/` (similar mental model to Next.js App Router). Stack /
  tab / drawer navigators via the routes themselves, not a
  separate config tree.
- **AsyncStorage for local persistence.** Tiny key-value storage
  that survives app restarts. For larger / structured data,
  upgrade to MMKV or SQLite (Expo SQLite) — but only when you
  outgrow AsyncStorage. Documented as a deviation.
- **No backend in this project.** If the app needs a backend,
  add a separate API project (NestJS / FastAPI / ASP.NET Core)
  via add-project mode. This recipe is mobile-only.
- **EAS Build for binaries.** No local Xcode / Android Studio
  required for builds (only for native module debugging). EAS
  Build runs in the cloud (free tier ≤30 builds/month per
  account).

## Bundled stack (verified versions at init time)

| Component | Choice | Canonical source |
|-----------|--------|------------------|
| Framework | React Native `<X.Y.Z>` (via Expo SDK) | https://www.npmjs.com/package/react-native |
| Toolkit | Expo SDK `<X>` (e.g. SDK 52) | https://www.npmjs.com/package/expo |
| Language | TypeScript `<X.Y.Z>` | https://www.npmjs.com/package/typescript |
| Runtime (dev) | Node.js `<X.Y.Z>` LTS | https://nodejs.org/en/about/previous-releases |
| Package manager | pnpm `<X.Y.Z>` (Expo also supports npm / yarn) | https://www.npmjs.com/package/pnpm |
| Navigation | expo-router `<X.Y.Z>` | https://www.npmjs.com/package/expo-router |
| Persistence | @react-native-async-storage/async-storage `<X.Y.Z>` | https://www.npmjs.com/package/@react-native-async-storage/async-storage |
| HTTP client | fetch (built-in) | n/a |
| Test runner | Jest `<X.Y.Z>` + @testing-library/react-native | https://www.npmjs.com/package/jest |
| Lint | ESLint `<X.Y.Z>` (Expo preset) | https://www.npmjs.com/package/eslint-config-expo |
| Build / distribution | EAS Build + EAS Submit | https://docs.expo.dev/build/introduction/ |

Pin verified versions at init.

## Folder layout

```
projects/<name>/
├── app/                    # Expo Router file-system routes
│   ├── (tabs)/             # tab navigator group
│   ├── _layout.tsx         # root layout
│   └── index.tsx           # home screen
├── components/
├── assets/                 # images, fonts, splash, icon
├── tests/
├── app.json                # Expo config (app name, slug, icons)
├── eas.json                # EAS Build profiles
├── tsconfig.json
├── package.json
├── pnpm-lock.yaml
└── README.md
```

## Local dev story (P1-T1 scaffold target)

1. `pnpm install`
2. `pnpm start` — Expo Dev Server starts; QR code for Expo Go on
   physical devices, plus iOS Simulator / Android Emulator launch
   options.
3. `pnpm lint && pnpm typecheck && pnpm test` — all exit 0.
4. (Build, on demand) `npx eas build --platform ios --profile preview`
   or `--platform android --profile preview` — produces a
   shareable build via EAS.

No docker-compose; no DB. If the app talks to an API in the
solution, the API URL is config (Expo's `app.json` `extra` block
or env-style).

## Free-tier ceilings to record at init

- EAS Build free tier: 30 builds / month per developer account.
  Captured in BUDGET.md "Free-tier and tier choices" with
  escalation path ("upgrade to EAS Build paid plan" or "self-host
  builds").
- Expo Push Notifications free tier: 1M notifications / month
  (very generous). Capture if notifications are part of the app.

## Production handoff (deferred to P3-T0)

For mobile apps, "deploy" = store submission. P3-T0 records:

- Apple Developer Program enrollment (USD $99/year — Cost Rules
  apply).
- Google Play Developer account (USD $25 one-time).
- Code signing setup (EAS Build handles certificates and
  provisioning profiles automatically; record the credential
  storage choice).
- Submission process (`eas submit`) and store-listing copy.
- TestFlight / Play Internal Testing distribution for beta users.

Push notifications: Expo Push or APNs / FCM directly. Documented
at P3-T0 if used.

## When to pick this

- Cross-platform mobile (iOS + Android) with shared TypeScript.
- Team is React-fluent.
- Expo's managed workflow covers your native needs (the curated
  set is large but not infinite).

## When NOT to pick this

- You need native modules not in Expo's curated set → consider
  React Native bare workflow (Custom recipe) or .NET MAUI.
- You're a Microsoft shop → pick .NET MAUI (not in v1.2.0; pick
  Custom).
- You only need iOS or only Android — native (Swift / Kotlin) is
  not supported in v1.2.0. Pick Custom and note the deviation.
