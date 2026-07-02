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
  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;

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
                        onTap: () {
                          context.read<AuthCubit>().resetState();
                          Navigator.pop(context);
                        },
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
                errorText: _nameError,
              ),

              SizedBox(height: 12),

              // Email
              CustomTextField(
                label: 'Email',
                hintText: 'nama@email.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
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
                        color: _phoneError != null
                            ? Colors.red
                            : AppColors.border,
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
                  if (_phoneError != null) ...[
                    SizedBox(height: 5),
                    Text(
                      _phoneError!,
                      style: TextStyle(fontSize: 11, color: Colors.red),
                    ),
                  ],
                ],
              ),

              SizedBox(height: 12),

              // Password
              CustomTextField(
                label: 'Kata Sandi',
                hintText: 'Min. 8 karakter',
                controller: _passwordController,
                obscureText: true,
                showPasswordToggle: true,
                errorText: _passwordError,
              ),

              SizedBox(height: 18),

              // Register button
              BlocConsumer<AuthCubit, AuthState>(
                listenWhen: (previous, current) =>
                    (current is AuthRegisterSuccess ||
                        (current is AuthFailure &&
                            current.operation == AuthOperation.register)) &&
                    previous != current,
                listener: (context, state) {
                  if (state is AuthRegisterSuccess) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Pendaftaran Berhasil'),
                        content: Text(
                          'Silakan login menggunakan email ${state.email}',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              context.read<AuthCubit>().resetState();
                              Navigator.of(context).pushReplacementNamed('/login');
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(
                        SnackBar(
                            content:
                                Text('Pendaftaran gagal: ${state.message}')),
                      );
                  }
                },
                builder: (context, state) {
                  return PrimaryButton(
                    label: 'Daftar Sekarang',
                    isLoading: state is AuthLoading,
                    onPressed: () {
                      setState(() {
                        _nameError = _nameController.text.trim().isEmpty
                            ? 'Nama lengkap tidak boleh kosong'
                            : null;
                        final email = _emailController.text.trim();
                        _emailError = email.isEmpty
                            ? 'Email tidak boleh kosong'
                            : !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                    .hasMatch(email)
                                ? 'Format email tidak valid'
                                : null;
                        _phoneError = _phoneController.text.trim().isEmpty
                            ? 'No. telepon tidak boleh kosong'
                            : null;
                        _passwordError = _passwordController.text.isEmpty
                            ? 'Kata sandi tidak boleh kosong'
                            : null;
                      });
                      if (_nameError != null ||
                          _emailError != null ||
                          _phoneError != null ||
                          _passwordError != null) {
                        return;
                      }
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
                child: GestureDetector(
                  onTap: () {
                    context.read<AuthCubit>().resetState();
                    Navigator.of(context).pop();
                  },
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
