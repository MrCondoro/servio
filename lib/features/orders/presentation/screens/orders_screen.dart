import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  String _search = '';

  final _tabs = const ['All', 'Pending', 'Preparing', 'Ready', 'Completed', 'Cancelled'];

  static const _orders = [
    {'id': '#1042', 'table': 'Table 3',  'type': 'Dine-In',  'items': 4, 'total': 48.50, 'status': 'Pending',   'time': '2 min ago',  'customer': 'Ahmed K.'},
    {'id': '#1041', 'table': 'Table 7',  'type': 'Dine-In',  'items': 2, 'total': 22.00, 'status': 'Preparing', 'time': '8 min ago',  'customer': 'Sara M.'},
    {'id': '#1040', 'table': 'Takeaway', 'type': 'Takeaway', 'items': 3, 'total': 35.99, 'status': 'Ready',     'time': '15 min ago', 'customer': 'Omar B.'},
    {'id': '#1039', 'table': 'Table 1',  'type': 'Dine-In',  'items': 6, 'total': 72.50, 'status': 'Completed', 'time': '32 min ago', 'customer': 'Layla R.'},
    {'id': '#1038', 'table': 'Delivery', 'type': 'Delivery', 'items': 2, 'total': 28.00, 'status': 'Cancelled', 'time': '45 min ago', 'customer': 'Youssef T.'},
    {'id': '#1037', 'table': 'Table 5',  'type': 'Dine-In',  'items': 5, 'total': 61.00, 'status': 'Completed', 'time': '1h ago',     'customer': 'Nadia H.'},
    {'id': '#1036', 'table': 'Table 2',  'type': 'Dine-In',  'items': 3, 'total': 38.50, 'status': 'Preparing', 'time': '12 min ago', 'customer': 'Karim D.'},
    {'id': '#1035', 'table': 'Takeaway', 'type': 'Takeaway', 'items': 1, 'total': 12.99, 'status': 'Pending',   'time': '3 min ago',  'customer': 'Fatima L.'},
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    final tab = _tabs[_tabCtrl.index];
    return _orders.where((o) {
      final matchTab = tab == 'All' || o['status'] == tab;
      final matchSearch = _search.isEmpty ||
          (o['id'] as String).toLowerCase().contains(_search.toLowerCase()) ||
          (o['customer'] as String).toLowerCase().contains(_search.toLowerCase()) ||
          (o['table'] as String).toLowerCase().contains(_search.toLowerCase());
      return matchTab && matchSearch;
    }).toList();
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'Pending':   return const Color(0xFFF59E0B);
      case 'Preparing': return AppColors.info;
      case 'Ready':     return AppColors.success;
      case 'Completed': return AppColors.textSecondaryLight;
      case 'Cancelled': return AppColors.error;
      default:          return AppColors.textSecondaryLight;
    }
  }

  IconData _statusIcon(String s) {
    switch (s) {
      case 'Pending':   return Icons.hourglass_empty_rounded;
      case 'Preparing': return Icons.restaurant_rounded;
      case 'Ready':     return Icons.check_circle_outline_rounded;
      case 'Completed': return Icons.done_all_rounded;
      case 'Cancelled': return Icons.cancel_outlined;
      default:          return Icons.circle;
    }
  }

  Color _typeColor(String t) {
    switch (t) {
      case 'Takeaway': return const Color(0xFF8B5CF6);
      case 'Delivery': return const Color(0xFF3B82F6);
      default:         return AppColors.primary;
    }
  }

  IconData _typeIcon(String t) {
    switch (t) {
      case 'Takeaway': return Icons.shopping_bag_outlined;
      case 'Delivery': return Icons.delivery_dining_rounded;
      default:         return Icons.restaurant_rounded;
    }
  }

  Map<String, int> get _counts {
    return {for (final tab in _tabs) tab: tab == 'All' ? _orders.length : _orders.where((o) => o['status'] == tab).length};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Order', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Orders', style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w800, fontSize: 22)),
                        SizedBox(height: 2),
                        Text('Track and manage all restaurant orders', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 13)),
                      ],
                    ),
                    const Spacer(),
                    _QuickStat(label: 'Pending',   count: _counts['Pending']!,   color: const Color(0xFFF59E0B)),
                    const SizedBox(width: 10),
                    _QuickStat(label: 'Preparing', count: _counts['Preparing']!, color: AppColors.info),
                    const SizedBox(width: 10),
                    _QuickStat(label: 'Ready',     count: _counts['Ready']!,     color: AppColors.success),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 200, height: 38,
                      child: TextField(
                        onChanged: (v) => setState(() => _search = v),
                        decoration: InputDecoration(
                          hintText: 'Search orders...',
                          hintStyle: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13),
                          prefixIcon: const Icon(Icons.search_rounded, size: 16, color: AppColors.textSecondaryLight),
                          filled: true, fillColor: AppColors.backgroundLight, contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Tab bar ──────────────────────────────────────────────
                TabBar(
                  controller: _tabCtrl,
                  onTap: (_) => setState(() {}),
                  isScrollable: true,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondaryLight,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 2.5,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                  tabs: _tabs.map((t) {
                    final count = _counts[t]!;
                    final sel = _tabCtrl.index == _tabs.indexOf(t);
                    return Tab(
                      child: Row(
                        children: [
                          Text(t),
                          if (count > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: sel ? AppColors.primary.withValues(alpha: 0.12) : AppColors.backgroundLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text('$count', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: sel ? AppColors.primary : AppColors.textSecondaryLight)),
                            ),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // ── Grid ─────────────────────────────────────────────────────────
          Expanded(
            child: _filtered.isEmpty
                ? _EmptyState()
                : GridView.builder(
                    padding: const EdgeInsets.all(24),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 320,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      mainAxisExtent: 240,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) {
                      final o = _filtered[i];
                      return _OrderCard(
                        order: o,
                        statusColor: _statusColor(o['status'] as String),
                        statusIcon: _statusIcon(o['status'] as String),
                        typeColor: _typeColor(o['type'] as String),
                        typeIcon: _typeIcon(o['type'] as String),
                      ).animate().fadeIn(delay: (i * 40).ms, duration: 250.ms).scale(begin: const Offset(0.96, 0.96));
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Order Card ────────────────────────────────────────────────────────────────
class _OrderCard extends StatefulWidget {
  final Map<String, dynamic> order;
  final Color statusColor, typeColor;
  final IconData statusIcon, typeIcon;
  const _OrderCard({required this.order, required this.statusColor, required this.statusIcon, required this.typeColor, required this.typeIcon});

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    final sc = widget.statusColor;
    final tc = widget.typeColor;
    final initials = (o['customer'] as String).split(' ').map((w) => w[0]).take(2).join();

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _hovered ? sc : AppColors.borderLight, width: _hovered ? 1.5 : 1),
          boxShadow: _hovered
              ? [BoxShadow(color: sc.withValues(alpha: 0.12), blurRadius: 18, offset: const Offset(0, 6))]
              : [const BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top row: ID + status badge ────────────────────────────
              Row(
                children: [
                  Text(o['id'] as String,
                    style: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w800, fontSize: 15, fontFamily: 'monospace')),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: sc.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(widget.statusIcon, size: 12, color: sc),
                        const SizedBox(width: 4),
                        Text(o['status'] as String, style: TextStyle(color: sc, fontSize: 11, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ── Customer + type ───────────────────────────────────────
              Row(
                children: [
                  CircleAvatar(
                    radius: 16, backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(initials, style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(o['customer'] as String,
                          style: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w600, fontSize: 13),
                          overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(widget.typeIcon, size: 11, color: tc),
                            const SizedBox(width: 3),
                            Text(o['type'] as String, style: TextStyle(color: tc, fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(color: AppColors.borderLight, height: 1),
              const SizedBox(height: 10),

              // ── Stats row ─────────────────────────────────────────────
              Row(
                children: [
                  _MiniStat(icon: Icons.table_restaurant_rounded, label: o['table'] as String),
                  const SizedBox(width: 12),
                  _MiniStat(icon: Icons.receipt_long_rounded, label: '${o['items']} items'),
                  const Spacer(),
                  Text('\$${(o['total'] as double).toStringAsFixed(2)}',
                    style: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w800, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 10),

              // ── Footer: time + action ─────────────────────────────────
              Row(
                children: [
                  const Icon(Icons.access_time_rounded, size: 13, color: AppColors.textSecondaryLight),
                  const SizedBox(width: 4),
                  Text(o['time'] as String, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 12)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: _hovered ? sc : AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _hovered ? sc : AppColors.borderLight),
                      ),
                      child: Text('View',
                        style: TextStyle(color: _hovered ? Colors.white : AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w700)),
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
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MiniStat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondaryLight),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 12)),
      ],
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _QuickStat({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text('$label: ', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
          Text('$count', style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w800)),
        ],
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
            child: const Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: 20),
          const Text('No orders found', style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 8),
          const Text('Orders will appear here once placed.', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 14)),
        ],
      ),
    );
  }
}
