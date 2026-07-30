import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../../core/theme/app_colors.dart';

// ── Mock Data ────────────────────────────────────────────────────────────────
final _mockKdsOrders = [
  OrderEntity(id: 'o1', orderNumber: '1058', tableId: 'Table 5', status: OrderStatus.pending,
    createdAt: DateTime.now().subtract(const Duration(minutes: 4, seconds: 58)),
    items: const [
      OrderItemEntity(id: 'i1', menuItemId: 'm1', name: 'Margherita Pizza', price: 12.50, quantity: 1, notes: 'Extra Cheese'),
      OrderItemEntity(id: 'i2', menuItemId: 'm4', name: 'Caesar Salad', price: 8.75, quantity: 1, notes: 'No Croutons'),
      OrderItemEntity(id: 'i3', menuItemId: 'm5', name: 'Mojito', price: 5.75, quantity: 1),
    ]),
  OrderEntity(id: 'o2', orderNumber: '1057', tableId: 'Table 12', status: OrderStatus.preparing,
    createdAt: DateTime.now().subtract(const Duration(minutes: 7, seconds: 32)),
    items: const [
      OrderItemEntity(id: 'i4', menuItemId: 'm7', name: 'Spaghetti Bolognese', price: 11.00, quantity: 1, notes: 'Extra Sauce'),
      OrderItemEntity(id: 'i5', menuItemId: 'm8', name: 'Chicken Wings', price: 9.25, quantity: 1, notes: 'Spicy'),
    ]),
  OrderEntity(id: 'o3', orderNumber: '1056', tableId: 'Table 3', status: OrderStatus.ready,
    createdAt: DateTime.now().subtract(const Duration(minutes: 13, seconds: 0)),
    items: const [
      OrderItemEntity(id: 'i6', menuItemId: 'm7', name: 'Spaghetti Bolognese', price: 11.00, quantity: 1),
      OrderItemEntity(id: 'i7', menuItemId: 'm6', name: 'French Fries', price: 4.25, quantity: 1),
      OrderItemEntity(id: 'i8', menuItemId: 'm3', name: 'Coca Cola', price: 3.00, quantity: 1),
    ]),
  OrderEntity(id: 'o4', orderNumber: '1055', tableId: 'Takeaway', status: OrderStatus.preparing,
    createdAt: DateTime.now().subtract(const Duration(minutes: 2, seconds: 15)),
    items: const [
      OrderItemEntity(id: 'i9', menuItemId: 'm3', name: 'Cheese Burger', price: 10.25, quantity: 2),
      OrderItemEntity(id: 'i10', menuItemId: 'm6', name: 'French Fries', price: 4.25, quantity: 2),
    ]),
];

class KDSScreen extends ConsumerWidget {
  const KDSScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = _mockKdsOrders.where((o) => o.status == OrderStatus.pending).toList();
    final preparing = _mockKdsOrders.where((o) => o.status == OrderStatus.preparing).toList();
    final ready = _mockKdsOrders.where((o) => o.status == OrderStatus.ready).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Column(
        children: [
          // ── KDS Top Bar ────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              color: AppColors.surfaceDark,
              border: Border(bottom: BorderSide(color: AppColors.borderDark)),
            ),
            child: Row(
              children: [
                const Text('Kitchen Display', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)),
                const SizedBox(width: 16),
                _CountChip(label: 'All Orders', count: _mockKdsOrders.length, color: AppColors.textSecondaryDark),
                const SizedBox(width: 10),
                _CountChip(label: 'Pending', count: pending.length, color: AppColors.info),
                const SizedBox(width: 10),
                _CountChip(label: 'Preparing', count: preparing.length, color: AppColors.warning),
                const SizedBox(width: 10),
                _CountChip(label: 'Ready', count: ready.length, color: AppColors.success),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.wifi_rounded, size: 14, color: AppColors.success),
                      SizedBox(width: 6),
                      Text('SYNCED', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w700, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.settings_outlined, color: AppColors.textSecondaryDark, size: 20),
              ],
            ),
          ),

          // ── Kanban Columns ─────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _KDSColumn(title: 'PENDING', orders: pending, color: AppColors.info),
                  const SizedBox(width: 16),
                  _KDSColumn(title: 'PREPARING', orders: preparing, color: AppColors.warning),
                  const SizedBox(width: 16),
                  _KDSColumn(title: 'READY', orders: ready, color: AppColors.success),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Count Chip ────────────────────────────────────────────────────────────────
class _CountChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _CountChip({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
            child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

// ── KDS Column ────────────────────────────────────────────────────────────────
class _KDSColumn extends StatelessWidget {
  final String title;
  final List<OrderEntity> orders;
  final Color color;
  const _KDSColumn({required this.title, required this.orders, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          // Column header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                const SizedBox(width: 10),
                Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 1)),
                const Spacer(),
                Text('${orders.length}', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Order cards
          Expanded(
            child: ListView.separated(
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) => _OrderTicket(order: orders[i], columnColor: color)
                  .animate(key: ValueKey(orders[i].id))
                  .slideY(begin: 0.05, duration: 300.ms, delay: (i * 60).ms)
                  .fadeIn(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Order Ticket ──────────────────────────────────────────────────────────────
class _OrderTicket extends StatelessWidget {
  final OrderEntity order;
  final Color columnColor;
  const _OrderTicket({required this.order, required this.columnColor});

  Duration get _elapsed => DateTime.now().difference(order.createdAt);
  bool get _isUrgent => _elapsed.inMinutes >= 10;

  String _formatElapsed() {
    final m = _elapsed.inMinutes;
    final s = _elapsed.inSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isUrgent ? AppColors.error.withValues(alpha: 0.6) : AppColors.borderDark,
          width: _isUrgent ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          // Ticket header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _isUrgent ? AppColors.error.withValues(alpha: 0.08) : columnColor.withValues(alpha: 0.06),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              border: Border(bottom: BorderSide(color: AppColors.borderDark)),
            ),
            child: Row(
              children: [
                // Order number
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: columnColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('#${order.orderNumber}', style: TextStyle(color: columnColor, fontWeight: FontWeight.w800, fontSize: 13)),
                ),
                const SizedBox(width: 10),
                Text(order.tableId ?? 'N/A', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                const Spacer(),
                if (_isUrgent) ...[
                  const Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.error),
                  const SizedBox(width: 4),
                ],
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isUrgent ? AppColors.error.withValues(alpha: 0.15) : AppColors.backgroundDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _formatElapsed(),
                    style: TextStyle(
                      color: _isUrgent ? AppColors.error : AppColors.textSecondaryDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Items
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: order.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 22, height: 22,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundDark,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: Text('${item.quantity}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                          if (item.notes != null && item.notes!.isNotEmpty)
                            Text(item.notes!, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),

          // Action button
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: columnColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 0,
                ),
                onPressed: () {},
                child: Text(
                  order.status == OrderStatus.pending ? 'Start Preparing' : order.status == OrderStatus.preparing ? 'Mark Ready' : 'Complete',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
