import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

final _customers = [
  {'name': 'Sarah Johnson', 'email': 'sarah@email.com', 'phone': '+1 555 0101', 'orders': 24, 'spending': '\$1,245.80', 'tier': 'Gold', 'initials': 'SJ', 'color': 0xFFFF6B6B},
  {'name': 'Mike Chen', 'email': 'mike@email.com', 'phone': '+1 555 0102', 'orders': 18, 'spending': '\$982.50', 'tier': 'Silver', 'initials': 'MC', 'color': 0xFF4D96FF},
  {'name': 'Emily Davis', 'email': 'emily@email.com', 'phone': '+1 555 0103', 'orders': 32, 'spending': '\$2,100.00', 'tier': 'Gold', 'initials': 'ED', 'color': 0xFF6BCB77},
  {'name': 'James Wilson', 'email': 'james@email.com', 'phone': '+1 555 0104', 'orders': 5, 'spending': '\$234.20', 'tier': 'Bronze', 'initials': 'JW', 'color': 0xFFF59E0B},
  {'name': 'Ava Martinez', 'email': 'ava@email.com', 'phone': '+1 555 0105', 'orders': 47, 'spending': '\$3,456.90', 'tier': 'Platinum', 'initials': 'AM', 'color': 0xFFC77DFF},
  {'name': 'Liam Brown', 'email': 'liam@email.com', 'phone': '+1 555 0106', 'orders': 12, 'spending': '\$620.40', 'tier': 'Silver', 'initials': 'LB', 'color': 0xFF4ECDC4},
];

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  String _search = '';
  String _filterTier = 'All';

  @override
  Widget build(BuildContext context) {
    final filtered = _customers.where((c) {
      final matchSearch = _search.isEmpty || (c['name'] as String).toLowerCase().contains(_search.toLowerCase());
      final matchTier = _filterTier == 'All' || c['tier'] == _filterTier;
      return matchSearch && matchTier;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // ── Header ─────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 20),
            color: Colors.white,
            child: Row(
              children: [
                const Text('Customers', style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w800, fontSize: 22)),
                const Spacer(),
                // Search
                SizedBox(
                  width: 240,
                  height: 40,
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v),
                    decoration: InputDecoration(
                      hintText: 'Search customers...',
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
                // Tier filters
                ...['All', 'Platinum', 'Gold', 'Silver', 'Bronze'].map((t) {
                  final sel = _filterTier == t;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _filterTier = t),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: sel ? AppColors.primary : AppColors.borderLight),
                        ),
                        child: Text(t, style: TextStyle(color: sel ? Colors.white : AppColors.textSecondaryLight, fontSize: 13, fontWeight: sel ? FontWeight.w700 : FontWeight.w500)),
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.person_add_rounded, size: 16),
                  label: const Text('Add Customer', style: TextStyle(fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  ),
                ),
              ],
            ),
          ),

          // ── Customer Grid ───────────────────────────────────────────────
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 320,
                childAspectRatio: 1.3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, i) => _CustomerCard(data: filtered[i])
                  .animate().fadeIn(delay: (i * 50).ms, duration: 300.ms).slideY(begin: 0.05),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _CustomerCard({required this.data});

  Color get _tierColor {
    switch (data['tier']) {
      case 'Platinum': return const Color(0xFFC77DFF);
      case 'Gold': return AppColors.warning;
      case 'Silver': return AppColors.textSecondaryLight;
      default: return const Color(0xFFCD7F32);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: Color(data['color'] as int).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(data['initials'] as String, style: TextStyle(color: Color(data['color'] as int), fontWeight: FontWeight.w800, fontSize: 16)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['name'] as String, style: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w700, fontSize: 14), overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(data['email'] as String, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 11), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _tierColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(data['tier'] as String, style: TextStyle(color: _tierColor, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.borderLight, height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CustomerStat(label: 'Orders', value: '${data['orders']}'),
              _CustomerStat(label: 'Spent', value: data['spending'] as String),
              _CustomerStat(label: 'Phone', value: data['phone'] as String),
            ],
          ),
        ],
      ),
    );
  }
}

class _CustomerStat extends StatelessWidget {
  final String label, value;
  const _CustomerStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 12, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
