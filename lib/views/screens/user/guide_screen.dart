import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../models/waste_model.dart';
import '../../widgets/custom_button.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({Key? key}) : super(key: key);

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GuideSection(
                    title: 'Hal yang Perlu Diperhatikan\nSebelum Pengiriman',
                    items: [
                      ('Pisahkan jenis sampah',
                          'Pastikan sampah sudah dipisah berdasarkan jenisnya sebelum dijemput.'),
                      ('Bersihkan sampah',
                          'Bilas botol, kaleng, atau wadah agar bebas dari sisa makanan & bau.'),
                      ('Siapkan di lokasi yang mudah dijangkau',
                          'Taruh sampah di depan rumah agar petugas mudah mengambilnya.'),
                    ],
                  ),
                  SizedBox(height: 18),
                  _buildCategorySection(),
                  SizedBox(height: 20),
                  SecondaryButton(
                    label: 'Kembali',
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF145214), AppColors.primary],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
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
                    'Panduan Pengiriman',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    'Baca sebelum mengirim sampah',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withAlpha(153),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              color: AppColors.primary,
              margin: EdgeInsets.only(right: 8),
            ),
            Text(
              'Kategori Sampah',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 9,
            crossAxisSpacing: 9,
            childAspectRatio: 1.1,
          ),
          itemCount: WasteCategory.values.length,
          itemBuilder: (context, index) {
            final category = WasteCategory.values[index];
            return _CategoryCard(category: category);
          },
        ),
      ],
    );
  }
}

class _GuideSection extends StatelessWidget {
  final String title;
  final List<(String, String)> items;

  const _GuideSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              color: AppColors.primary,
              margin: EdgeInsets.only(right: 8),
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        ...items
            .asMap()
            .entries
            .map((e) => _GuideItem(
              number: e.key + 1,
              title: e.value.$1,
              description: e.value.$2,
            ))
            .toList()
            .expand((e) => [e, SizedBox(height: 9)])
            .toList()
            .dropLast(1),
      ],
    );
  }
}

class _GuideItem extends StatelessWidget {
  final int number;
  final String title;
  final String description;

  const _GuideItem({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Center(
                child: Text(
                  '$number',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textGray,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final WasteCategory category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final colors = {
      WasteCategory.paper: Color(0xFFE3F2FD),
      WasteCategory.plastic: Color(0xFFE8F5E9),
      WasteCategory.metal: Color(0xFFFFF3E0),
      WasteCategory.glass: Color(0xFFF3E5F5),
      WasteCategory.electronic: Color(0xFFE0F2F1),
    };

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors[category] ?? Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(Icons.category, color: AppColors.primary),
            ),
          ),
          SizedBox(height: 8),
          Text(
            category.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2),
          Text(
            'Rp ${category.pricePerKg}/kg',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }
}

extension on List {
  List dropLast(int count) {
    return sublist(0, length - count);
  }
}
