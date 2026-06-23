# BSKM

BSKM (Bank Sampah Karya Mandiri) is a waste bank management application built with Flutter. This application helps communities manage waste collection, tracking balances, and scheduling waste pickups efficiently.

## Features

- **User Management**: Register and login for users and administrators
- **Waste Tracking**: Track and categorize different types of waste
- **Balance Management**: Monitor user balances and transactions
- **Pickup Scheduling**: Schedule and manage waste pickup appointments
- **Admin Dashboard**: Comprehensive admin panel for managing the system

## Prerequisites

Before you begin, ensure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.0 or higher)
- [Dart SDK](https://dart.dev/get-dart) (comes with Flutter)
- A code editor (VS Code, Android Studio, or IntelliJ IDEA)
- Git
- A [Supabase](https://supabase.com/) account and project

## Installation

Follow these steps to set up and run the BSKM application:

### 1. Clone the Repository

```bash
git clone https://github.com/bagusrizky15/bskm.git
cd bskm
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Environment Variables

Create the environment configuration file by copying the template:

**Important:** You need to set up your Supabase credentials in the `lib/config/env.dart` file.

The file should already exist at `lib/config/env.dart` with the following structure:

```dart
class Env {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
}
```

**To configure your credentials:**

1. Go to your [Supabase Dashboard](https://app.supabase.com/)
2. Select your project
3. Go to **Settings** → **API**
4. Copy your **Project URL** and **anon/public key**
5. Replace `YOUR_SUPABASE_URL` with your actual Supabase project URL
6. Replace `YOUR_SUPABASE_ANON_KEY` with your actual Supabase anon key

Example:
```dart
class Env {
  static const String supabaseUrl = 'https://xxxxxxxxxxxxx.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
}
```

**Note:** Never commit your actual credentials to version control. The `env.dart` file should be added to `.gitignore`.

### 4. Set Up the Database

You need to run the SQL commands to set up your database tables and policies.

**Important:** Follow the instructions in the [`SUPABASE.md`](SUPABASE.md) file to set up your database.

1. Go to your [Supabase Dashboard](https://app.supabase.com/)
2. Select your project
3. Navigate to **SQL Editor**
4. Open the `SUPABASE.md` file in this repository
5. Execute each SQL block in the order listed:
   - Block 1: Users table + auto-profile on signup
   - Block 2: Categories + Pickups
   - Block 3: Balances + Withdrawals
   - Block 4: Bank Accounts
6. (Optional) Run the admin user setup command if you need to make a user an admin

**Note:** All SQL blocks are idempotent (safe to re-run). If you encounter any errors, you can safely re-execute the blocks.

### 5. Run the Application

For development:

```bash
flutter run
```

To run on a specific device:

```bash
# List available devices
flutter devices

# Run on a specific device
flutter run -d <device_id>
```

### 6. Build for Production

For Android:
```bash
flutter build apk --release
```

For iOS:
```bash
flutter build ios --release
```

For Web:
```bash
flutter build web --release
```

## Troubleshooting

- **"env.dart not found" error:** Make sure you've created the `lib/config/env.dart` file with your Supabase credentials
- **Supabase connection issues:** Verify your URL and anon key are correct
- **Build errors:** Try running `flutter clean` and then `flutter pub get`

## Additional Resources

For Flutter development help:
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter Documentation](https://docs.flutter.dev/)

## Open Source

This project is **open source** and **free for reuse**. You are welcome to use, modify, and distribute this project for personal or commercial purposes. We believe in sharing knowledge and promoting sustainable solutions through technology.

### License

This project is available under the MIT License. Feel free to:
- Use it as a template for your own projects
- Modify and customize it to fit your needs
- Contribute to improve the application
- Share it with others who might benefit from it
