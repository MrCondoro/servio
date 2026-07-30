import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/active_order_provider.dart';
import '../../../../core/theme/app_colors.dart';

class OrderCartSidebar extends ConsumerWidget {
  const OrderCartSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(activeOrderControllerProvider);

    return Container(
      width: 320,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: AppColors.borderLight)),
      ),
      child: Column(
        children: [
          // ── Header ─────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dine In ▾', style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w700, fontSize: 16), overflow: TextOverflow.ellipsis),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.table_restaurant_rounded, size: 13, color: AppColors.textSecondaryLight),
                          SizedBox(width: 4),
                          Text('Table 5', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12)),
                          SizedBox(width: 8),
                          Icon(Icons.people_outlined, size: 13, color: AppColors.textSecondaryLight),
                          SizedBox(width: 4),
                          Text('2 Guests', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh_rounded, size: 18, color: AppColors.textSecondaryLight),
                    SizedBox(width: 10),
                    Icon(Icons.crop_square_rounded, size: 18, color: AppColors.textSecondaryLight),
                    SizedBox(width: 10),
                    Icon(Icons.dashboard_customize_rounded, size: 18, color: AppColors.textSecondaryLight),
                  ],
                ),
              ],
            ),
          ),

          // ── Item List ───────────────────────────────────────────────────
          Expanded(
            child: order.items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.shopping_bag_outlined, size: 48, color: AppColors.borderLight),
                        ),
                        const SizedBox(height: 16),
                        const Text('No items yet', style: TextStyle(color: AppColors.textSecondaryLight, fontWeight: FontWeight.w600, fontSize: 16)),
                        const SizedBox(height: 6),
                        const Text('Tap items from the menu to add', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12), textAlign: TextAlign.center),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: order.items.length,
                    itemBuilder: (context, index) {
                      final item = order.items[index];
                      return _CartItemRow(
                        item: item,
                        onDecrease: () => ref.read(activeOrderControllerProvider.notifier).updateQuantity(item.id, item.quantity - 1),
                        onIncrease: () => ref.read(activeOrderControllerProvider.notifier).updateQuantity(item.id, item.quantity + 1),
                      );
                    },
                  ),
          ),

          // ── Action buttons ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.borderLight)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ActionChip(icon: Icons.favorite_border_rounded, label: 'Favs'),
                const SizedBox(width: 6),
                _ActionChip(icon: Icons.local_offer_outlined, label: 'Discount'),
                const SizedBox(width: 6),
                _ActionChip(icon: Icons.note_add_outlined, label: 'Note'),
                const SizedBox(width: 6),
                _ActionChip(icon: Icons.call_split_rounded, label: 'Split'),
              ],
            ),
          ),

          // ── Totals ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Column(
              children: [
                _TotalRow(label: 'Subtotal', value: '\$${(order.total - order.tax).toStringAsFixed(2)}'),
                const SizedBox(height: 6),
                _TotalRow(label: 'Discount', value: '-\$0.00', valueColor: AppColors.error),
                const SizedBox(height: 6),
                _TotalRow(label: 'Tax (8%)', value: '\$${order.tax.toStringAsFixed(2)}'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.borderLight, height: 1),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w800, fontSize: 18)),
                    Text('\$${order.total.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w800, fontSize: 22)),
                  ],
                ),
              ],
            ),
          ),

          // ── Buttons ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Row(
              children: [
                // Save button
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {},
                      child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Pay button
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        elevation: 2,
                      ),
                      onPressed: order.items.isEmpty ? null : () => context.go('/checkout'),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          order.items.isEmpty ? 'Pay' : 'Pay  \$${order.total.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Cart Item Row ─────────────────────────────────────────────────────────────
class _CartItemRow extends StatelessWidget {
  final dynamic item;
  final VoidCallback onDecrease, onIncrease;
  const _CartItemRow({required this.item, required this.onDecrease, required this.onIncrease});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        children: [
          // Quantity stepper
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderLight),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: onDecrease,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Icon(Icons.remove, size: 14, color: AppColors.primary),
                  ),
                ),
                Container(
                  width: 24,
                  alignment: Alignment.center,
                  child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimaryLight)),
                ),
                GestureDetector(
                  onTap: onIncrease,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Icon(Icons.add, size: 14, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                const Text('Regular', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 11)),
              ],
            ),
          ),
          Text('\$${(item.price * item.quantity).toStringAsFixed(2)}', style: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w700, fontSize: 14)),
        ],
      ),
    );
  }
}

// ── Action Chip ───────────────────────────────────────────────────────────────
class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: [
              Icon(icon, size: 16, color: AppColors.textSecondaryLight),
              const SizedBox(height: 2),
              Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textSecondaryLight, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Total Row ─────────────────────────────────────────────────────────────────
class _TotalRow extends StatelessWidget {
  final String label, value;
  final Color? valueColor;
  const _TotalRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13)),
        Text(value, style: TextStyle(color: valueColor ?? AppColors.textPrimaryLight, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
