import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  static const _employees = [
    {'name': 'Ahmed Khalil', 'role': 'Manager', 'status': 'Active', 'email': 'ahmed@servio.com', 'shift': 'Morning'},
    {'name': 'Sara Mansour', 'role': 'Cashier', 'status': 'Active', 'email': 'sara@servio.com', 'shift': 'Morning'},
    {'name': 'Omar Belhaj', 'role': 'Waiter', 'status': 'Active', 'email': 'omar@servio.com', 'shift': 'Evening'},
    {'name': 'Layla Rami', 'role': 'Chef', 'status': 'On Leave', 'email': 'layla@servio.com', 'shift': 'Morning'},
    {'name': 'Youssef Tazi', 'role': 'Waiter', 'status': 'Inactive', 'email': 'youssef@servio.com', 'shift': 'Evening'},
  ];

  Color _statusColor(String s) {
    switch (s) {
      case 'Active': return AppColors.success;
      case 'On Leave': return AppColors.warning;
      case 'Inactive': return AppColors.textSecondaryLight;
      default: return AppColors.textSecondaryLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add Employee', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 20),
            color: Colors.white,
            child: const Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Employees', style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w800, fontSize: 22)),
                    SizedBox(height: 2),
                    Text('Manage your restaurant staff', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderLight),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(28),
              itemCount: _employees.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final e = _employees[i];
                final initials = (e['name'] as String).split(' ').map((w) => w[0]).take(2).join();
                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderLight)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22, backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: Text(initials, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 14)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e['name'] as String, style: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w700, fontSize: 14)),
                            Text(e['email'] as String, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 12)),
                          ],
                        ),
                      ),
                      _Badge(label: e['role'] as String, color: AppColors.info),
                      const SizedBox(width: 12),
                      _Badge(label: e['shift'] as String, color: AppColors.warning),
                      const SizedBox(width: 12),
                      _Badge(label: e['status'] as String, color: _statusColor(e['status'] as String)),
                      const SizedBox(width: 16),
                      IconButton(icon: const Icon(Icons.more_vert_rounded, size: 18, color: AppColors.textSecondaryLight), onPressed: () {}),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
