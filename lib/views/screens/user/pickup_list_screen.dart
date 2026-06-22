import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/colors.dart';
import '../../../models/waste_model.dart';
import '../../../cubits/pickup/pickup_cubit.dart';
import '../../../cubits/pickup/pickup_state.dart';

class PickupListScreen extends StatefulWidget {
  const PickupListScreen({super.key});

  @override
  State<PickupListScreen> createState() => _PickupListScreenState();
}

class _PickupListScreenState extends State<PickupListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PickupCubit>().fetchPickups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                              'Jemput Sampah',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.3,
                              ),
                            ),
                            Text(
                              'Riwayat pengambilan sampah',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withAlpha(153),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<PickupCubit, PickupState>(
              builder: (context, state) {
                if (state is PickupLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }

                if (state is PickupLoaded) {
                  if (state.pickups.isEmpty) {
                    return Center(
                      child: Text(
                        'Belum ada penjemputan',
                        style: TextStyle(
                          color: AppColors.textGray,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: state.pickups.length,
                    itemBuilder: (context, index) {
                      final pickup = state.pickups[index];
                      return GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => PickupDetailSheet(
                              pickup: pickup,
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: AppColors.border,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    pickup.userName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(pickup.status),
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      pickup.status.label,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: AppColors.textLight,
                                    size: 14,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    _formatDate(pickup.pickupDate),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textGray,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                if (state is PickupFailure) {
                  return Center(
                    child: Text(
                      'Error: ${state.message}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                return SizedBox();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, '/pickup-form');
          if (context.mounted) {
            context.read<PickupCubit>().fetchPickups();
          }
        },
        backgroundColor: AppColors.primary,
        icon: Icon(Icons.add),
        label: Text('Ajukan Penjemputan'),
      ),
    );
  }

  Color _getStatusColor(PickupStatus status) {
    switch (status) {
      case PickupStatus.waiting:
        return Color(0xFFF59E0B);
      case PickupStatus.confirmed:
        return Color(0xFF10B981);
      case PickupStatus.completed:
        return Color(0xFF6366F1);
      case PickupStatus.rejected:
        return Color(0xFFEF4444);
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class PickupDetailSheet extends StatelessWidget {
  final dynamic pickup;

  const PickupDetailSheet({super.key, required this.pickup});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detail Penjemputan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 16),
          _buildDetailRow('Nama', pickup.userName),
          _buildDetailRow('Kategori', pickup.category),
          _buildDetailRow('Berat', '${pickup.weight} kg'),
          _buildDetailRow('Harga', 'Rp ${pickup.estimatedPrice}'),
          _buildDetailRow('Tanggal', _formatDate(pickup.pickupDate)),
          _buildDetailRow('Alamat', pickup.address),
          if (pickup.notes != null) _buildDetailRow('Catatan', pickup.notes),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textGray,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
