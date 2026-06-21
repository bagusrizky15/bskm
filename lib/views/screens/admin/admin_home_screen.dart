import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/colors.dart';
import '../../../cubits/admin/admin_cubit.dart';
import '../../../cubits/admin/admin_state.dart';
import '../../../cubits/auth/auth_cubit.dart';
import '../../../cubits/auth/auth_state.dart';
import '../../widgets/custom_button.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) {
          final totalUsers = state is AdminLoaded ? state.totalUsers : 0;
          final totalWaste = state is AdminLoaded ? state.totalWaste : 0;

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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0d3b0d), Color(0xFF1B5E20)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '9:41',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withAlpha(230),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.signal_cellular_4_bar,
                          color: Colors.white, size: 16),
                      SizedBox(width: 5),
                      Icon(Icons.wifi, color: Colors.white, size: 14),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(38),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star,
                                color: Color(0xFFFFD700), size: 10),
                            SizedBox(width: 5),
                            Text(
                              'Admin',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withAlpha(230),
                                letterSpacing: 0.06,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Selamat pagi,',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withAlpha(153),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Admin Pusat',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      value: '$totalUsers',
                      label: 'Total Pengguna',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      value: '$totalWaste kg',
                      label: 'Sampah Terkumpul',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminMenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _AdminMenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.09),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Icon(icon, color: AppColors.primary, size: 32),
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(Icons.arrow_forward_ios,
                        color: Colors.white, size: 16),
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

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(31),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withAlpha(38),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withAlpha(140),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
