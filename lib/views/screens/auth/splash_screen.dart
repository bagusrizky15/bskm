import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/colors.dart';
import '../../../cubits/auth/auth_cubit.dart';
import '../../../cubits/auth/auth_state.dart';
import '../../widgets/app_icons.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _sessionChecked = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _sessionChecked = true);
    await context.read<AuthCubit>().checkSession();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (_, current) => _sessionChecked,
      listener: (context, state) {
        if (state is AuthSuccess) {
          if (state.user.isAdmin) {
            Navigator.of(context).pushReplacementNamed('/admin-home');
          } else {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        } else if (state is AuthInitial) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      },
      child: Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.4, -0.8),
            end: Alignment(1, 1),
            colors: [
              Color(0xFF145214),
              AppColors.primary,
              Color(0xFF43A047),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(41),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(51),
                      blurRadius: 24,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: AppIcons.logo(size: 58),
                ),
              ),
              SizedBox(height: 22),
              Text(
                'Bank Sampah',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.6,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Kelola sampah, raih manfaat',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha(153),
                  letterSpacing: 0.04,
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
