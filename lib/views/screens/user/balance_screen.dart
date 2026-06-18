import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/colors.dart';
import '../../../cubits/home/home_cubit.dart';
import '../../../cubits/home/home_state.dart';
import '../../widgets/custom_button.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context, state.balance),
                  _buildTransactionList(state.balance),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
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
                        'Total Saldo',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withAlpha(153),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.12,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Rp ${balance.totalBalance}',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Terakhir diperbarui: 18 Jun 2026',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withAlpha(128),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '${balance.totalWaste} kg',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Total Sampah',
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
                                  'Rp ${balance.withdrawn ~/ 1000}K',
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

  Widget _buildTransactionList(dynamic balance) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Riwayat Saldo',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 12),
          ...balance.transactions
              .map((tx) => _TransactionItem(transaction: tx))
              .toList()
              .expand((w) => [w, SizedBox(height: 9)])
              .toList()
              .dropLast(1),
          SizedBox(height: 20),
          PrimaryButton(
            label: 'Tarik Saldo',
            icon: Icons.account_balance_wallet,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final dynamic transaction;

  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type.name == 'deposit';
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
                color: isIncome ? Color(0xFFE8F5E9) : Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                color: isIncome ? AppColors.primary : AppColors.error,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '${transaction.date.day} ${_getMonth(transaction.date.month)} ${transaction.date.year}${transaction.weight > 0 ? ' · ${transaction.weight} kg' : ''}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9ab09a),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${isIncome ? '+' : '−'}Rp ${transaction.amount}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isIncome ? AppColors.primary : AppColors.error,
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

extension on List {
  List dropLast(int count) {
    return sublist(0, (length - count).clamp(0, length));
  }
}
