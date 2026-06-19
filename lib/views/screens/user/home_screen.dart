import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/colors.dart';
import '../../../cubits/auth/auth_cubit.dart';
import '../../../cubits/auth/auth_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/app_icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess && state.user.isAdmin) {
          Navigator.of(context).pushReplacementNamed('/admin-home');
        } else if (state is AuthLoggedOut) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          if (authState is AuthSuccess && authState.user.isAdmin) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Green header
                Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.5, -0.3),
                  end: Alignment(1, 1),
                  colors: [Color(0xFF145214), AppColors.primary],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 18,
                        bottom: 18,
                      ),
                      child: Row(
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
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat pagi,',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withAlpha(166),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            authState is AuthSuccess ? authState.user.name : '',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(36),
                          border: Border.all(
                            color: Colors.white.withAlpha(51),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          backgroundBlendMode: BlendMode.overlay,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: BackdropFilter(
                            filter: ColorFilter.mode(
                              Colors.transparent,
                              BlendMode.overlay,
                            ),
                        child: InkWell(
                          onTap: () => context.read<AuthCubit>().updateLocation(),
                          borderRadius: BorderRadius.circular(18),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(46),
                                    borderRadius:
                                        BorderRadius.circular(13),
                                  ),
                                  child: Center(
                                    child: AppIcons.locationIcon(),
                                  ),
                                ),
                                SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Lokasi Anda',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white
                                              .withAlpha(166),
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.1,
                                          textBaseline:
                                              TextBaseline.alphabetic,
                                        ),
                                      ),
                                      Text(
                                        authState is AuthSuccess
                                            ? authState.user.location
                                            : '',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.my_location,
                                    color: Colors.white.withAlpha(153),
                                    size: 16),
                              ],
                            ),
                          ),
                        ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 28),
                  ],
                ),
              ),
            ),

            // Main menu
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menu Utama',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 14),
                  _MenuCard(
                    icon: AppIcons.truckIcon(),
                    title: 'Jemput Sampah',
                    subtitle: 'Jadwalkan pengambilan sampah',
                    onTap: () =>
                        Navigator.pushNamed(context, '/pickup'),
                  ),
                  SizedBox(height: 12),
                  _MenuCard(
                    icon: AppIcons.guideIcon(),
                    title: 'Panduan Pengiriman',
                    subtitle: 'Cara memilah & mengirim sampah',
                    onTap: () =>
                        Navigator.pushNamed(context, '/guide'),
                  ),
                  SizedBox(height: 12),
                  _MenuCard(
                    icon: AppIcons.balanceIcon(),
                    title: 'Saldo',
                    subtitle: 'Lihat & tarik saldo tabungan',
                    onTap: () =>
                        Navigator.pushNamed(context, '/balance'),
                  ),
                  SizedBox(height: 16),
                  SecondaryButton(
                    label: 'Keluar',
                    borderColor: Color(0xFFffcdd2),
                    textColor: AppColors.error,
                    onPressed: () {
                      context.read<AuthCubit>().logout();
                    },
                  ),
                ],
              ),
            ),
              ],
            ),
          ),
        );
        },
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
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
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(child: icon),
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
                    color: AppColors.bgLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(Icons.arrow_forward_ios,
                        color: AppColors.primary, size: 16),
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
