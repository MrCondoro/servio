import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Settings', style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w800, fontSize: 22)),
                    SizedBox(height: 4),
                    Text('Configure your restaurant platform', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 14)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.save_rounded, size: 16),
                  label: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _SettingsGroup(
                        title: 'Restaurant Information',
                        icon: Icons.store_rounded,
                        children: [
                          _SettingsField(label: 'Restaurant Name', value: 'Bella Vista Restaurant'),
                          _SettingsField(label: 'Phone', value: '+1 (555) 123-4567'),
                          _SettingsField(label: 'Email', value: 'info@bellavista.com'),
                          _SettingsField(label: 'Address', value: '123 Main St, Downtown'),
                          _SettingsField(label: 'Currency', value: 'USD (\$)'),
                        ],
                      ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05),
                      const SizedBox(height: 20),
                      _SettingsGroup(
                        title: 'Tax & Pricing',
                        icon: Icons.calculate_rounded,
                        children: [
                          _SettingsField(label: 'Tax Rate (%)', value: '8.0'),
                          _SettingsField(label: 'Service Charge (%)', value: '10.0'),
                          _SettingsToggle(label: 'Include tax in prices', value: false, onChanged: (_) {}),
                          _SettingsToggle(label: 'Show tax breakdown', value: true, onChanged: (_) {}),
                        ],
                      ).animate().fadeIn(duration: 300.ms, delay: 100.ms).slideY(begin: 0.05),
                      const SizedBox(height: 20),
                      _SettingsGroup(
                        title: 'Payment Methods',
                        icon: Icons.payment_rounded,
                        children: [
                          _SettingsToggle(label: 'Cash', value: true, onChanged: (_) {}),
                          _SettingsToggle(label: 'Credit / Debit Card', value: true, onChanged: (_) {}),
                          _SettingsToggle(label: 'Mobile Payments (Apple Pay, Google Pay)', value: true, onChanged: (_) {}),
                          _SettingsToggle(label: 'Online Orders', value: false, onChanged: (_) {}),
                        ],
                      ).animate().fadeIn(duration: 300.ms, delay: 200.ms).slideY(begin: 0.05),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      _SettingsGroup(
                        title: 'Notifications',
                        icon: Icons.notifications_rounded,
                        children: [
                          _SettingsToggle(label: 'New Order Alerts', value: true, onChanged: (_) {}),
                          _SettingsToggle(label: 'Low Stock Alerts', value: true, onChanged: (_) {}),
                          _SettingsToggle(label: 'Daily Revenue Summary', value: true, onChanged: (_) {}),
                          _SettingsToggle(label: 'Employee Clock-In Alerts', value: false, onChanged: (_) {}),
                          _SettingsToggle(label: 'Customer Feedback', value: true, onChanged: (_) {}),
                        ],
                      ).animate().fadeIn(duration: 300.ms, delay: 100.ms).slideY(begin: 0.05),
                      const SizedBox(height: 20),
                      _SettingsGroup(
                        title: 'Receipt Settings',
                        icon: Icons.receipt_long_rounded,
                        children: [
                          _SettingsField(label: 'Receipt Header', value: 'Thank you for dining with us!'),
                          _SettingsField(label: 'Footer Note', value: 'Visit us again!'),
                          _SettingsToggle(label: 'Print receipt automatically', value: false, onChanged: (_) {}),
                          _SettingsToggle(label: 'Send email receipt', value: true, onChanged: (_) {}),
                        ],
                      ).animate().fadeIn(duration: 300.ms, delay: 200.ms).slideY(begin: 0.05),
                      const SizedBox(height: 20),
                      _SettingsGroup(
                        title: 'Security',
                        icon: Icons.security_rounded,
                        children: [
                          _SettingsButton(label: 'Change Password', icon: Icons.lock_reset_rounded),
                          _SettingsButton(label: 'Two-Factor Authentication', icon: Icons.phonelink_lock_rounded),
                          _SettingsButton(label: 'Session Management', icon: Icons.devices_rounded),
                          _SettingsToggle(label: 'Auto-lock after 5 minutes', value: true, onChanged: (_) {}),
                        ],
                      ).animate().fadeIn(duration: 300.ms, delay: 300.ms).slideY(begin: 0.05),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Settings Group ─────────────────────────────────────────────────────────────
class _SettingsGroup extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  const _SettingsGroup({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
            child: Row(
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 17, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w700, fontSize: 15)),
              ],
            ),
          ),
          const Divider(color: AppColors.borderLight, height: 1),
          ...children,
        ],
      ),
    );
  }
}

class _SettingsField extends StatelessWidget {
  final String label, value;
  const _SettingsField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13)),
          Row(
            children: [
              Text(value, style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              const Icon(Icons.edit_outlined, size: 15, color: AppColors.textSecondaryLight),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsToggle extends StatefulWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SettingsToggle({required this.label, required this.value, required this.onChanged});

  @override
  State<_SettingsToggle> createState() => _SettingsToggleState();
}

class _SettingsToggleState extends State<_SettingsToggle> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.label, style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 13)),
          Switch(
            value: _value,
            activeColor: AppColors.primary,
            onChanged: (v) { setState(() => _value = v); widget.onChanged(v); },
          ),
        ],
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SettingsButton({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderLight))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.textSecondaryLight),
              const SizedBox(width: 10),
              Text(label, style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 13)),
            ],
          ),
          const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textSecondaryLight),
        ],
      ),
    );
  }
}
