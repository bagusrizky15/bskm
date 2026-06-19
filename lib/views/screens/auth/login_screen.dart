import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/colors.dart';
import '../../../cubits/auth/auth_cubit.dart';
import '../../../cubits/auth/auth_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bank Sampah',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B5E20),
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                'Karya Mandiri',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B5E20),
                  letterSpacing: -0.2,
                ),
              ),

              SizedBox(height: 36),

              // Heading
              Text(
                'Selamat\nDatang Kembali',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  letterSpacing: -0.6,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Masuk untuk melanjutkan',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textGray,
                ),
              ),

              SizedBox(height: 30),

              // Email field
              CustomTextField(
                label: 'Email',
                hintText: 'nama@email.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 14),

              // Password field
              CustomTextField(
                label: 'Kata Sandi',
                hintText: '••••••••',
                controller: _passwordController,
                obscureText: true,
                showPasswordToggle: true,
              ),

              SizedBox(height: 28),

              // Login button
              BlocConsumer<AuthCubit, AuthState>(
                listenWhen: (previous, current) {
                  if (current is AuthFailure) {
                    return current.operation == AuthOperation.login &&
                        previous != current;
                  }
                  return current is AuthSuccess && previous != current;
                },
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    Navigator.of(context).pushReplacementNamed('/home');
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(
                        SnackBar(
                            content: Text('Login gagal: ${state.message}')),
                      );
                  }
                },
                builder: (context, state) {
                  return PrimaryButton(
                    label: 'Masuk',
                    isLoading: state is AuthLoading,
                    onPressed: () {
                      context.read<AuthCubit>().login(
                        _emailController.text,
                        _passwordController.text,
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 28),

              // Register link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textGray,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushReplacementNamed('/register'),
                      child: Text(
                        'Daftar di sini',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
