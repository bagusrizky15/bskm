import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/colors.dart';
import '../../../cubits/balance/balance_cubit.dart';
import '../../../cubits/balance/balance_state.dart';
import '../../widgets/custom_button.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BalanceCubit>().fetchBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BalanceCubit, BalanceState>(
        builder: (context, state) {
          if (state is BalanceLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context, state.balance),
                  _buildWithdrawalList(context, state),
                ],
              ),
            );
          }
          if (state is BalanceFailure) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic balance) {
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
                  Text(
                    'Saldo Saya',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(33),
                  border: Border.all(
                    color: Colors.white.withAlpha(51),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Saldo Tersisa',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withAlpha(153),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.12,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Rp ${balance.balance}',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Rp ${balance.total}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Total Earnings',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white.withAlpha(128),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withAlpha(38),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Rp ${balance.withdrawn}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Ditarik',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white.withAlpha(128),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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

  Widget _buildWithdrawalList(BuildContext context, BalanceLoaded state) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Riwayat Penarikan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 12),
          if (state.withdrawals.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Belum ada penarikan',
                  style: TextStyle(
                    color: AppColors.textGray,
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else
            ...state.withdrawals
                .map((w) => _WithdrawalItem(withdrawal: w))
                .toList()
                .expand((item) => [item, SizedBox(height: 9)])
                .toList()
                .dropLast(1),
          SizedBox(height: 20),
          PrimaryButton(
            label: 'Tarik Saldo',
            icon: Icons.account_balance_wallet,
            onPressed: state.balance.balance > 0
                ? () => _showWithdrawalDialog(context, state.balance.balance)
                : () {},
          ),
        ],
      ),
    );
  }

  void _showWithdrawalDialog(BuildContext context, int balance) {
    showDialog(
      context: context,
      builder: (context) => _WithdrawalDialog(maxAmount: balance),
    );
  }
}

class _WithdrawalItem extends StatelessWidget {
  final dynamic withdrawal;

  const _WithdrawalItem({required this.withdrawal});

  @override
  Widget build(BuildContext context) {
    final statusColor = {
      'pending': Color(0xFFF59E0B),
      'approved': Color(0xFF10B981),
      'rejected': Color(0xFFEF4444),
    }[withdrawal.status.name] ?? Color(0xFFF59E0B);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(13),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                Icons.arrow_downward,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Penarikan Saldo',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withAlpha(102),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          withdrawal.status.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    '${withdrawal.createdAt.day} ${_getMonth(withdrawal.createdAt.month)} ${withdrawal.createdAt.year}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9ab09a),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '−Rp ${withdrawal.amount}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}

class _WithdrawalDialog extends StatefulWidget {
  final int maxAmount;

  const _WithdrawalDialog({required this.maxAmount});

  @override
  State<_WithdrawalDialog> createState() => _WithdrawalDialogState();
}

class _WithdrawalDialogState extends State<_WithdrawalDialog> {
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tarik Saldo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Saldo tersedia: Rp ${widget.maxAmount}',
            style: TextStyle(fontSize: 12, color: AppColors.textGray),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Jumlah penarikan',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            final amount = int.tryParse(_amountController.text);
            if (amount != null && amount > 0) {
              context.read<BalanceCubit>().requestWithdrawal(amount);
              Navigator.pop(context);
            }
          },
          child: Text('Tarik'),
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
