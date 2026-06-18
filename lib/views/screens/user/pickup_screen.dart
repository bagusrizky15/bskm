import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/colors.dart';
import '../../../models/waste_model.dart';
import '../../../viewmodels/pickup_viewmodel.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';

class PickupScreen extends StatefulWidget {
  const PickupScreen({Key? key}) : super(key: key);

  @override
  State<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
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
                                'Isi data pengambilan sampah',
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

            // Form
            Padding(
              padding: EdgeInsets.all(20),
              child: Consumer<PickupViewModel>(
                builder: (context, pickupVm, _) {
                  return Column(
                    children: [
                      CustomTextField(
                        label: 'Nama',
                        hintText: 'Masukkan nama lengkap',
                        controller: _nameController,
                      ),
                      SizedBox(height: 13),
                      CustomDropdown<String>(
                        label: 'Kategori Sampah',
                        value: pickupVm.selectedCategory,
                        items: WasteCategory.values
                            .map((cat) => DropdownMenuItem(
                              value: cat.name,
                              child: Text(cat.name),
                            ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            pickupVm.setCategory(value);
                          }
                        },
                      ),
                      SizedBox(height: 13),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Berat (kg)',
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
                                    color: Colors.white,
                                    border: Border.all(
                                      color: AppColors.border,
                                      width: 1.5,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(13),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: 14),
                                        child: Text(
                                          pickupVm.weight.toString(),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight:
                                                FontWeight.w700,
                                            color:
                                                AppColors.textDark,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(right: 14),
                                        child: Text(
                                          'kg',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                AppColors.textLight,
                                            fontWeight:
                                                FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Harga',
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
                                      color: AppColors.divider,
                                      width: 1.5,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(13),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: 14),
                                        child: Text(
                                          'Rp ${pickupVm.estimatedPrice}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight:
                                                FontWeight.w700,
                                            color:
                                                AppColors.primary,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(right: 14),
                                        child: Icon(
                                          Icons.add,
                                          color:
                                              AppColors.textLight,
                                          size: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '*Otomatis dihitung',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 13),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tanggal Penjemputan',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textGray,
                              letterSpacing: 0.08,
                            ),
                          ),
                          SizedBox(height: 6),
                          GestureDetector(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate:
                                    pickupVm.selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(Duration(days: 30)),
                              );
                              if (date != null) {
                                pickupVm.setDate(date);
                              }
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: AppColors.border,
                                  width: 1.5,
                                ),
                                borderRadius:
                                    BorderRadius.circular(13),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                  children: [
                                    Text(
                                      '${pickupVm.selectedDate.day} ${_getMonthName(pickupVm.selectedDate.month)} ${pickupVm.selectedDate.year}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color:
                                            AppColors.textDark,
                                        fontWeight:
                                            FontWeight.w500,
                                      ),
                                    ),
                                    Icon(Icons.calendar_today,
                                        color: AppColors.primary,
                                        size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 13),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alamat',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textGray,
                              letterSpacing: 0.08,
                            ),
                          ),
                          SizedBox(height: 6),
                          Container(
                            constraints: BoxConstraints(minHeight: 70),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: AppColors.border,
                                width: 1.5,
                              ),
                              borderRadius:
                                  BorderRadius.circular(13),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Jl. Mawar No. 12, Bandung',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textDark,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Jawa Barat, Indonesia',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 13),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Catatan Tambahan',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textGray,
                              letterSpacing: 0.08,
                            ),
                          ),
                          SizedBox(height: 6),
                          TextField(
                            controller: _notesController,
                            minLines: 3,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Tambahkan catatan untuk petugas…',
                              hintStyle: TextStyle(
                                color: AppColors.textLight,
                                fontSize: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(13),
                                borderSide: BorderSide(
                                  color: AppColors.border,
                                  width: 1.5,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      PrimaryButton(
                        label: 'Ajukan Penjemputan',
                        icon: Icons.check,
                        isLoading: pickupVm.isLoading,
                        onPressed: () async {
                          await pickupVm.submitPickup(
                            _nameController.text,
                            _addressController.text,
                            _notesController.text,
                          );
                          if (mounted) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Penjemputan berhasil diajukan'),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
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
