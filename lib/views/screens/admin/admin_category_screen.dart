import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/colors.dart';
import '../../../cubits/admin_category/admin_category_cubit.dart';
import '../../../cubits/admin_category/admin_category_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input.dart';

class AdminCategoryScreen extends StatefulWidget {
  const AdminCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AdminCategoryScreen> createState() => _AdminCategoryScreenState();
}

class _AdminCategoryScreenState extends State<AdminCategoryScreen> {
  bool _showAddForm = false;
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<AdminCategoryCubit, AdminCategoryState>(
            builder: (context, state) {
              final categories =
                  state is AdminCategoryLoaded ? state.categories : <CategoryModel>[];

              return SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(context),
                    if (state is AdminCategoryLoading)
                      const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (state is AdminCategoryFailure)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text('Error: ${state.message}'),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${categories.length} Kategori Terdaftar',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textGray,
                                letterSpacing: 0.08,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...categories
                                .expand((cat) => [
                                      _CategoryItem(
                                        category: cat,
                                        onEdit: () =>
                                            _showEditDialog(context, cat),
                                        onDelete: () => context
                                            .read<AdminCategoryCubit>()
                                            .deleteCategory(cat.id),
                                      ),
                                      const SizedBox(height: 10),
                                    ])
                                .toList()
                              ..removeLast(),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          if (_showAddForm) _buildAddFormOverlay(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        'Kategori Sampah',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'Kelola jenis & harga sampah',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withAlpha(153),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => setState(() => _showAddForm = true),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddFormOverlay(BuildContext context) {
    return Container(
      color: Colors.black.withAlpha(115),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Padding(
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
                  const SizedBox(height: 14),
                  const Text(
                    'Tambah Kategori',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Nama Kategori',
                    hintText: 'Contoh: Elektronik',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    label: 'Harga per kg (Rp)',
                    hintText: 'Masukkan harga…',
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          label: 'Batal',
                          onPressed: () =>
                              setState(() => _showAddForm = false),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: PrimaryButton(
                          label: 'Simpan',
                          icon: Icons.check,
                          onPressed: () {
                            final name = _nameController.text.trim();
                            final price =
                                int.tryParse(_priceController.text.trim());
                            if (name.isNotEmpty && price != null) {
                              context
                                  .read<AdminCategoryCubit>()
                                  .addCategory(name, price);
                              setState(() => _showAddForm = false);
                              _nameController.clear();
                              _priceController.clear();
                            }
                          },
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
    );
  }

  void _showEditDialog(BuildContext context, CategoryModel cat) {
    final nameCtrl = TextEditingController(text: cat.name);
    final priceCtrl = TextEditingController(text: cat.pricePerKg.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Kategori'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              label: 'Nama',
              hintText: '',
              controller: nameCtrl,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Harga per kg',
              hintText: '',
              controller: priceCtrl,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              final price = int.tryParse(priceCtrl.text.trim());
              if (price != null) {
                context.read<AdminCategoryCubit>().updateCategory(
                      cat.id,
                      nameCtrl.text.trim(),
                      price,
                    );
              }
              Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryItem({
    required this.category,
    required this.onEdit,
    required this.onDelete,
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
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.category, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Rp ${category.pricePerKg} / kg',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _ActionBtn(
              icon: Icons.edit,
              color: AppColors.primary,
              bg: AppColors.bgLight,
              onTap: onEdit,
            ),
            const SizedBox(width: 8),
            _ActionBtn(
              icon: Icons.delete,
              color: AppColors.error,
              bg: const Color(0xFFFFF0F0),
              onTap: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bg;
  final VoidCallback onTap;

  const _ActionBtn(
      {required this.icon,
      required this.color,
      required this.bg,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Icon(icon, color: color, size: 15),
        ),
      ),
    );
  }
}
