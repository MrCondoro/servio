import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_colors.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Greeting ──────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Good morning, John 👋',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white)),
                    SizedBox(height: 6),
                    Text("Here's what's happening in your restaurant today.",
                        style: TextStyle(fontSize: 14, color: AppColors.textSecondaryDark)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderDark),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 16, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text('Morning Shift', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                      SizedBox(width: 12),
                      Icon(Icons.open_in_full_rounded, size: 14, color: AppColors.textSecondaryDark),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // ── KPI Cards ─────────────────────────────────
            Row(
              children: [
                Expanded(child: _KpiCard(title: 'Total Revenue', value: '\$ 8,547.25', trend: '+12.5%', icon: Icons.attach_money_rounded)),
                const SizedBox(width: 16),
                Expanded(child: _KpiCard(title: 'Orders Today', value: '128', trend: '+8.2%', icon: Icons.receipt_long_rounded)),
                const SizedBox(width: 16),
                Expanded(child: _KpiCard(title: 'Customers', value: '96', trend: '+15.3%', icon: Icons.people_alt_rounded)),
                const SizedBox(width: 16),
                Expanded(child: _KpiCard(title: 'Average Order', value: '\$ 66.78', trend: '+10.1%', icon: Icons.trending_up_rounded)),
              ],
            ).animate().slideY(begin: 0.05, duration: 400.ms).fadeIn(),
            const SizedBox(height: 20),

            // ── Row 2: Revenue Chart + Orders Status + Top Items ──
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 5,
                    child: _DashCard(
                      title: 'Revenue Overview',
                      subtitle: '\$ 8,547.25',
                      subtitleExtra: '+12.5%',
                      action: 'This Week ▾',
                      child: const _LineChartPlaceholder(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: _DashCard(
                      title: 'Orders Status',
                      action: 'View all',
                      child: const _DonutChartPlaceholder(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 4,
                    child: _DashCard(
                      title: 'Top Selling Items',
                      action: 'View all',
                      child: Column(
                        children: [
                          _TopItem(rank: 1, name: 'Margherita Pizza', orders: '120 orders', revenue: '\$1,245.00'),
                          _TopItem(rank: 2, name: 'Cheese Burger', orders: '98 orders', revenue: '\$980.00'),
                          _TopItem(rank: 3, name: 'Caesar Salad', orders: '86 orders', revenue: '\$865.00'),
                          _TopItem(rank: 4, name: 'French Fries', orders: '65 orders', revenue: '\$650.00'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: 0.05, delay: 100.ms, duration: 400.ms).fadeIn(),
            const SizedBox(height: 20),

            // ── Row 3: Table Status + Recent Orders + Inventory Alerts ──
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _DashCard(
                      title: 'Table Status',
                      action: 'View floor plan',
                      child: const _TableStatusWidget(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _DashCard(
                      title: 'Recent Orders',
                      action: 'View all',
                      child: Column(
                        children: [
                          _RecentOrderRow(id: '#1058', table: 'Table 5', amount: '\$85.20', time: '2m ago', status: 'Completed'),
                          _RecentOrderRow(id: '#1057', table: 'Table 12', amount: '\$120.50', time: '5m ago', status: 'Preparing'),
                          _RecentOrderRow(id: '#1056', table: 'Table 3', amount: '\$65.80', time: '8m ago', status: 'Ready'),
                          _RecentOrderRow(id: '#1055', table: 'Table 1', amount: '\$45.30', time: '12m ago', status: 'Completed'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _DashCard(
                      title: 'Inventory Alerts',
                      action: 'View all',
                      child: Column(
                        children: [
                          _InventoryAlert(name: 'Mozzarella Cheese', stock: '2.5 kg left', status: 'Low Stock', critical: false),
                          _InventoryAlert(name: 'Tomato Sauce', stock: '1.2 L left', status: 'Low Stock', critical: false),
                          _InventoryAlert(name: 'Chicken Breast', stock: '0 kg left', status: 'Out of Stock', critical: true),
                          _InventoryAlert(name: 'Olive Oil', stock: '1.5 L left', status: 'Low Stock', critical: false),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: 0.05, delay: 200.ms, duration: 400.ms).fadeIn(),
          ],
        ),
      ),
    );
  }
}

// ── KPI Card ────────────────────────────────────────────────────────────────
class _KpiCard extends StatelessWidget {
  final String title, value, trend;
  final IconData icon;
  const _KpiCard({required this.title, required this.value, required this.trend, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 13, fontWeight: FontWeight.w500)),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_upward_rounded, size: 11, color: AppColors.success),
                    const SizedBox(width: 2),
                    Text(trend, style: const TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Text('vs yesterday', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Dashboard Card ───────────────────────────────────────────────────────────
class _DashCard extends StatelessWidget {
  final String title;
  final String? subtitle, subtitleExtra, action;
  final Widget child;
  const _DashCard({required this.title, this.subtitle, this.subtitleExtra, this.action, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                  if (subtitle != null)
                    Row(
                      children: [
                        Text(subtitle!, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                        if (subtitleExtra != null) ...[
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(subtitleExtra!, style: const TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ],
                    ),
                ],
              ),
              if (action != null)
                Text(action!, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

// ── Line Chart Placeholder ──────────────────────────────────────────────────
class _LineChartPlaceholder extends StatelessWidget {
  const _LineChartPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: CustomPaint(painter: _LineChartPainter()),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final gridPaint = Paint()
      ..color = AppColors.borderDark
      ..strokeWidth = 0.5;

    // Grid lines
    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Area fill
    final data = [0.6, 0.4, 0.7, 0.5, 0.8, 0.6, 0.9, 0.75, 0.85, 0.95, 0.7, 0.88];
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.primary.withValues(alpha: 0.3), AppColors.primary.withValues(alpha: 0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final fillPath = Path();
    final step = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * step;
      final y = size.height * (1 - data[i]);
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        final prev = Offset((i - 1) * step, size.height * (1 - data[i - 1]));
        final curr = Offset(x, y);
        final cp1 = Offset(prev.dx + step * 0.4, prev.dy);
        final cp2 = Offset(curr.dx - step * 0.4, curr.dy);
        path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, curr.dx, curr.dy);
        fillPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, curr.dx, curr.dy);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    // Dot at last point
    final dotPaint = Paint()..color = AppColors.primary;
    canvas.drawCircle(Offset(size.width, size.height * (1 - data.last)), 5, dotPaint);
    final innerDot = Paint()..color = AppColors.surfaceDark;
    canvas.drawCircle(Offset(size.width, size.height * (1 - data.last)), 2.5, innerDot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Donut Chart Placeholder ─────────────────────────────────────────────────
class _DonutChartPlaceholder extends StatelessWidget {
  const _DonutChartPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Row(
        children: [
          Expanded(
            child: CustomPaint(painter: _DonutPainter()),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LegendItem(color: AppColors.primary, label: 'Completed', value: '78'),
              const SizedBox(height: 8),
              _LegendItem(color: AppColors.warning, label: 'Preparing', value: '28'),
              const SizedBox(height: 8),
              _LegendItem(color: AppColors.info, label: 'Ready', value: '15'),
              const SizedBox(height: 8),
              _LegendItem(color: AppColors.error, label: 'Cancelled', value: '7'),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label, value;
  const _LegendItem({required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
        const SizedBox(width: 8),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Guard against degenerate zero-size during initial layout pass
    if (size.width <= 0 || size.height <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.max(1.0, math.min(size.width, size.height) / 2 - 8);
    const strokeWidth = 20.0;

    final segments = [
      (AppColors.primary, 0.61),
      (AppColors.warning, 0.22),
      (AppColors.info, 0.12),
      (AppColors.error, 0.05),
    ];

    double startAngle = -math.pi / 2;
    for (final seg in segments) {
      final paint = Paint()
        ..color = seg.$1
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      final sweepAngle = 2 * math.pi * seg.$2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle, sweepAngle - 0.05, false, paint,
      );
      startAngle += sweepAngle;
    }

    // Center text — only draw if there's enough space
    final safeMaxWidth = math.max(1.0, radius);
    final tp = TextPainter(
      text: const TextSpan(
        children: [
          TextSpan(text: '128\n', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)),
          TextSpan(text: 'Total Orders', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 10)),
        ],
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: safeMaxWidth);
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Top Selling Item ────────────────────────────────────────────────────────
class _TopItem extends StatelessWidget {
  final int rank;
  final String name, orders, revenue;
  const _TopItem({required this.rank, required this.name, required this.orders, required this.revenue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: rank == 1 ? AppColors.primary.withValues(alpha: 0.15) : AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text('$rank', style: TextStyle(color: rank == 1 ? AppColors.primary : AppColors.textSecondaryDark, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                Text(orders, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 11)),
              ],
            ),
          ),
          Text(revenue, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
        ],
      ),
    );
  }
}

// ── Table Status Widget ─────────────────────────────────────────────────────
class _TableStatusWidget extends StatelessWidget {
  const _TableStatusWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _StatChip(label: 'Total Tables', value: '24', color: AppColors.textSecondaryDark),
            const SizedBox(width: 12),
            _StatChip(label: 'Available', value: '8', color: AppColors.success),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _StatChip(label: 'Occupied', value: '14', color: AppColors.error),
            const SizedBox(width: 12),
            _StatChip(label: 'Reserved', value: '2', color: AppColors.warning),
          ],
        ),
        const SizedBox(height: 16),
        // Mini floor grid
        Wrap(
          spacing: 6, runSpacing: 6,
          children: List.generate(14, (i) {
            final status = i < 8 ? AppColors.success : (i < 12 ? AppColors.error : AppColors.warning);
            return Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: status.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: status.withValues(alpha: 0.4)),
              ),
              alignment: Alignment.center,
              child: Text('${i + 1}', style: TextStyle(color: status, fontSize: 11, fontWeight: FontWeight.bold)),
            );
          }),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

// ── Recent Order Row ────────────────────────────────────────────────────────
class _RecentOrderRow extends StatelessWidget {
  final String id, table, amount, time, status;
  const _RecentOrderRow({required this.id, required this.table, required this.amount, required this.time, required this.status});

  Color get _statusColor {
    switch (status) {
      case 'Completed': return AppColors.success;
      case 'Preparing': return AppColors.warning;
      case 'Ready': return AppColors.info;
      default: return AppColors.textSecondaryDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Text(id, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(width: 12),
          Expanded(child: Text(table, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 13))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(status, style: TextStyle(color: _statusColor, fontSize: 11, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 12),
          Text(amount, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(width: 8),
          Text(time, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 11)),
        ],
      ),
    );
  }
}

// ── Inventory Alert ─────────────────────────────────────────────────────────
class _InventoryAlert extends StatelessWidget {
  final String name, stock, status;
  final bool critical;
  const _InventoryAlert({required this.name, required this.stock, required this.status, required this.critical});

  @override
  Widget build(BuildContext context) {
    final color = critical ? AppColors.error : AppColors.warning;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(critical ? Icons.error_outline_rounded : Icons.warning_amber_rounded, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                Text(status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Text(stock, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 11)),
        ],
      ),
    );
  }
}
