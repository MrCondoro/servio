import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

final _inventoryItems = [
  {'name': 'Mozzarella Cheese', 'category': 'Dairy', 'stock': 2.5, 'unit': 'kg', 'minStock': 5.0, 'status': 'Low Stock'},
  {'name': 'Tomato Sauce', 'category': 'Condiments', 'stock': 1.2, 'unit': 'L', 'minStock': 3.0, 'status': 'Low Stock'},
  {'name': 'Chicken Breast', 'category': 'Proteins', 'stock': 0.0, 'unit': 'kg', 'minStock': 10.0, 'status': 'Out of Stock'},
  {'name': 'Olive Oil', 'category': 'Oils', 'stock': 1.5, 'unit': 'L', 'minStock': 3.0, 'status': 'Low Stock'},
  {'name': 'Pasta', 'category': 'Grains', 'stock': 12.0, 'unit': 'kg', 'minStock': 5.0, 'status': 'In Stock'},
  {'name': 'Pizza Dough', 'category': 'Baking', 'stock': 8.0, 'unit': 'pcs', 'minStock': 10.0, 'status': 'Low Stock'},
  {'name': 'Lettuce', 'category': 'Vegetables', 'stock': 5.0, 'unit': 'kg', 'minStock': 3.0, 'status': 'In Stock'},
  {'name': 'Ground Beef', 'category': 'Proteins', 'stock': 6.5, 'unit': 'kg', 'minStock': 8.0, 'status': 'Low Stock'},
  {'name': 'Parmesan', 'category': 'Dairy', 'stock': 3.0, 'unit': 'kg', 'minStock': 2.0, 'status': 'In Stock'},
  {'name': 'White Wine', 'category': 'Beverages', 'stock': 6.0, 'unit': 'btl', 'minStock': 4.0, 'status': 'In Stock'},
];

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  String _filter = 'All';
  String _search = '';

  List<Map<String, dynamic>> get _filtered => _inventoryItems.where((item) {
    final matchSearch = _search.isEmpty || (item['name'] as String).toLowerCase().contains(_search.toLowerCase());
    final matchFilter = _filter == 'All' || item['status'] == _filter;
    return matchSearch && matchFilter;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 20),
            color: Colors.white,
            child: Row(
              children: [
                const Text('Inventory', style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w800, fontSize: 22)),
                const SizedBox(width: 20),
                // Summary chips
                _SummaryChip(label: 'In Stock', value: '${_inventoryItems.where((i) => i['status'] == 'In Stock').length}', color: AppColors.success),
                const SizedBox(width: 10),
                _SummaryChip(label: 'Low Stock', value: '${_inventoryItems.where((i) => i['status'] == 'Low Stock').length}', color: AppColors.warning),
                const SizedBox(width: 10),
                _SummaryChip(label: 'Out of Stock', value: '${_inventoryItems.where((i) => i['status'] == 'Out of Stock').length}', color: AppColors.error),
                const Spacer(),
                // Search
                SizedBox(
                  width: 220,
                  height: 40,
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v),
                    decoration: InputDecoration(
                      hintText: 'Search items...',
                      hintStyle: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13),
                      prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.textSecondaryLight),
                      filled: true, fillColor: AppColors.backgroundLight,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ...['All', 'In Stock', 'Low Stock', 'Out of Stock'].map((f) {
                  final sel = _filter == f;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _filter = f),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: sel ? AppColors.primary : AppColors.borderLight),
                        ),
                        child: Text(f, style: TextStyle(color: sel ? Colors.white : AppColors.textSecondaryLight, fontSize: 12, fontWeight: sel ? FontWeight.w700 : FontWeight.w500)),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.backgroundLight,
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text('Item', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w600))),
                Expanded(flex: 2, child: Text('Category', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w600))),
                Expanded(flex: 3, child: Text('Stock Level', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w600))),
                Expanded(flex: 1, child: Text('Unit', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w600))),
                Expanded(flex: 2, child: Text('Status', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w600))),
                SizedBox(width: 48),
              ],
            ),
          ),

          // Table rows
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (context, i) => _InventoryRow(item: _filtered[i])
                  .animate().fadeIn(delay: (i * 30).ms, duration: 200.ms),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label, value;
  final Color color;
  const _SummaryChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(width: 6),
          Text(value, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _InventoryRow extends StatelessWidget {
  final Map<String, dynamic> item;
  const _InventoryRow({required this.item});

  Color get _statusColor {
    switch (item['status'] as String) {
      case 'In Stock': return AppColors.success;
      case 'Low Stock': return AppColors.warning;
      default: return AppColors.error;
    }
  }

  double get _stockPercent {
    final stock = item['stock'] as double;
    final min = item['minStock'] as double;
    if (min == 0) return 1.0;
    return (stock / (min * 2)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(item['name'] as String, style: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w600, fontSize: 14)),
          ),
          Expanded(
            flex: 2,
            child: Text(item['category'] as String, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13)),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${item['stock']} / ${item['minStock']} ${item['unit']}', style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 12)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _stockPercent,
                    backgroundColor: AppColors.borderLight,
                    valueColor: AlwaysStoppedAnimation<Color>(_statusColor),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(item['unit'] as String, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13)),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(item['status'] as String, style: TextStyle(color: _statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ),
          SizedBox(
            width: 48,
            child: IconButton(
              icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondaryLight),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
