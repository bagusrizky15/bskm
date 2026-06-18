# Complete Cubit Migration - Ready to Execute

## Files to Update (Copy-Paste Ready)

### 1. lib/main.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/theme.dart';
import 'cubits/auth/auth_cubit.dart';
import 'cubits/home/home_cubit.dart';
import 'cubits/pickup/pickup_cubit.dart';
import 'cubits/admin/admin_cubit.dart';
import 'views/screens/auth/splash_screen.dart';
import 'views/screens/auth/login_screen.dart';
import 'views/screens/auth/register_screen.dart';
import 'views/screens/user/home_screen.dart';
import 'views/screens/user/pickup_screen.dart';
import 'views/screens/user/guide_screen.dart';
import 'views/screens/user/balance_screen.dart';
import 'views/screens/admin/admin_home_screen.dart';
import 'views/screens/admin/admin_pickup_screen.dart';
import 'views/screens/admin/admin_category_screen.dart';
import 'views/screens/admin/admin_balance_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => PickupCubit()),
        BlocProvider(create: (_) => AdminCubit()),
      ],
      child: MaterialApp(
        title: 'Bank Sampah',
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        routes: {
          '/splash': (_) => const SplashScreen(),
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/home': (_) => const HomeScreen(),
          '/pickup': (_) => const PickupScreen(),
          '/guide': (_) => const GuideScreen(),
          '/balance': (_) => const BalanceScreen(),
          '/admin-home': (_) => const AdminHomeScreen(),
          '/admin-pickup': (_) => const AdminPickupScreen(),
          '/admin-category': (_) => const AdminCategoryScreen(),
          '/admin-balance': (_) => const AdminBalanceScreen(),
        },
      ),
    );
  }
}
```

### 2. lib/views/screens/user/pickup_screen.dart
Change imports (lines 1-6):
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/colors.dart';
import '../../../models/waste_model.dart';
import '../../../cubits/pickup/pickup_cubit.dart';
import '../../../cubits/pickup/pickup_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';
```

Change builder section (line ~160):
```dart
child: BlocConsumer<PickupCubit, PickupState>(
  listener: (context, state) {
    if (state is PickupSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Penjemputan berhasil diajukan')),
      );
      Navigator.pop(context);
    } else if (state is PickupFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${state.message}')),
      );
    }
  },
  builder: (context, state) {
    final isSubmitting = state is PickupSubmitting;
    final selectedCategory = state is PickupFormChanged
        ? state.selectedCategory
        : 'Plastik';
    final weight = state is PickupFormChanged
        ? state.weight
        : 2.5;
    final estimatedPrice = state is PickupFormChanged
        ? state.estimatedPrice
        : 6250;
    final selectedDate = state is PickupFormChanged
        ? state.selectedDate
        : DateTime(2026, 6, 20);

    return Column(
      children: [
        // ... rest of UI using local variables above ...
        // Replace all `pickupVm.selectedCategory` → `selectedCategory`
        // Replace all `pickupVm.setCategory()` → `context.read<PickupCubit>().setCategory()`
        // Replace all `pickupVm.isLoading` → `isSubmitting`
```

### 3. lib/views/screens/user/balance_screen.dart
Change imports (lines 1-5):
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/colors.dart';
import '../../../cubits/home/home_cubit.dart';
import '../../../cubits/home/home_state.dart';
import '../../widgets/custom_button.dart';
```

Change build method (line ~12):
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context, state.balance),
                _buildTransactionList(state.balance),
              ],
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    ),
  );
}

Widget _buildHeader(BuildContext context, dynamic balance) {
  // Replace `homeVm.balance.totalBalance` → `balance.totalBalance`
  // Replace all other `homeVm.balance.X` → `balance.X`
```

### 4. lib/views/screens/admin/admin_home_screen.dart
Change imports (lines 1-6):
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/colors.dart';
import '../../../cubits/admin/admin_cubit.dart';
import '../../../cubits/admin/admin_state.dart';
import '../../../cubits/auth/auth_cubit.dart';
import '../../widgets/custom_button.dart';
```

Change build method (line ~12):
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        final totalUsers = state is AdminLoaded ? state.totalUsers : 138;
        final totalWaste = state is AdminLoaded ? state.totalWaste : 52;

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context, totalUsers, totalWaste),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Menu Admin',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 12),
                    _AdminMenuCard(
                      title: 'Penjemputan',
                      subtitle: 'Kelola jadwal & status penjemputan',
                      icon: Icons.local_shipping,
                      onTap: () =>
                          Navigator.pushNamed(context, '/admin-pickup'),
                    ),
                    SizedBox(height: 12),
                    _AdminMenuCard(
                      title: 'Kategori Sampah',
                      subtitle: 'Atur jenis & harga kategori sampah',
                      icon: Icons.category,
                      onTap: () =>
                          Navigator.pushNamed(context, '/admin-category'),
                    ),
                    SizedBox(height: 12),
                    _AdminMenuCard(
                      title: 'Kirim Saldo',
                      subtitle: 'Transfer saldo ke akun pengguna',
                      icon: Icons.account_balance_wallet,
                      onTap: () =>
                          Navigator.pushNamed(context, '/admin-balance'),
                    ),
                    SizedBox(height: 16),
                    BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, authState) {
                        if (authState is AuthLoggedOut) {
                          Navigator.of(context)
                              .pushReplacementNamed('/login');
                        }
                      },
                      builder: (context, authState) {
                        return SecondaryButton(
                          label: 'Keluar',
                          borderColor: Color(0xFFffcdd2),
                          textColor: AppColors.error,
                          onPressed: () {
                            context.read<AuthCubit>().logout();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

Widget _buildHeader(BuildContext context, int totalUsers, int totalWaste) {
  // Replace `adminVm.totalUsers` → `totalUsers`
  // Replace `adminVm.totalWaste` → `totalWaste`
```

### 5. lib/views/screens/admin/admin_pickup_screen.dart
Change imports (lines 1-5):
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/colors.dart';
import '../../../models/waste_model.dart';
import '../../../cubits/admin/admin_cubit.dart';
import '../../../cubits/admin/admin_state.dart';
import '../../widgets/custom_button.dart';
```

Change main build (line ~21):
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context),
          BlocBuilder<AdminCubit, AdminState>(
            builder: (context, state) {
              final pickups = state is AdminLoaded ? state.pickups : [];
              return Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: pickups
                      .map((pickup) => _PickupItem(
                        pickup: pickup,
                        onTap: () => _showPickupDetail(
                          context,
                          pickup,
                        ),
                      ))
                      .toList(),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}
```

Update _showPickupDetail listener:
```dart
void _showPickupDetail(
  BuildContext context,
  WastePickup pickup,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
    ),
    builder: (context) => _PickupDetailSheet(
      pickup: pickup,
    ),
  );
}
```

Update _PickupDetailSheet to use context.read():
```dart
// In approve button:
onPressed: () async {
  context.read<AdminCubit>().confirmPickup(pickup.id);
  Navigator.pop(context);
},

// In reject button:
onPressed: () async {
  context.read<AdminCubit>().rejectPickup(pickup.id);
  Navigator.pop(context);
},
```

## Screens With NO Changes Needed
(Already static - no state management required)
- lib/views/screens/user/guide_screen.dart
- lib/views/screens/admin/admin_category_screen.dart
- lib/views/screens/admin/admin_balance_screen.dart

## Final Steps

1. **Remove old ViewModels** after migration complete:
   ```bash
   rm lib/viewmodels/auth_viewmodel.dart
   rm lib/viewmodels/home_viewmodel.dart
   rm lib/viewmodels/pickup_viewmodel.dart
   rm lib/viewmodels/admin_viewmodel.dart
   rmdir lib/viewmodels
   ```

2. **Verify build**:
   ```bash
   flutter pub get
   flutter build apk --debug
   ```

3. **Test flows**:
   - Login → Home → Pickup flow
   - Admin login → Admin screens
   - Balance view

## Variable Replacement Cheat Sheet

For each screen, replace these systematically:

| Old (ViewModel) | New (Cubit) |
|---|---|
| `pickupVm.selectedCategory` | `selectedCategory` |
| `pickupVm.weight` | `weight` |
| `pickupVm.estimatedPrice` | `estimatedPrice` |
| `pickupVm.selectedDate` | `selectedDate` |
| `pickupVm.isLoading` | `isSubmitting` |
| `pickupVm.setCategory()` | `context.read<PickupCubit>().setCategory()` |
| `pickupVm.setWeight()` | `context.read<PickupCubit>().setWeight()` |
| `pickupVm.setDate()` | `context.read<PickupCubit>().setDate()` |
| `pickupVm.submitPickup()` | `context.read<PickupCubit>().submitPickup()` |
| `homeVm.balance` | `state.balance` (inside HomeLoaded) |
| `adminVm.totalUsers` | `totalUsers` |
| `adminVm.totalWaste` | `totalWaste` |
| `adminVm.pickups` | `state.pickups` (inside AdminLoaded) |
| `adminVm.confirmPickup()` | `context.read<AdminCubit>().confirmPickup()` |
| `adminVm.rejectPickup()` | `context.read<AdminCubit>().rejectPickup()` |
| `authVm.logout()` | `context.read<AuthCubit>().logout()` |

## Architecture After Migration

```
lib/
├── cubits/           ← All state management (Cubit + States)
├── viewmodels/       ← DELETED
├── views/
│   ├── screens/      ← All use BlocBuilder/BlocConsumer
│   └── widgets/      ← No changes needed
├── models/           ← No changes needed
├── config/           ← No changes needed
└── main.dart         ← Uses MultiBlocProvider
```

## Benefits After Migration

✅ More explicit state transitions
✅ Better testability (state-based)
✅ Cleaner separation of concerns
✅ Industry-standard pattern (BLoC)
✅ Easier debugging (state dumps)
✅ Type-safe state transitions

Done! App will be fully migrated to Cubit pattern.
