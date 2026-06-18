# Cubit Migration Guide

## Completed ✅

### Cubits Created
- `lib/cubits/auth/auth_cubit.dart` - Login, Register, Admin Login, Logout
- `lib/cubits/auth/auth_state.dart` - AuthInitial, AuthLoading, AuthSuccess, AuthFailure, AuthLoggedOut
- `lib/cubits/home/home_cubit.dart` - Load balance, refresh, withdraw
- `lib/cubits/home/home_state.dart` - HomeInitial, HomeLoading, HomeLoaded, HomeFailure
- `lib/cubits/pickup/pickup_cubit.dart` - Manage form state, submit pickup
- `lib/cubits/pickup/pickup_state.dart` - PickupInitial, PickupFormChanged, PickupSubmitting, PickupSuccess, PickupFailure
- `lib/cubits/admin/admin_cubit.dart` - Load pickups, filter, confirm, reject
- `lib/cubits/admin/admin_state.dart` - AdminInitial, AdminLoaded, AdminLoading, AdminFailure

### Main.dart Updated
- Replaced `Provider` with `flutter_bloc`
- Changed `MultiProvider` to `MultiBlocProvider`
- All cubits now registered via `BlocProvider`
- All routes preserved

### Screens Updated
1. **LoginScreen** - ✅ BlocConsumer for login button
2. **RegisterScreen** - ✅ BlocConsumer for register button
3. **HomeScreen** - ✅ BlocBuilder for admin auto-redirect, logout button uses context.read()

## Remaining Screens to Update

### Pattern for Remaining Screens

Replace:
```dart
import 'package:provider/provider.dart';
import '../../../viewmodels/XViewModel.dart';

Consumer<XViewModel>(
  builder: (context, viewModel, _) {
    return ...
  }
)
```

With:
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubits/x/x_cubit.dart';
import '../../../cubits/x/x_state.dart';

BlocBuilder<XCubit, XState>(
  builder: (context, state) {
    return ...
  }
)

// OR for state changes (like navigation)

BlocConsumer<XCubit, XState>(
  listener: (context, state) {
    if (state is StateSuccess) {
      // Handle navigation or snackbar
    }
  },
  builder: (context, state) {
    return ...
  }
)

// For accessing cubit directly:
context.read<XCubit>().method()
```

## Screens Needing Updates

### User Screens
1. **PickupScreen**
   - Replace `Consumer<PickupViewModel>` with `BlocBuilder<PickupCubit, PickupState>`
   - Form state access: `state is PickupFormChanged ? state.selectedCategory : default`
   - Submit: `context.read<PickupCubit>().submitPickup()`

2. **BalanceScreen**
   - Replace `Consumer<HomeViewModel>` with `BlocBuilder<HomeCubit, HomeState>`
   - Balance data: `state is HomeLoaded ? state.balance : null`

3. **GuideScreen**
   - No state needed (static screen) - No changes required

### Admin Screens
4. **AdminHomeScreen**
   - Replace `Consumer<AdminViewModel>` with `BlocBuilder<AdminCubit, AdminState>`
   - Stats: `state is AdminLoaded ? state.totalUsers : 0`
   - Logout: `context.read<AuthCubit>().logout()`

5. **AdminPickupScreen**
   - Replace `Consumer<AdminViewModel>` with `BlocBuilder<AdminCubit, AdminState>`
   - List: `state is AdminLoaded ? state.pickups : []`
   - Actions: `context.read<AdminCubit>().confirmPickup(id)`

6. **AdminCategoryScreen**
   - No state needed (mock list) - Can keep static or add cubit later

7. **AdminBalanceScreen**
   - No state needed (mock list) - Can keep static or add cubit later

## Example Conversion

### Before (ViewModel + Provider)
```dart
Consumer<PickupViewModel>(
  builder: (context, pickupVm, _) {
    return Column(
      children: [
        Text(pickupVm.selectedCategory),
        Text('Rp ${pickupVm.estimatedPrice}'),
        PrimaryButton(
          isLoading: pickupVm.isLoading,
          onPressed: () async {
            await pickupVm.submitPickup(name, address, notes);
          },
        ),
      ],
    );
  }
)
```

### After (Cubit + flutter_bloc)
```dart
BlocConsumer<PickupCubit, PickupState>(
  listener: (context, state) {
    if (state is PickupSuccess) {
      Navigator.pop(context);
    } else if (state is PickupFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message))
      );
    }
  },
  builder: (context, state) {
    final isSubmitting = state is PickupSubmitting;
    final selectedCategory = state is PickupFormChanged
        ? state.selectedCategory
        : 'Plastik';
    final estimatedPrice = state is PickupFormChanged
        ? state.estimatedPrice
        : 0;

    return Column(
      children: [
        Text(selectedCategory),
        Text('Rp $estimatedPrice'),
        PrimaryButton(
          isLoading: isSubmitting,
          onPressed: () {
            context.read<PickupCubit>().submitPickup(name, address, notes);
          },
        ),
      ],
    );
  }
)
```

## Dependencies Updated
- Removed: `provider: ^6.0.0`
- Added: 
  - `flutter_bloc: ^8.1.0`
  - `equatable: ^2.0.0`

## Testing After Migration

1. Run tests: `flutter test`
2. Build APK: `flutter build apk --debug`
3. Test flows:
   - Login → Home → Pickup → Submit
   - Home → Balance → View Transactions
   - Login as Admin → Admin Home → Manage Pickups
   - Navigation between screens

## Key Differences: ViewModel vs Cubit

| Aspect | ViewModel | Cubit |
|--------|-----------|-------|
| State Management | ChangeNotifier | emit() |
| Widget Integration | Consumer/Provider | BlocBuilder/BlocConsumer |
| State Classes | Single mutable | Multiple immutable |
| Readability | Imperative | Declarative |
| Boilerplate | Less | More (state classes) |
| Testability | Good | Excellent (state-driven) |

## Benefits of Cubit
✅ More explicit state transitions
✅ Better for complex state management
✅ Easier to test (state-based)
✅ Cleaner separation of concerns
✅ Industry standard (BLoC pattern)
✅ Better for large teams

## Files to Delete (After Migration)
Once all screens are updated, delete old ViewModels:
- `lib/viewmodels/auth_viewmodel.dart`
- `lib/viewmodels/home_viewmodel.dart`
- `lib/viewmodels/pickup_viewmodel.dart`
- `lib/viewmodels/admin_viewmodel.dart`
