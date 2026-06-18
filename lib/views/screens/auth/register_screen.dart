import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/colors.dart';
import '../../../cubits/auth/auth_cubit.dart';
import '../../../cubits/auth/auth_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  bool _agreeToTerms = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button + title
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.border,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(13),
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buat Akun',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                          letterSpacing: -0.4,
                        ),
                      ),
                      Text(
                        'Daftar untuk mulai menabung',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textGray,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 26),

              // Full name
              CustomTextField(
                label: 'Nama Lengkap',
                hintText: 'Contoh: Budi Santoso',
                controller: _nameController,
              ),

              SizedBox(height: 12),

              // Email
              CustomTextField(
                label: 'Email',
                hintText: 'nama@email.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 12),

              // Phone
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No. Telepon',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textGray,
                      letterSpacing: 0.08,
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.bgSecondary,
                      border: Border.all(
                        color: AppColors.border,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            '+62',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 20,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          color: AppColors.border,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '8XX-XXXX-XXXX',
                              hintStyle: TextStyle(
                                color: AppColors.textLight,
                                fontSize: 14,
                              ),
                              contentPadding: EdgeInsets.only(right: 16),
                            ),
                            style: TextStyle(
                              color: AppColors.textDark,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Password
              CustomTextField(
                label: 'Kata Sandi',
                hintText: 'Min. 8 karakter',
                controller: _passwordController,
                obscureText: true,
              ),

              SizedBox(height: 18),

              // Terms checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() => _agreeToTerms = !_agreeToTerms);
                        },
                        borderRadius: BorderRadius.circular(7),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 13,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Saya menyetujui ',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textGray,
                          height: 1.6,
                        ),
                        children: [
                          TextSpan(
                            text: 'Syarat & Ketentuan',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(text: ' dan '),
                          TextSpan(
                            text: 'Kebijakan Privasi',
                            style: TextStyle(
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

              SizedBox(height: 18),

              // Register button
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    Navigator.of(context).pushReplacementNamed('/home');
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Pendaftaran gagal: ${state.message}')),
                    );
                  }
                },
                builder: (context, state) {
                  return PrimaryButton(
                    label: 'Daftar Sekarang',
                    isLoading: state is AuthLoading,
                    onPressed: () {
                      context.read<AuthCubit>().register(
                        _nameController.text,
                        _emailController.text,
                        _phoneController.text,
                        _passwordController.text,
                      );
                    },
                  );
                },
              ),

              SizedBox(height: 18),

              // Login link
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Sudah punya akun? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textGray,
                    ),
                    children: [
                      TextSpan(
                        text: 'Masuk',
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
