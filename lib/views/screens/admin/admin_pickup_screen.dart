import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/colors.dart';
import '../../../models/waste_model.dart';
import '../../../cubits/admin_pickup/admin_pickup_cubit.dart';
import '../../../cubits/admin_pickup/admin_pickup_state.dart';
import '../../widgets/custom_button.dart';

class AdminPickupScreen extends StatelessWidget {
  const AdminPickupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => context.read<AdminPickupCubit>().loadPickups(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
          children: [
            _buildHeader(context),
            BlocBuilder<AdminPickupCubit, AdminPickupState>(
              builder: (context, state) {
                if (state is AdminPickupFailure) {
                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Error: ${state.message}'),
                  );
                }
                if (state is AdminPickupLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final pickups =
                    state is AdminPickupLoaded ? state.pickups : <WastePickup>[];
                return Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: _buildPickupList(context, pickups),
                  ),
                );
              },
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0d3b0d), Color(0xFF1B5E20)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(38),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.arrow_back,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Penjemputan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'Daftar permintaan masuk',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withAlpha(153),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'Semua',
                      active: true,
                      onTap: () => context.read<AdminPickupCubit>().setFilter(null),
                    ),
                    SizedBox(width: 8),
                    _FilterChip(
                      label: 'Menunggu',
                      active: false,
                      onTap: () =>
                          context.read<AdminPickupCubit>().setFilter(PickupStatus.waiting),
                    ),
                    SizedBox(width: 8),
                    _FilterChip(
                      label: 'Dikonfirmasi',
                      active: false,
                      onTap: () =>
                          context.read<AdminPickupCubit>().setFilter(PickupStatus.confirmed),
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

  List<Widget> _buildPickupList(
    BuildContext context,
    List<WastePickup> pickups,
  ) {
    List<Widget> items = [];
    for (int i = 0; i < pickups.length; i++) {
      final pickup = pickups[i];
      items.add(
        _PickupItem(
          pickup: pickup,
          onTap: () => _showPickupDetail(
            context,
            pickup,
          ),
        ),
      );
      if (i < pickups.length - 1) {
        items.add(SizedBox(height: 10));
      }
    }
    return items;
  }

  void _showPickupDetail(
    BuildContext context,
    WastePickup pickup,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      builder: (context) => _PickupDetailSheet(
        pickup: pickup,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.white.withAlpha(242) : Colors.white.withAlpha(38),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: active
                ? Color(0xFF1B5E20)
                : Colors.white.withAlpha(191),
          ),
        ),
      ),
    );
  }
}

class _PickupItem extends StatelessWidget {
  final WastePickup pickup;
  final VoidCallback onTap;

  const _PickupItem({
    required this.pickup,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(Icons.person,
                      color: AppColors.primary, size: 22),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pickup.userName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${pickup.weight} kg · ${pickup.category}',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textGray,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '${pickup.pickupDate.day} Jun 2026',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusBgColor(pickup.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    pickup.status.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _getStatusColor(pickup.status),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(PickupStatus status) {
    switch (status) {
      case PickupStatus.waiting:
        return Color(0xFFF9A825);
      case PickupStatus.confirmed:
        return AppColors.primary;
      case PickupStatus.rejected:
        return AppColors.error;
      default:
        return AppColors.textGray;
    }
  }

  Color _getStatusBgColor(PickupStatus status) {
    switch (status) {
      case PickupStatus.waiting:
        return Color(0xFFFFF8E1);
      case PickupStatus.confirmed:
        return Color(0xFFE8F5E9);
      case PickupStatus.rejected:
        return Color(0xFFFFEBEE);
      default:
        return AppColors.bgLight;
    }
  }
}

class _PickupDetailSheet extends StatelessWidget {
  final WastePickup pickup;

  const _PickupDetailSheet({
    required this.pickup,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 18),
          Text(
            'Detail Penjemputan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: -0.3,
            ),
          ),
          Text(
            'ID #${pickup.id}',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textGray,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.person, color: AppColors.primary),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pickup.userName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      'Pengguna terdaftar',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textGray,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  pickup.status.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFF9A825),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.bgSecondary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _DetailRow(
                  label: 'Kategori',
                  value: pickup.category,
                ),
                _DetailRow(
                  label: 'Berat',
                  value: '${pickup.weight} kg',
                ),
                _DetailRow(
                  label: 'Estimasi Harga',
                  value: 'Rp ${pickup.estimatedPrice}',
                  valueColor: AppColors.primary,
                ),
                _DetailRow(
                  label: 'Tanggal',
                  value: '${pickup.pickupDate.day} Jun 2026',
                ),
                _DetailRow(
                  label: 'Alamat',
                  value: pickup.address,
                  isLast: pickup.notes == null || pickup.notes!.isEmpty,
                ),
                if (pickup.notes != null && pickup.notes!.isNotEmpty)
                  _DetailRow(
                    label: 'Catatan',
                    value: pickup.notes!,
                    isLast: true,
                  ),
              ],
            ),
          ),
          if (pickup.status == PickupStatus.waiting) ...[
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: 'Tolak',
                    borderColor: Color(0xFFffcdd2),
                    textColor: AppColors.error,
                    onPressed: () {
                      context.read<AdminPickupCubit>().rejectPickup(pickup.id);
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    label: 'Konfirmasi',
                    onPressed: () {
                      context.read<AdminPickupCubit>().confirmPickup(pickup);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isLast;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textGray,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: AppColors.divider,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}

extension on List {
  List dropLast(int count) {
    return sublist(0, (length - count).clamp(0, length));
  }
}
