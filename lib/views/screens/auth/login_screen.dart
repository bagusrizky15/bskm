import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/colors.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
              // Logo
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(77),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(Icons.recycling, color: Colors.white, size: 22),
              ),
              SizedBox(height: 10),
              Text(
                'Bank Sampah',
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

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Lupa kata sandi?',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(height: 28),

              // Login button
              Consumer<AuthViewModel>(
                builder: (context, authVm, _) {
                  return PrimaryButton(
                    label: 'Masuk',
                    isLoading: authVm.isLoading,
                    onPressed: () async {
                      await authVm.login(
                        _emailController.text,
                        _passwordController.text,
                      );
                      if (mounted) {
                        Navigator.of(context).pushReplacementNamed('/home');
                      }
                    },
                  );
                },
              ),

              SizedBox(height: 28),

              // Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Color(0xFFE8F0E8),
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'atau',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Color(0xFFE8F0E8),
                      height: 1,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 28),

              // Google button
              SecondaryButton(
                label: 'Masuk dengan Google',
                onPressed: () {},
                icon: Icons.login,
              ),

              SizedBox(height: 24),

              // Register link
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Belum punya akun? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textGray,
                    ),
                    children: [
                      TextSpan(
                        text: 'Daftar',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
