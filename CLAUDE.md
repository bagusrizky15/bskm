# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get          # install dependencies
flutter run              # run on connected device/emulator
flutter run -d chrome    # run on web
flutter build apk        # build Android APK
flutter test             # run all tests
flutter test test/widget_test.dart  # run single test
flutter analyze          # lint
```

## Architecture

Flutter app ("Bank Sampah" — waste bank management) with Supabase backend and flutter_bloc (Cubit) state management.

**State layer** — `lib/cubits/`: one cubit per domain. Each cubit talks directly to `Supabase.instance.client`. No repository layer. Cubits are all provided globally at the root `MultiBlocProvider` in `main.dart`.

| Cubit | Owns |
|---|---|
| `AuthCubit` | session, login/register, GPS location update |
| `PickupCubit` | user's pickup requests |
| `BalanceCubit` | user's balance + withdrawal requests |
| `AdminCubit` | user list (admin view) |
| `AdminPickupCubit` | all pickups (admin manage) |
| `AdminCategoryCubit` | waste categories CRUD |
| `AdminBalanceCubit` | withdrawal approvals |

**Routing** — named routes in `main.dart`. `SplashScreen` calls `AuthCubit.checkSession()` and pushes to `/home` or `/admin-home` based on `isAdmin`.

**Admin vs user** — same app, same routes. `is_admin` field on the `users` table drives branching. Promote a user to admin via SQL (see `SUPABASE.md`).

## Supabase

Credentials live in `lib/config/env.dart` (hardcoded — no `.env` file). Schema migrations are in `SUPABASE.md` — run each block in order in the Supabase SQL Editor.

Key tables: `users`, `categories`, `pickups`, `balances`, `withdrawals`, `bank_accounts`.

`balances.balance` is a generated column (`total - withdrawn`). Always update `total` or `withdrawn`, never `balance` directly.

RLS is enabled on all tables. Access control uses `public.is_admin()` (SECURITY DEFINER function) to avoid RLS recursion.

## Models

`lib/models/` — plain Dart classes with `fromJson`. No code generation (no `build_runner`). Field names map directly to Supabase column names except `isAdmin` ↔ `is_admin`.
