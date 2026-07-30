import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/table_entity.dart';
import '../../../../core/theme/app_colors.dart';

final _mockTables = [
  const TableEntity(id: 't1', name: '1', zone: 'Main', capacity: 4, status: TableStatus.available),
  const TableEntity(id: 't2', name: '2', zone: 'Main', capacity: 2, status: TableStatus.occupied),
  const TableEntity(id: 't3', name: '3', zone: 'Main', capacity: 6, status: TableStatus.reserved),
  const TableEntity(id: 't4', name: '4', zone: 'Main', capacity: 4, status: TableStatus.available),
  const TableEntity(id: 't5', name: '5', zone: 'Main', capacity: 8, status: TableStatus.occupied),
  const TableEntity(id: 't6', name: '6', zone: 'Main', capacity: 4, status: TableStatus.available),
  const TableEntity(id: 't7', name: '7', zone: 'Main', capacity: 2, status: TableStatus.reserved),
  const TableEntity(id: 't8', name: '8', zone: 'Main', capacity: 4, status: TableStatus.available),
  const TableEntity(id: 't9', name: '9', zone: 'Patio', capacity: 4, status: TableStatus.available),
  const TableEntity(id: 't10', name: '10', zone: 'Patio', capacity: 6, status: TableStatus.occupied),
  const TableEntity(id: 't11', name: '11', zone: 'Patio', capacity: 4, status: TableStatus.available),
  const TableEntity(id: 't12', name: '12', zone: 'VIP', capacity: 8, status: TableStatus.reserved),
];

class TablesScreen extends ConsumerStatefulWidget {
  const TablesScreen({super.key});

  @override
  ConsumerState<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends ConsumerState<TablesScreen> {
  String _selectedFloor = 'Floor 1';
  String? _selectedTableId;

  final _floors = ['Floor 1', 'Floor 2', 'Patio', 'VIP'];

  TableEntity? get _selectedTable {
    if (_selectedTableId == null) return null;
    try { return _mockTables.firstWhere((t) => t.id == _selectedTableId); }
    catch (_) { return null; }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Row(
        children: [
          // ── Main floor area ─────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Container(
                  padding: const EdgeInsets.fromLTRB(28, 24, 28, 16),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceDark,
                    border: Border(bottom: BorderSide(color: AppColors.borderDark)),
                  ),
                  child: Row(
                    children: [
                      // Floor selector
                      Row(
                        children: _floors.map((f) {
                          final sel = f == _selectedFloor;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedFloor = f),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: sel ? AppColors.primary : AppColors.backgroundDark,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: sel ? AppColors.primary : AppColors.borderDark),
                              ),
                              child: Text(f, style: TextStyle(color: sel ? Colors.white : AppColors.textSecondaryDark, fontWeight: sel ? FontWeight.w700 : FontWeight.w500, fontSize: 13)),
                            ),
                          );
                        }).toList(),
                      ),
                      const Spacer(),
                      // Legend
                      _LegendDot(color: AppColors.success, label: 'Available'),
                      const SizedBox(width: 16),
                      _LegendDot(color: AppColors.error, label: 'Occupied'),
                      const SizedBox(width: 16),
                      _LegendDot(color: AppColors.warning, label: 'Reserved'),
                      const SizedBox(width: 16),
                      _LegendDot(color: AppColors.textSecondaryDark, label: 'Cleaning'),
                      const SizedBox(width: 20),
                      // Add table
                      Container(
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                        child: IconButton(
                          icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                          onPressed: () {},
                          tooltip: 'Add Table',
                        ),
                      ),
                    ],
                  ),
                ),

                // Floor grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(32),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 220,
                      mainAxisSpacing: 32,
                      crossAxisSpacing: 32,
                      childAspectRatio: 1,
                    ),
                    itemCount: _mockTables.length,
                    itemBuilder: (context, i) {
                      final table = _mockTables[i];
                      final isSelected = _selectedTableId == table.id;
                      return _TableWidget(
                        table: table,
                        isSelected: isSelected,
                        onTap: () => setState(() => _selectedTableId = isSelected ? null : table.id),
                      ).animate(key: ValueKey(table.id)).scale(delay: (i * 40).ms, duration: 300.ms, curve: Curves.easeOutBack);
                    },
                  ),
                ),
              ],
            ),
          ),

          // ── Side panel ──────────────────────────────────────────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: _selectedTable != null ? 280 : 0,
            child: _selectedTable != null ? _TableDetailPanel(table: _selectedTable!, onClose: () => setState(() => _selectedTableId = null)) : null,
          ),
        ],
      ),
    );
  }
}

// ── Table Widget (CustomPainter) ────────────────────────────────────────────────
class _TableWidget extends StatelessWidget {
  final TableEntity table;
  final bool isSelected;
  final VoidCallback onTap;
  const _TableWidget({required this.table, required this.isSelected, required this.onTap});

  Color get _color {
    switch (table.status) {
      case TableStatus.available: return AppColors.success;
      case TableStatus.occupied:  return AppColors.error;
      case TableStatus.reserved:  return AppColors.warning;
    }
  }

  String get _label {
    switch (table.status) {
      case TableStatus.available: return 'Free';
      case TableStatus.occupied:  return 'Busy';
      case TableStatus.reserved:  return 'Rsv';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: isSelected
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: _color.withValues(alpha: 0.45), blurRadius: 20, spreadRadius: 2)],
              )
            : null,
        child: CustomPaint(
          painter: _TablePainter(
            color: _color,
            capacity: table.capacity,
            isSelected: isSelected,
            label: table.name,
            statusLabel: _label,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

// ── Table Painter ─────────────────────────────────────────────────────────────
class _TablePainter extends CustomPainter {
  final Color color;
  final int capacity;
  final bool isSelected;
  final String label;
  final String statusLabel;

  _TablePainter({required this.color, required this.capacity, required this.isSelected, required this.label, required this.statusLabel});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final cx = size.width / 2;
    final cy = size.height / 2;

    final tableW  = size.width  * 0.46;
    final tableH  = size.height * 0.34;
    final chairW  = size.width  * 0.13;
    final chairH  = size.height * 0.10;

    final tableFill = Paint()..color = color.withValues(alpha: isSelected ? 0.28 : 0.16);
    final tableBorder = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = isSelected ? 2.5 : 1.8;
    final chairFill = Paint()..color = color.withValues(alpha: isSelected ? 0.36 : 0.22);
    final chairBorder = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    // Chair counts by capacity
    final topCount    = capacity >= 6 ? 2 : 1;
    final bottomCount = capacity >= 6 ? 2 : 1;
    final sideCount   = capacity >= 4 ? 1 : 0;

    void drawChair(Rect r) {
      final rr = RRect.fromRectAndRadius(r, const Radius.circular(4));
      canvas.drawRRect(rr, chairFill);
      canvas.drawRRect(rr, chairBorder);
    }

    // Top chairs
    final topY = cy - tableH / 2 - chairH - 5;
    for (int i = 0; i < topCount; i++) {
      final offset = topCount == 1 ? 0.0 : (i == 0 ? -tableW * 0.22 : tableW * 0.22);
      drawChair(Rect.fromCenter(center: Offset(cx + offset, topY + chairH / 2), width: chairW, height: chairH));
    }

    // Bottom chairs
    final botY = cy + tableH / 2 + 5;
    for (int i = 0; i < bottomCount; i++) {
      final offset = bottomCount == 1 ? 0.0 : (i == 0 ? -tableW * 0.22 : tableW * 0.22);
      drawChair(Rect.fromCenter(center: Offset(cx + offset, botY + chairH / 2), width: chairW, height: chairH));
    }

    // Left chair
    if (sideCount > 0) {
      drawChair(Rect.fromCenter(
        center: Offset(cx - tableW / 2 - chairH / 2 - 5, cy),
        width: chairH, height: chairW,
      ));
    }

    // Right chair
    if (sideCount > 0) {
      drawChair(Rect.fromCenter(
        center: Offset(cx + tableW / 2 + chairH / 2 + 5, cy),
        width: chairH, height: chairW,
      ));
    }

    // Table surface
    final tableRect = Rect.fromCenter(center: Offset(cx, cy), width: tableW, height: tableH);
    final tableRR = RRect.fromRectAndRadius(tableRect, const Radius.circular(7));
    canvas.drawRRect(tableRR, tableFill);
    canvas.drawRRect(tableRR, tableBorder);

    // Table number (centered on surface)
    final numPainter = TextPainter(
      text: TextSpan(text: label, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: size.width * 0.19)),
      textDirection: TextDirection.ltr,
    )..layout();
    numPainter.paint(canvas, Offset(cx - numPainter.width / 2, cy - numPainter.height / 2));

    // Status label — below the bottom chairs
    final stPainter = TextPainter(
      text: TextSpan(text: statusLabel, style: TextStyle(color: color.withValues(alpha: 0.75), fontWeight: FontWeight.w600, fontSize: size.width * 0.09)),
      textDirection: TextDirection.ltr,
    )..layout();
    final statusY = botY + chairH + 4;
    stPainter.paint(canvas, Offset(cx - stPainter.width / 2, statusY));
  }

  @override
  bool shouldRepaint(_TablePainter old) =>
      old.color != color || old.isSelected != isSelected || old.capacity != capacity;
}

// ── Table Detail Panel ────────────────────────────────────────────────────────
class _TableDetailPanel extends StatelessWidget {
  final TableEntity table;
  final VoidCallback onClose;
  const _TableDetailPanel({required this.table, required this.onClose});

  Color get _statusColor {
    switch (table.status) {
      case TableStatus.available: return AppColors.success;
      case TableStatus.occupied: return AppColors.error;
      case TableStatus.reserved: return AppColors.warning;
    }
  }

  String get _statusLabel {
    switch (table.status) {
      case TableStatus.available: return 'Available';
      case TableStatus.occupied: return 'Occupied';
      case TableStatus.reserved: return 'Reserved';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(left: BorderSide(color: AppColors.borderDark)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Table ${table.name}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(_statusLabel, style: TextStyle(color: _statusColor, fontWeight: FontWeight.w600, fontSize: 12)),
                    ),
                  ],
                ),
                IconButton(onPressed: onClose, icon: const Icon(Icons.close_rounded, color: AppColors.textSecondaryDark)),
              ],
            ),
          ),

          const Divider(color: AppColors.borderDark, height: 1),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (table.status == TableStatus.occupied) ...[
                  _InfoRow(label: 'Order', value: '#1058'),
                  _InfoRow(label: 'Guests', value: '2'),
                  _InfoRow(label: 'Started', value: '12:45 PM'),
                  _InfoRow(label: 'Waiter', value: 'Michael'),
                  _InfoRow(label: 'Amount', value: '\$85.20'),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {},
                      child: const Text('View Order', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.borderDark),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {},
                      child: const Text('Transfer', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ] else ...[
                  _InfoRow(label: 'Capacity', value: '${table.capacity} seats'),
                  _InfoRow(label: 'Zone', value: table.zone),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {},
                      child: const Text('Start Order', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ).animate().slideX(begin: 1, duration: 250.ms, curve: Curves.easeOut).fadeIn();
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 13)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
      ],
    );
  }
}
