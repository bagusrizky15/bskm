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
