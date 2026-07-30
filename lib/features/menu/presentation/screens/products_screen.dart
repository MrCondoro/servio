import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _search = '';
  String _filterCategory = 'All';
  String _filterStatus = 'All';

  static const _categories = ['All', 'Pizza', 'Burgers', 'Coffee', 'Desserts', 'Drinks', 'Pasta'];
  static const _statuses = ['All', 'Available', 'Unavailable', 'Hidden'];

  final List<Map<String, dynamic>> _products = [
    {'name': 'Margherita Pizza', 'category': 'Pizza', 'price': 12.99, 'cost': 4.50, 'sku': 'PIZ-001', 'status': 'Available', 'variants': 3, 'image': Icons.local_pizza_rounded, 'color': const Color(0xFFEF4444)},
    {'name': 'BBQ Beef Burger', 'category': 'Burgers', 'price': 10.50, 'cost': 3.80, 'sku': 'BUR-002', 'status': 'Available', 'variants': 2, 'image': Icons.lunch_dining_rounded, 'color': const Color(0xFFF59E0B)},
    {'name': 'Caramel Latte', 'category': 'Coffee', 'price': 5.50, 'cost': 1.20, 'sku': 'COF-003', 'status': 'Available', 'variants': 4, 'image': Icons.coffee_rounded, 'color': const Color(0xFF92400E)},
    {'name': 'Chocolate Brownie', 'category': 'Desserts', 'price': 6.00, 'cost': 2.10, 'sku': 'DES-004', 'status': 'Available', 'variants': 1, 'image': Icons.cake_rounded, 'color': const Color(0xFFEC4899)},
    {'name': 'Fresh Lemonade', 'category': 'Drinks', 'price': 4.00, 'cost': 0.90, 'sku': 'DRK-005', 'status': 'Available', 'variants': 2, 'image': Icons.local_drink_rounded, 'color': const Color(0xFF3B82F6)},
    {'name': 'Quattro Formaggi', 'category': 'Pizza', 'price': 14.50, 'cost': 5.20, 'sku': 'PIZ-006', 'status': 'Available', 'variants': 3, 'image': Icons.local_pizza_rounded, 'color': const Color(0xFFEF4444)},
    {'name': 'Double Smash Burger', 'category': 'Burgers', 'price': 13.99, 'cost': 4.90, 'sku': 'BUR-007', 'status': 'Unavailable', 'variants': 2, 'image': Icons.lunch_dining_rounded, 'color': const Color(0xFFF59E0B)},
    {'name': 'Espresso', 'category': 'Coffee', 'price': 3.00, 'cost': 0.50, 'sku': 'COF-008', 'status': 'Available', 'variants': 1, 'image': Icons.coffee_rounded, 'color': const Color(0xFF92400E)},
    {'name': 'Tiramisu', 'category': 'Desserts', 'price': 7.50, 'cost': 2.80, 'sku': 'DES-009', 'status': 'Hidden', 'variants': 1, 'image': Icons.cake_rounded, 'color': const Color(0xFFEC4899)},
    {'name': 'Carbonara Pasta', 'category': 'Pasta', 'price': 11.00, 'cost': 3.50, 'sku': 'PAS-010', 'status': 'Available', 'variants': 1, 'image': Icons.ramen_dining_rounded, 'color': const Color(0xFF8B5CF6)},
  ];

  List<Map<String, dynamic>> get _filtered => _products.where((p) {
    final matchSearch = _search.isEmpty || (p['name'] as String).toLowerCase().contains(_search.toLowerCase());
    final matchCat = _filterCategory == 'All' || p['category'] == _filterCategory;
    final matchStatus = _filterStatus == 'All' || p['status'] == _filterStatus;
    return matchSearch && matchCat && matchStatus;
  }).toList();

  Color _statusColor(String s) {
    switch (s) {
      case 'Available': return AppColors.success;
      case 'Unavailable': return AppColors.error;
      case 'Hidden': return AppColors.textSecondaryLight;
      default: return AppColors.textSecondaryLight;
    }
  }

  double _margin(double price, double cost) => price > 0 ? ((price - cost) / price * 100) : 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Product', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 16),
            color: Colors.white,
            child: Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Products', style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w800, fontSize: 22)),
                    SizedBox(height: 2),
                    Text('Manage your menu items and variants', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 13)),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 220, height: 40,
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v),
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      hintStyle: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13),
                      prefixIcon: const Icon(Icons.search_rounded, size: 17, color: AppColors.textSecondaryLight),
                      filled: true, fillColor: AppColors.backgroundLight, contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Status filter
                _FilterDrop(
                  value: _filterStatus,
                  items: _statuses,
                  onChanged: (v) => setState(() => _filterStatus = v),
                  hint: 'Status',
                ),
              ],
            ),
          ),

          // Category filter tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 14),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((cat) {
                  final sel = _filterCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _filterCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: sel ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: sel ? AppColors.primary : AppColors.borderLight),
                        ),
                        child: Text(cat, style: TextStyle(color: sel ? Colors.white : AppColors.textSecondaryLight, fontSize: 13, fontWeight: sel ? FontWeight.w700 : FontWeight.w500)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            decoration: const BoxDecoration(color: AppColors.backgroundLight, border: Border(bottom: BorderSide(color: AppColors.borderLight))),
            child: Row(
              children: const [
                SizedBox(width: 48),
                Expanded(flex: 3, child: Text('Product', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w600))),
                Expanded(flex: 2, child: Text('Category', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w600))),
                Expanded(flex: 2, child: Text('Price / Cost', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w600))),
                Expanded(flex: 1, child: Text('Margin', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w600))),
                Expanded(flex: 1, child: Text('Variants', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w600))),
                Expanded(flex: 2, child: Text('Status', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w600))),
                SizedBox(width: 40),
              ],
            ),
          ),

          // Product rows
          Expanded(
            child: _filtered.isEmpty
                ? _EmptyState()
                : ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) {
                      final p = _filtered[i];
                      return _ProductRow(
                        product: p,
                        statusColor: _statusColor(p['status'] as String),
                        margin: _margin(p['price'] as double, p['cost'] as double),
                      ).animate().fadeIn(delay: (i * 30).ms, duration: 200.ms);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ProductRow extends StatefulWidget {
  final Map<String, dynamic> product;
  final Color statusColor;
  final double margin;
  const _ProductRow({required this.product, required this.statusColor, required this.margin});

  @override
  State<_ProductRow> createState() => _ProductRowState();
}

class _ProductRowState extends State<_ProductRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        color: _hovered ? AppColors.backgroundLight : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        child: Row(
          children: [
            // Icon thumbnail
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: (p['color'] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(p['image'] as IconData, color: p['color'] as Color, size: 20),
            ),
            const SizedBox(width: 8),

            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p['name'] as String, style: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w700, fontSize: 13), overflow: TextOverflow.ellipsis),
                  Text('SKU: ${p['sku']}', style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 11)),
                ],
              ),
            ),

            Expanded(
              flex: 2,
              child: Text(p['category'] as String, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13)),
            ),

            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('\$${(p['price'] as double).toStringAsFixed(2)}', style: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w700, fontSize: 13)),
                  Text('Cost: \$${(p['cost'] as double).toStringAsFixed(2)}', style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 11)),
                ],
              ),
            ),

            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: Text('${widget.margin.toStringAsFixed(0)}%', style: const TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ),

            Expanded(
              flex: 1,
              child: Row(
                children: [
                  const Icon(Icons.tune_rounded, size: 13, color: AppColors.textSecondaryLight),
                  const SizedBox(width: 4),
                  Text('${p['variants']}', style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13)),
                ],
              ),
            ),

            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: widget.statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(p['status'] as String, style: TextStyle(color: widget.statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ),

            SizedBox(
              width: 40,
              child: IconButton(
                icon: const Icon(Icons.more_vert_rounded, size: 18, color: AppColors.textSecondaryLight),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterDrop extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final String hint;
  const _FilterDrop({required this.value, required this.items, required this.onChanged, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 13),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.textSecondaryLight),
          onChanged: (v) => onChanged(v!),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.06), shape: BoxShape.circle),
            child: const Icon(Icons.inventory_2_outlined, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: 20),
          const Text('No products found', style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 8),
          const Text('Try adjusting your search or filters.', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 14)),
        ],
      ),
    );
  }
}
