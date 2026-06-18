import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/pickup_viewmodel.dart';
import 'viewmodels/admin_viewmodel.dart';
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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => PickupViewModel()),
        ChangeNotifierProvider(create: (_) => AdminViewModel()),
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
