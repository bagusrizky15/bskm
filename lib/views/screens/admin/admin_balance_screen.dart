import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/colors.dart';
import '../../../cubits/admin_balance/admin_balance_cubit.dart';
import '../../../cubits/admin_balance/admin_balance_state.dart';
import '../../widgets/custom_button.dart';

class AdminBalanceScreen extends StatelessWidget {
  const AdminBalanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AdminBalanceCubit, AdminBalanceState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context, state),
                if (state is AdminBalanceLoading)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is AdminBalanceFailure)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('Error: ${state.message}'),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: _buildList(
                        context,
                        state is AdminBalanceLoaded ? state.withdrawals : [],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AdminBalanceState state) {
    final selected = state is AdminBalanceLoaded ? state.filter : null;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0d3b0d), Color(0xFF1B5E20)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(24),
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
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kirim Saldo',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'Permintaan penarikan saldo',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withAlpha(153),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'Semua',
                      active: selected == null,
                      onTap: () =>
                          context.read<AdminBalanceCubit>().setFilter(null),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Menunggu',
                      active: selected == 'pending',
                      onTap: () =>
                          context.read<AdminBalanceCubit>().setFilter('pending'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Selesai',
                      active: selected == 'approved',
                      onTap: () => context
                          .read<AdminBalanceCubit>()
                          .setFilter('approved'),
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

  List<Widget> _buildList(BuildContext context, List<AdminWithdrawal> items) {
    if (items.isEmpty) {
      return [
        const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('Tidak ada data'),
          ),
        )
      ];
    }
    final widgets = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      widgets.add(_WithdrawalItem(
        item: items[i],
        onTap: () => _showDetail(context, items[i]),
      ));
      if (i < items.length - 1) widgets.add(const SizedBox(height: 10));
    }
    return widgets;
  }

  void _showDetail(BuildContext context, AdminWithdrawal item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      builder: (ctx) => _WithdrawalDetailSheet(item: item),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterChip(
      {required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? Colors.white.withAlpha(242)
              : Colors.white.withAlpha(38),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: active ? const Color(0xFF1B5E20) : Colors.white.withAlpha(191),
          ),
        ),
      ),
    );
  }
}

class _WithdrawalItem extends StatelessWidget {
  final AdminWithdrawal item;
  final VoidCallback onTap;

  const _WithdrawalItem({required this.item, required this.onTap});

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
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(Icons.person, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.userName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'Rp ${item.amount}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}',
                            style: const TextStyle(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusBg(item.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel(item.status),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _statusColor(item.status),
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

  String _statusLabel(String s) => switch (s) {
        'pending' => 'Menunggu',
        'approved' => 'Dikonfirmasi',
        'rejected' => 'Ditolak',
        _ => s,
      };

  Color _statusColor(String s) => switch (s) {
        'pending' => const Color(0xFFF9A825),
        'approved' => AppColors.primary,
        'rejected' => AppColors.error,
        _ => AppColors.textGray,
      };

  Color _statusBg(String s) => switch (s) {
        'pending' => const Color(0xFFFFF8E1),
        'approved' => const Color(0xFFE8F5E9),
        'rejected' => const Color(0xFFFFEBEE),
        _ => AppColors.bgLight,
      };
}

class _WithdrawalDetailSheet extends StatelessWidget {
  final AdminWithdrawal item;

  const _WithdrawalDetailSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    final isPending = item.status == 'pending';
    return Container(
      padding: const EdgeInsets.all(22),
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
          const SizedBox(height: 10),
          const Text(
            'Detail Penarikan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: -0.3,
            ),
          ),
          Text(
            'ID #${item.id}',
            style: const TextStyle(fontSize: 12, color: AppColors.textGray),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.person, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.userName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const Text(
                      'Pengguna terdaftar',
                      style: TextStyle(fontSize: 12, color: AppColors.textGray),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.bgSecondary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _DetailRow(
                    label: 'Nominal', value: 'Rp ${item.amount}', isLarge: true),
                _DetailRow(
                  label: 'Tanggal',
                  value:
                      '${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}',
                ),
                if (item.bankName != null)
                  _DetailRow(label: 'Nama Rekening', value: item.bankName!),
                if (item.bankNumber != null)
                  _DetailRow(label: 'No. Rekening', value: item.bankNumber!),
                _DetailRow(
                    label: 'Status',
                    value: item.status == 'pending'
                        ? 'Menunggu'
                        : item.status == 'approved'
                            ? 'Dikonfirmasi'
                            : 'Ditolak',
                    isLast: true),
              ],
            ),
          ),
          if (isPending) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: 'Tolak',
                    borderColor: const Color(0xFFffcdd2),
                    textColor: AppColors.error,
                    onPressed: () {
                      context
                          .read<AdminBalanceCubit>()
                          .rejectWithdrawal(item.id);
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    label: 'Kirim Saldo',
                    onPressed: () {
                      context
                          .read<AdminBalanceCubit>()
                          .approveWithdrawal(item);
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
  final bool isLarge;
  final bool isLast;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isLarge = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textGray)),
              Text(
                value,
                style: TextStyle(
                  fontSize: isLarge ? 15 : 13,
                  fontWeight:
                      isLarge ? FontWeight.w800 : FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
              height: 1,
              color: AppColors.divider,
              indent: 16,
              endIndent: 16),
      ],
    );
  }
}
