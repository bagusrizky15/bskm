import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../widgets/custom_button.dart';

class AdminBalanceScreen extends StatelessWidget {
  const AdminBalanceScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> _withdrawals = const [
    {
      'name': 'Budi Santoso',
      'amount': 20000,
      'date': '18 Jun 2026',
      'status': 'Menunggu',
    },
    {
      'name': 'Siti Rahayu',
      'amount': 35000,
      'date': '17 Jun 2026',
      'status': 'Menunggu',
    },
    {
      'name': 'Ahmad Fauzi',
      'amount': 50000,
      'date': '16 Jun 2026',
      'status': 'Dikonfirmasi',
    },
    {
      'name': 'Dewi Lestari',
      'amount': 15000,
      'date': '15 Jun 2026',
      'status': 'Ditolak',
    },
    {
      'name': 'Rudi Hermawan',
      'amount': 28000,
      'date': '15 Jun 2026',
      'status': 'Menunggu',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: _buildWithdrawalsList(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildWithdrawalsList(BuildContext context) {
    List<Widget> items = [];
    for (int i = 0; i < _withdrawals.length; i++) {
      items.add(
        _buildWithdrawalItem(
          context,
          _withdrawals[i],
          i,
        ),
      );
      if (i < _withdrawals.length - 1) {
        items.add(SizedBox(height: 10));
      }
    }
    return items;
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
              SizedBox(height: 14),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(label: 'Semua', active: true),
                    SizedBox(width: 8),
                    _FilterChip(label: 'Menunggu', active: false),
                    SizedBox(width: 8),
                    _FilterChip(label: 'Selesai', active: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWithdrawalItem(
    BuildContext context,
    Map<String, dynamic> item,
    int index,
  ) {
    final isWaiting = item['status'] == 'Menunggu';
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
          onTap: () => _showWithdrawalDetail(context, item, index),
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
                        item['name'],
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
                            'Rp ${item['amount']}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            item['date'],
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
                    color: _getStatusBgColor(item['status']),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item['status'],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _getStatusColor(item['status']),
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

  void _showWithdrawalDetail(
    BuildContext context,
    Map<String, dynamic> item,
    int index,
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
      builder: (context) => _WithdrawalDetailSheet(
        item: item,
        index: index,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Color(0xFFF9A825);
      case 'Dikonfirmasi':
        return AppColors.primary;
      case 'Ditolak':
        return AppColors.error;
      default:
        return AppColors.textGray;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Color(0xFFFFF8E1);
      case 'Dikonfirmasi':
        return Color(0xFFE8F5E9);
      case 'Ditolak':
        return Color(0xFFFFEBEE);
      default:
        return AppColors.bgLight;
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;

  const _FilterChip({
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
          color: active
              ? Color(0xFF1B5E20)
              : Colors.white.withAlpha(191),
        ),
      ),
    );
  }
}

class _WithdrawalDetailSheet extends StatelessWidget {
  final Map<String, dynamic> item;
  final int index;

  const _WithdrawalDetailSheet({
    required this.item,
    required this.index,
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
          SizedBox(height: 10),
          Text(
            'Detail Penarikan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: -0.3,
            ),
          ),
          Text(
            'ID #WD-2026-${String.fromCharCode(48 + index)}',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textGray,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
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
                      item['name'],
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
                  item['status'],
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
                  label: 'Nominal Penarikan',
                  value: 'Rp ${item['amount']}',
                  isLarge: true,
                ),
                _DetailRow(
                  label: 'Tanggal Permintaan',
                  value: item['date'],
                ),
                _DetailRow(
                  label: 'Metode',
                  value: 'Transfer Bank',
                ),
                _DetailRow(
                  label: 'No. Rekening',
                  value: '**** **** 4821',
                  isLast: true,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: 'Tolak',
                  borderColor: Color(0xFFffcdd2),
                  textColor: AppColors.error,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  label: 'Kirim Saldo',
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Saldo berhasil dikirim')),
                    );
                  },
                ),
              ),
            ],
          ),
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
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
