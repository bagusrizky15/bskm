import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/colors.dart';
import '../../../cubits/pickup/pickup_cubit.dart';
import '../../../cubits/pickup/pickup_state.dart';
import '../../../cubits/admin_category/admin_category_cubit.dart';
import '../../../cubits/admin_category/admin_category_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';

class PickupScreen extends StatefulWidget {
  const PickupScreen({super.key});

  @override
  State<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _notesController;
  String? _selectedCategory;
  double _weight = 0;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _notesController = TextEditingController();
    _selectedDate = DateTime.now().add(const Duration(days: 1));
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
                              child: Icon(Icons.arrow_back, color: Colors.white, size: 18),
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
                                style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(153)),
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
              child: BlocConsumer<PickupCubit, PickupState>(
                listener: (context, state) {
                  if (state is PickupSuccess) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Penjemputan berhasil diajukan')));
                    Navigator.pop(context);
                  } else if (state is PickupFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
                  }
                },
                builder: (context, state) {
                  final isSubmitting = state is PickupSubmitting;

                  final catState = context.watch<AdminCategoryCubit>().state;
                  final categories = catState is AdminCategoryLoaded ? catState.categories : <CategoryModel>[];

                  final byName = <String, CategoryModel>{for (final c in categories.where((c) => !c.isArchived)) c.name: c};
                  final categoryNames = byName.keys.toList();
                  final categoryItems = categoryNames
                      .map((name) => DropdownMenuItem(value: name, child: Text(name)))
                      .toList();

                  final validCategory = _selectedCategory != null && categoryNames.contains(_selectedCategory)
                      ? _selectedCategory
                      : (categoryNames.isNotEmpty ? categoryNames.first : null);

                  final pricePerKg = validCategory != null ? byName[validCategory]!.pricePerKg : 0;
                  final estimatedPrice = _weight > 0 ? (pricePerKg * _weight).toInt() : pricePerKg;

                  return Column(
                    children: [
                      CustomTextField(label: 'Nama', hintText: 'Masukkan nama lengkap', controller: _nameController),
                      SizedBox(height: 13),
                      if (categoryItems.isEmpty)
                        const Center(child: CircularProgressIndicator())
                      else
                        CustomDropdown<String>(
                          label: 'Kategori Sampah',
                          value: validCategory ?? categoryItems.first.value!,
                          items: categoryItems,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedCategory = value);
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
                                TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan berat',
                                    suffixText: 'kg',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      borderSide: BorderSide(color: AppColors.border, width: 1.5),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  ),
                                  onChanged: (value) {
                                    final w = double.tryParse(value) ?? 0;
                                    setState(() => _weight = w);
                                  },
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
                                    border: Border.all(color: AppColors.divider, width: 1.5),
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 14),
                                        child: Text(
                                          'Rp $estimatedPrice',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 14),
                                        child: Icon(Icons.add, color: AppColors.textLight, size: 14),
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
                                initialDate: _selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(Duration(days: 30)),
                              );
                              if (date != null) {
                                setState(() => _selectedDate = date);
                              }
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: AppColors.border, width: 1.5),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textDark,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
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
                          TextField(
                            controller: _addressController,
                            minLines: 3,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Masukkan alamat lengkap…',
                              hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide: BorderSide(color: AppColors.border, width: 1.5),
                              ),
                              contentPadding: EdgeInsets.all(16),
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
                              hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                                borderSide: BorderSide(color: AppColors.border, width: 1.5),
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
                        isLoading: isSubmitting,
                        onPressed: () {
                          final error = _validate(validCategory);
                          if (error != null) {
                            ScaffoldMessenger.of(context)
                              ..clearSnackBars()
                              ..showSnackBar(SnackBar(content: Text(error)));
                            return;
                          }
                          context.read<PickupCubit>().submitPickup(
                            name: _nameController.text.trim(),
                            category: validCategory!,
                            weight: _weight,
                            price: estimatedPrice,
                            pickupDate: _selectedDate,
                            address: _addressController.text.trim(),
                            notes: _notesController.text.trim(),
                          );
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

  String? _validate(String? category) {
    if (_nameController.text.trim().isEmpty) return 'Nama wajib diisi';
    if (category == null) return 'Pilih kategori dulu';
    if (_weight <= 0) return 'Berat harus lebih dari 0';
    if (_addressController.text.trim().isEmpty) return 'Alamat wajib diisi';
    return null;
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
