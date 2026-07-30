import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_colors.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _selectedRange = 'May 10 - May 11, 2024';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // ── Header ─────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Reports & Analytics', style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w800, fontSize: 22)),
                    Row(
                      children: [
                        // Date range
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.borderLight),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.textSecondaryLight),
                              const SizedBox(width: 8),
                              Text(_selectedRange, style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 13, fontWeight: FontWeight.w500)),
                              const SizedBox(width: 8),
                              const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textSecondaryLight),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Export button
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.upload_rounded, size: 16),
                          label: const Text('Export', style: TextStyle(fontWeight: FontWeight.w700)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Tabs
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondaryLight,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 2,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Sales'),
                    Tab(text: 'Orders'),
                    Tab(text: 'Products'),
                    Tab(text: 'Customers'),
                  ],
                ),
              ],
            ),
          ),

          // ── Content ────────────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _OverviewTab(),
                _PlaceholderTab(label: 'Sales Details'),
                _PlaceholderTab(label: 'Order History'),
                _PlaceholderTab(label: 'Product Analytics'),
                _PlaceholderTab(label: 'Customer Insights'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Overview Tab ──────────────────────────────────────────────────────────────
class _OverviewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          // KPI Row
          Row(
            children: [
              Expanded(child: _ReportKpi(label: 'Total Revenue', value: '\$58,246.25', trend: '+7.2%', sub: 'vs last period')),
              const SizedBox(width: 16),
              Expanded(child: _ReportKpi(label: 'Total Orders', value: '1,245', trend: '+4.2%', sub: 'vs last period')),
              const SizedBox(width: 16),
              Expanded(child: _ReportKpi(label: 'Total Customers', value: '892', trend: '+6.3%', sub: 'vs last period')),
              const SizedBox(width: 16),
              Expanded(child: _ReportKpi(label: 'Average Order', value: '\$46.78', trend: '+10.7%', sub: 'vs last period')),
            ],
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05),
          const SizedBox(height: 24),

          // Charts row
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Revenue trend
                Expanded(
                  flex: 3,
                  child: _ChartCard(
                    title: 'Revenue Trend',
                    subtitle: '\$58,246',
                    child: const _ReportLineChart(),
                  ),
                ),
                const SizedBox(width: 20),
                // Category breakdown
                Expanded(
                  flex: 2,
                  child: _ChartCard(
                    title: 'Sales by Category',
                    subtitle: '\$58,246',
                    child: const _PieChartWidget(),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.05),
          const SizedBox(height: 24),

          // Recent transactions table
          _ChartCard(
            title: 'Recent Transactions',
            subtitle: '',
            child: _TransactionTable(),
          ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.05),
        ],
      ),
    );
  }
}

class _ReportKpi extends StatelessWidget {
  final String label, value, trend, sub;
  const _ReportKpi({required this.label, required this.value, required this.trend, required this.sub});

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
          Text(label, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13)),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_upward_rounded, size: 10, color: AppColors.success),
                    const SizedBox(width: 2),
                    Text(trend, style: const TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Text(sub, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title, subtitle;
  final Widget child;
  const _ChartCard({required this.title, required this.subtitle, required this.child});

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w700, fontSize: 15)),
                  if (subtitle.isNotEmpty)
                    Text(subtitle, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13)),
                ],
              ),
              const Icon(Icons.more_horiz, color: AppColors.textSecondaryLight),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _ReportLineChart extends StatelessWidget {
  const _ReportLineChart();

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 200, child: CustomPaint(painter: _ReportLinePainter()));
  }
}

class _ReportLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()..color = AppColors.borderLight..strokeWidth = 0.5;
    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final data = [0.4, 0.55, 0.45, 0.7, 0.6, 0.85, 0.75, 0.9, 0.8, 0.95];
    final fill = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.primary.withValues(alpha: 0.2), AppColors.primary.withValues(alpha: 0.0)],
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final line = Paint()..color = AppColors.primary..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;

    final path = Path(), fillPath = Path();
    final step = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * step;
      final y = size.height * (1 - data[i]);
      if (i == 0) { path.moveTo(x, y); fillPath.moveTo(x, size.height); fillPath.lineTo(x, y); }
      else {
        final prev = Offset((i - 1) * step, size.height * (1 - data[i - 1]));
        final curr = Offset(x, y);
        path.cubicTo(prev.dx + step * 0.4, prev.dy, curr.dx - step * 0.4, curr.dy, curr.dx, curr.dy);
        fillPath.cubicTo(prev.dx + step * 0.4, prev.dy, curr.dx - step * 0.4, curr.dy, curr.dx, curr.dy);
      }
    }
    fillPath.lineTo(size.width, size.height); fillPath.close();
    canvas.drawPath(fillPath, fill);
    canvas.drawPath(path, line);

    // x-axis labels
    final labels = ['May 10', '', '', '', 'May 14', '', '', '', 'May 18', 'May 20'];
    for (int i = 0; i < labels.length; i++) {
      if (labels[i].isEmpty) continue;
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 10)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(i * step - tp.width / 2, size.height + 6));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PieChartWidget extends StatelessWidget {
  const _PieChartWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        children: [
          Expanded(child: CustomPaint(painter: _PieChartPainter())),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PieLegend(color: const Color(0xFFFF6B6B), label: 'Food', value: '\$41,200'),
              const SizedBox(height: 8),
              _PieLegend(color: AppColors.info, label: 'Beverages', value: '\$11,800'),
              const SizedBox(height: 8),
              _PieLegend(color: AppColors.warning, label: 'Snacks', value: '\$3,200'),
              const SizedBox(height: 8),
              _PieLegend(color: AppColors.success, label: 'Desserts', value: '\$2,046'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PieLegend extends StatelessWidget {
  final Color color;
  final String label, value;
  const _PieLegend({required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 12)),
        const SizedBox(width: 6),
        Text(value, style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 12, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;
    final segments = [
      (const Color(0xFFFF6B6B), 0.71),
      (AppColors.info, 0.20),
      (AppColors.warning, 0.055),
      (AppColors.success, 0.035),
    ];
    double startAngle = -math.pi / 2;
    for (final seg in segments) {
      final paint = Paint()..color = seg.$1..style = PaintingStyle.fill;
      final sweep = 2 * math.pi * seg.$2;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweep - 0.04, true, paint);
      startAngle += sweep;
    }
    // Center hole
    canvas.drawCircle(center, radius * 0.5, Paint()..color = Colors.white);
    final tp = TextPainter(
      text: const TextSpan(
        children: [
          TextSpan(text: '\$58,246\n', style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w800, fontSize: 12)),
          TextSpan(text: 'Total', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 10)),
        ],
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: radius);
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TransactionTable extends StatelessWidget {
  final _rows = const [
    ['#1058', 'Table 5', 'Dine In', '\$85.20', 'Completed'],
    ['#1057', 'Table 12', 'Dine In', '\$120.50', 'Completed'],
    ['#1056', 'Table 3', 'Takeaway', '\$65.80', 'Completed'],
    ['#1055', 'Table 1', 'Dine In', '\$45.30', 'Cancelled'],
    ['#1054', 'Takeaway', 'Delivery', '\$28.40', 'Completed'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
          child: const Row(
            children: [
              Expanded(flex: 1, child: Text('Order #', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w600))),
              Expanded(flex: 2, child: Text('Table', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w600))),
              Expanded(flex: 2, child: Text('Type', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w600))),
              Expanded(flex: 1, child: Text('Amount', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w600))),
              Expanded(flex: 2, child: Text('Status', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w600))),
            ],
          ),
        ),
        ..._rows.map((row) => Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
          child: Row(
            children: [
              Expanded(flex: 1, child: Text(row[0], style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 13, fontWeight: FontWeight.w600))),
              Expanded(flex: 2, child: Text(row[1], style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13))),
              Expanded(flex: 2, child: Text(row[2], style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13))),
              Expanded(flex: 1, child: Text(row[3], style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 13, fontWeight: FontWeight.w700))),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: row[4] == 'Completed' ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(row[4], style: TextStyle(color: row[4] == 'Completed' ? AppColors.success : AppColors.error, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String label;
  const _PlaceholderTab({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bar_chart_rounded, size: 64, color: AppColors.borderLight),
          const SizedBox(height: 16),
          Text(label, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text('Coming soon', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 14)),
        ],
      ),
    );
  }
}
