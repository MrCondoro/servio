import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with TickerProviderStateMixin {
  int _step = 0;
  final _pageCtrl = PageController();

  // Step 1 — Personal Info
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  // Step 2 — Restaurant Info
  final _restNameCtrl = TextEditingController();
  String _bizType = 'Restaurant';
  Uint8List? _logoBytes;
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  String _country = 'Morocco';
  String _currency = 'MAD';

  // Step 3 — Configuration
  int _tables = 10;
  int _employees = 5;
  final Set<String> _serviceTypes = {'Dine-In'};
  final Map<String, TimeOfDay> _openTime = {'Mon': const TimeOfDay(hour: 9, minute: 0)};
  final Map<String, TimeOfDay> _closeTime = {'Mon': const TimeOfDay(hour: 23, minute: 0)};

  // Step 4 — Subscription
  String _plan = 'Professional';

  final List<GlobalKey<FormState>> _formKeys = List.generate(4, (_) => GlobalKey<FormState>());
  final ImagePicker _picker = ImagePicker();

  double get _passStrength {
    final p = _passCtrl.text;
    double s = 0;
    if (p.length >= 8) s += 0.25;
    if (p.contains(RegExp(r'[A-Z]'))) s += 0.25;
    if (p.contains(RegExp(r'[0-9]'))) s += 0.25;
    if (p.contains(RegExp(r'[!@#$%^&*]'))) s += 0.25;
    return s;
  }

  Color get _passStrengthColor {
    final s = _passStrength;
    if (s <= 0.25) return AppColors.error;
    if (s <= 0.5) return AppColors.warning;
    if (s <= 0.75) return const Color(0xFF84CC16);
    return AppColors.success;
  }

  String get _passStrengthLabel {
    final s = _passStrength;
    if (s <= 0.25) return 'Weak';
    if (s <= 0.5) return 'Fair';
    if (s <= 0.75) return 'Good';
    return 'Strong';
  }

  void _nextStep() {
    if (_step < 2 && !(_formKeys[_step].currentState?.validate() ?? true)) return;
    if (_step < 4) {
      setState(() => _step++);
      _pageCtrl.animateToPage(_step, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  void _prevStep() {
    if (_step > 0) {
      setState(() => _step--);
      _pageCtrl.animateToPage(_step, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  Future<void> _pickLogo() async {
    try {
      final f = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 512);
      if (f != null) {
        final bytes = await f.readAsBytes();
        setState(() => _logoBytes = bytes);
      }
    } catch (_) {}
  }

  void _register() {
    ref.read(authStateControllerProvider.notifier).register(
      _emailCtrl.text.trim(),
      _passCtrl.text,
      _nameCtrl.text.trim(),
      _logoBytes,
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose();
    _passCtrl.dispose(); _confirmCtrl.dispose(); _restNameCtrl.dispose();
    _addressCtrl.dispose(); _cityCtrl.dispose(); _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateControllerProvider);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 860;

    ref.listen(authStateControllerProvider, (_, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(next.error.toString()),
          backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating,
        ));
      } else if (next.hasValue && next.value != null && _step == 4) {
        // Already on success step
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Left stepper rail (desktop only)
          if (isDesktop) _StepRail(currentStep: _step),

          // Main content
          Expanded(
            child: Column(
              children: [
                // Progress bar
                _ProgressHeader(step: _step, total: 5),

                // Page content
                Expanded(
                  child: PageView(
                    controller: _pageCtrl,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _Step1Personal(
                        formKey: _formKeys[0], nameCtrl: _nameCtrl, emailCtrl: _emailCtrl,
                        phoneCtrl: _phoneCtrl, passCtrl: _passCtrl, confirmCtrl: _confirmCtrl,
                        obscurePass: _obscurePass, obscureConfirm: _obscureConfirm,
                        onTogglePass: () => setState(() => _obscurePass = !_obscurePass),
                        onToggleConfirm: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        passStrength: _passStrength, passStrengthColor: _passStrengthColor,
                        passStrengthLabel: _passStrengthLabel, onPassChanged: () => setState(() {}),
                      ),
                      _Step2Restaurant(
                        formKey: _formKeys[1], restNameCtrl: _restNameCtrl,
                        bizType: _bizType, onBizTypeChanged: (v) => setState(() => _bizType = v),
                        logoBytes: _logoBytes, onPickLogo: _pickLogo,
                        addressCtrl: _addressCtrl, cityCtrl: _cityCtrl,
                        country: _country, onCountryChanged: (v) => setState(() => _country = v),
                        currency: _currency, onCurrencyChanged: (v) => setState(() => _currency = v),
                      ),
                      _Step3Config(
                        tables: _tables, onTablesChanged: (v) => setState(() => _tables = v),
                        employees: _employees, onEmployeesChanged: (v) => setState(() => _employees = v),
                        serviceTypes: _serviceTypes, onServiceToggle: (s) => setState(() {
                          _serviceTypes.contains(s) ? _serviceTypes.remove(s) : _serviceTypes.add(s);
                        }),
                      ),
                      _Step4Subscription(
                        selectedPlan: _plan, onPlanChanged: (v) => setState(() => _plan = v),
                      ),
                      _Step5Success(onGoToDashboard: () => context.go('/dashboard')),
                    ],
                  ),
                ),

                // Navigation footer
                if (_step < 4)
                  _NavFooter(
                    step: _step,
                    isLoading: authState.isLoading,
                    onBack: _step == 0 ? () => context.go('/welcome') : _prevStep,
                    onNext: _step == 3 ? () { _nextStep(); _register(); } : _nextStep,
                    nextLabel: _step == 3 ? 'Start Free Trial' : 'Continue',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step Rail (Desktop sidebar) ───────────────────────────────────────────────
class _StepRail extends StatelessWidget {
  final int currentStep;
  const _StepRail({required this.currentStep});

  static const _steps = [
    (Icons.person_outline_rounded, 'Personal Info'),
    (Icons.store_outlined, 'Restaurant'),
    (Icons.tune_rounded, 'Configuration'),
    (Icons.star_outline_rounded, 'Subscription'),
    (Icons.check_circle_outline_rounded, 'Done'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: AppColors.backgroundDark,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Logo
          Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accent]), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.eco_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              const Text('Servio', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 48),

          ..._steps.asMap().entries.map((e) {
            final idx = e.key;
            final done = idx < currentStep;
            final active = idx == currentStep;
            return Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: Row(
                children: [
                  // Step circle
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done ? AppColors.primary : active ? AppColors.primary.withValues(alpha: 0.15) : Colors.transparent,
                      border: Border.all(
                        color: done || active ? AppColors.primary : AppColors.borderDark,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      done ? Icons.check_rounded : e.value.$1,
                      size: 17,
                      color: done ? Colors.white : active ? AppColors.primary : AppColors.textSecondaryDark,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Step ${idx + 1}', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 11, fontWeight: FontWeight.w500)),
                      Text(e.value.$2, style: TextStyle(
                        color: active ? Colors.white : done ? AppColors.accent : AppColors.textSecondaryDark,
                        fontSize: 13, fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                      )),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Progress Header ───────────────────────────────────────────────────────────
class _ProgressHeader extends StatelessWidget {
  final int step, total;
  const _ProgressHeader({required this.step, required this.total});

  static const _labels = ['Personal Info', 'Restaurant', 'Configuration', 'Subscription', 'Success'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Step ${step + 1} of $total — ${_labels[step]}',
                style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13, fontWeight: FontWeight.w500)),
              Text('${((step + 1) / total * 100).round()}%', style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (step + 1) / total,
              backgroundColor: AppColors.borderLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ── Navigation Footer ─────────────────────────────────────────────────────────
class _NavFooter extends StatelessWidget {
  final int step;
  final bool isLoading;
  final VoidCallback onBack, onNext;
  final String nextLabel;
  const _NavFooter({required this.step, required this.isLoading, required this.onBack, required this.onNext, required this.nextLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 28),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderLight))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded, size: 16),
            label: Text(step == 0 ? 'Back to Welcome' : 'Previous'),
            style: TextButton.styleFrom(foregroundColor: AppColors.textSecondaryLight),
          ),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: isLoading ? null : onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 28), elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(nextLabel, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STEP 1 — Personal Info
// ═══════════════════════════════════════════════════════════════════════════════
class _Step1Personal extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl, emailCtrl, phoneCtrl, passCtrl, confirmCtrl;
  final bool obscurePass, obscureConfirm;
  final VoidCallback onTogglePass, onToggleConfirm, onPassChanged;
  final double passStrength;
  final Color passStrengthColor;
  final String passStrengthLabel;

  const _Step1Personal({
    required this.formKey, required this.nameCtrl, required this.emailCtrl,
    required this.phoneCtrl, required this.passCtrl, required this.confirmCtrl,
    required this.obscurePass, required this.obscureConfirm,
    required this.onTogglePass, required this.onToggleConfirm, required this.onPassChanged,
    required this.passStrength, required this.passStrengthColor, required this.passStrengthLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Form(
        key: formKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StepTitle(title: 'Personal Information', subtitle: 'Start by creating your personal account.'),
              const SizedBox(height: 28),

              Row(
                children: [
                  Expanded(child: _Field(ctrl: nameCtrl, label: 'Full Name', hint: 'John Doe', icon: Icons.person_outline_rounded, validator: (v) => v!.isEmpty ? 'Required' : null)),
                  const SizedBox(width: 16),
                  Expanded(child: _Field(ctrl: phoneCtrl, label: 'Phone Number', hint: '+212 6XX XXX XXX', icon: Icons.phone_outlined)),
                ],
              ),
              const SizedBox(height: 16),

              _Field(ctrl: emailCtrl, label: 'Email Address', hint: 'you@restaurant.com', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress,
                validator: (v) => (v!.isEmpty || !v.contains('@')) ? 'Valid email required' : null),
              const SizedBox(height: 16),

              _Field(ctrl: passCtrl, label: 'Password', hint: '••••••••', icon: Icons.lock_outline_rounded,
                obscure: obscurePass, onToggleObscure: onTogglePass, onChanged: (_) => onPassChanged(),
                validator: (v) => (v!.length < 8) ? 'Min 8 characters' : null),
              const SizedBox(height: 8),

              // Password strength meter
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: passStrength, backgroundColor: AppColors.borderLight,
                      valueColor: AlwaysStoppedAnimation<Color>(passStrengthColor),
                      minHeight: 5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Strength:', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                      Text(passStrengthLabel, style: TextStyle(color: passStrengthColor, fontSize: 11, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _Field(ctrl: confirmCtrl, label: 'Confirm Password', hint: '••••••••', icon: Icons.lock_outline_rounded,
                obscure: obscureConfirm, onToggleObscure: onToggleConfirm,
                validator: (v) => v != passCtrl.text ? 'Passwords do not match' : null),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STEP 2 — Restaurant Info
// ═══════════════════════════════════════════════════════════════════════════════
class _Step2Restaurant extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController restNameCtrl, addressCtrl, cityCtrl;
  final String bizType, country, currency;
  final Uint8List? logoBytes;
  final ValueChanged<String> onBizTypeChanged, onCountryChanged, onCurrencyChanged;
  final VoidCallback onPickLogo;

  const _Step2Restaurant({
    required this.formKey, required this.restNameCtrl, required this.bizType,
    required this.onBizTypeChanged, required this.logoBytes, required this.onPickLogo,
    required this.addressCtrl, required this.cityCtrl, required this.country,
    required this.onCountryChanged, required this.currency, required this.onCurrencyChanged,
  });

  static const _bizTypes = ['Restaurant', 'Café', 'Snack', 'Bakery', 'Fast Food', 'Pizzeria', 'Coffee Shop', 'Food Truck', 'Bar', 'Other'];
  static const _countries = ['Morocco', 'Algeria', 'Tunisia', 'France', 'Spain', 'USA', 'UAE', 'Other'];
  static const _currencies = ['MAD', 'EUR', 'USD', 'GBP', 'DZD', 'TND', 'AED'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Form(
        key: formKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StepTitle(title: 'Restaurant Information', subtitle: 'Tell us about your business.'),
              const SizedBox(height: 28),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo upload
                  GestureDetector(
                    onTap: onPickLogo,
                    child: Container(
                      width: 96, height: 96,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderLight, style: BorderStyle.solid, width: 1.5),
                        image: logoBytes != null ? DecorationImage(image: MemoryImage(logoBytes!), fit: BoxFit.cover) : null,
                      ),
                      child: logoBytes == null ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_photo_alternate_outlined, color: AppColors.textSecondaryLight, size: 28),
                          const SizedBox(height: 4),
                          Text('Logo', style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                        ],
                      ) : null,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      children: [
                        _Field(ctrl: restNameCtrl, label: 'Restaurant Name', hint: 'Bella Vista', icon: Icons.store_outlined, validator: (v) => v!.isEmpty ? 'Required' : null),
                        const SizedBox(height: 12),
                        _DropField(label: 'Business Type', value: bizType, items: _bizTypes, onChanged: onBizTypeChanged),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              _Field(ctrl: addressCtrl, label: 'Address', hint: '123 Main Street', icon: Icons.location_on_outlined),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _Field(ctrl: cityCtrl, label: 'City', hint: 'Casablanca', icon: Icons.location_city_outlined)),
                  const SizedBox(width: 16),
                  Expanded(child: _DropField(label: 'Country', value: country, items: _countries, onChanged: onCountryChanged)),
                  const SizedBox(width: 16),
                  Expanded(child: _DropField(label: 'Currency', value: currency, items: _currencies, onChanged: onCurrencyChanged)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STEP 3 — Configuration
// ═══════════════════════════════════════════════════════════════════════════════
class _Step3Config extends StatelessWidget {
  final int tables, employees;
  final Set<String> serviceTypes;
  final ValueChanged<int> onTablesChanged, onEmployeesChanged;
  final ValueChanged<String> onServiceToggle;

  const _Step3Config({
    required this.tables, required this.onTablesChanged,
    required this.employees, required this.onEmployeesChanged,
    required this.serviceTypes, required this.onServiceToggle,
  });

  static const _services = [
    (Icons.restaurant_rounded, 'Dine-In'),
    (Icons.shopping_bag_outlined, 'Takeaway'),
    (Icons.delivery_dining_rounded, 'Delivery'),
    (Icons.directions_car_outlined, 'Drive-Thru'),
    (Icons.event_seat_rounded, 'Reservation'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StepTitle(title: 'Restaurant Configuration', subtitle: 'Set up your operational details.'),
            const SizedBox(height: 28),

            // Counters
            Row(
              children: [
                Expanded(child: _CounterCard(label: 'Tables', value: tables, icon: Icons.table_restaurant_rounded, onDecrement: () => onTablesChanged((tables - 1).clamp(1, 200)), onIncrement: () => onTablesChanged((tables + 1).clamp(1, 200)))),
                const SizedBox(width: 16),
                Expanded(child: _CounterCard(label: 'Employees', value: employees, icon: Icons.people_outlined, onDecrement: () => onEmployeesChanged((employees - 1).clamp(1, 500)), onIncrement: () => onEmployeesChanged((employees + 1).clamp(1, 500)))),
              ],
            ),
            const SizedBox(height: 28),

            const Text('Service Types', style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 4),
            Text('Select all the service types your restaurant offers.', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
            const SizedBox(height: 16),

            Wrap(
              spacing: 12, runSpacing: 12,
              children: _services.map((s) {
                final sel = serviceTypes.contains(s.$2);
                return GestureDetector(
                  onTap: () => onServiceToggle(s.$2),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.primary.withValues(alpha: 0.08) : AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: sel ? AppColors.primary : AppColors.borderLight, width: sel ? 1.5 : 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(s.$1, size: 18, color: sel ? AppColors.primary : AppColors.textSecondaryLight),
                        const SizedBox(width: 8),
                        Text(s.$2, style: TextStyle(color: sel ? AppColors.primary : AppColors.textPrimaryLight, fontWeight: sel ? FontWeight.w700 : FontWeight.w500, fontSize: 13)),
                        if (sel) ...[const SizedBox(width: 6), const Icon(Icons.check_circle_rounded, size: 15, color: AppColors.primary)],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),
            const Text('Opening Hours', style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 4),
            Text('Set when your restaurant is open for business.', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
            const SizedBox(height: 12),
            const _OpeningHoursPlanner(),
          ],
        ),
      ),
    );
  }
}

class _CounterCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final VoidCallback onDecrement, onIncrement;
  const _CounterCard({required this.label, required this.value, required this.icon, required this.onDecrement, required this.onIncrement});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onDecrement,
                child: Container(width: 32, height: 32, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.borderLight)), child: const Icon(Icons.remove, size: 16, color: AppColors.textSecondaryLight)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('$value', style: const TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w800, fontSize: 22)),
              ),
              GestureDetector(
                onTap: onIncrement,
                child: Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.add, size: 16, color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Opening Hours Planner ────────────────────────────────────────────────────
class _DaySchedule {
  String day;
  bool enabled;
  TimeOfDay open;
  TimeOfDay close;
  _DaySchedule({required this.day, this.enabled = true, required this.open, required this.close});
}

class _OpeningHoursPlanner extends StatefulWidget {
  const _OpeningHoursPlanner();

  @override
  State<_OpeningHoursPlanner> createState() => _OpeningHoursPlannerState();
}

class _OpeningHoursPlannerState extends State<_OpeningHoursPlanner> {
  bool _customMode = false;

  // Global times (Every Day mode)
  TimeOfDay _globalOpen = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _globalClose = const TimeOfDay(hour: 23, minute: 0);

  // Per-day schedule
  final List<_DaySchedule> _days = [
    _DaySchedule(day: 'Monday',    enabled: true,  open: const TimeOfDay(hour: 9, minute: 0), close: const TimeOfDay(hour: 23, minute: 0)),
    _DaySchedule(day: 'Tuesday',   enabled: true,  open: const TimeOfDay(hour: 9, minute: 0), close: const TimeOfDay(hour: 23, minute: 0)),
    _DaySchedule(day: 'Wednesday', enabled: true,  open: const TimeOfDay(hour: 9, minute: 0), close: const TimeOfDay(hour: 23, minute: 0)),
    _DaySchedule(day: 'Thursday',  enabled: true,  open: const TimeOfDay(hour: 9, minute: 0), close: const TimeOfDay(hour: 23, minute: 0)),
    _DaySchedule(day: 'Friday',    enabled: true,  open: const TimeOfDay(hour: 9, minute: 0), close: const TimeOfDay(hour: 23, minute: 0)),
    _DaySchedule(day: 'Saturday',  enabled: true,  open: const TimeOfDay(hour: 10, minute: 0), close: const TimeOfDay(hour: 23, minute: 0)),
    _DaySchedule(day: 'Sunday',    enabled: false, open: const TimeOfDay(hour: 10, minute: 0), close: const TimeOfDay(hour: 22, minute: 0)),
  ];

  String _fmt(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  Future<void> _pickTime(TimeOfDay initial, ValueChanged<TimeOfDay> onPicked) async {
    final picked = await showTimePicker(context: context, initialTime: initial,
      builder: (context, child) => Theme(data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(primary: AppColors.primary, onSurface: AppColors.textPrimaryLight),
      ), child: child!),
    );
    if (picked != null) onPicked(picked);
  }

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
          // ── Mode toggle header ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                const Icon(Icons.schedule_rounded, color: AppColors.primary, size: 18),
                const SizedBox(width: 10),
                const Text('Schedule', style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w700, fontSize: 14)),
                const Spacer(),
                // Mode toggle chips
                _ModeChip(label: 'Every Day', selected: !_customMode, onTap: () => setState(() => _customMode = false)),
                const SizedBox(width: 6),
                _ModeChip(label: 'Custom', selected: _customMode, onTap: () => setState(() => _customMode = true)),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderLight),

          // ── Every Day mode ─────────────────────────────────────────────
          if (!_customMode)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.wb_sunny_outlined, size: 16, color: AppColors.textSecondaryLight),
                  const SizedBox(width: 8),
                  Text('All 7 days', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  const Spacer(),
                  _TapTimeChip(
                    label: _fmt(_globalOpen),
                    onTap: () => _pickTime(_globalOpen, (t) => setState(() => _globalOpen = t)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('to', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                  ),
                  _TapTimeChip(
                    label: _fmt(_globalClose),
                    onTap: () => _pickTime(_globalClose, (t) => setState(() => _globalClose = t)),
                  ),
                ],
              ),
            ),

          // ── Custom mode: per-day rows ──────────────────────────────────
          if (_customMode)
            ...List.generate(_days.length, (i) {
              final d = _days[i];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        // Day enable switch
                        SizedBox(
                          width: 36, height: 20,
                          child: Switch(
                            value: d.enabled,
                            onChanged: (v) => setState(() => d.enabled = v),
                            activeColor: AppColors.primary,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 92,
                          child: Text(
                            d.day,
                            style: TextStyle(
                              color: d.enabled ? AppColors.textPrimaryLight : AppColors.textSecondaryLight,
                              fontWeight: d.enabled ? FontWeight.w600 : FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (d.enabled) ...[
                          _TapTimeChip(
                            label: _fmt(d.open),
                            onTap: () => _pickTime(d.open, (t) => setState(() => d.open = t)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text('to', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                          ),
                          _TapTimeChip(
                            label: _fmt(d.close),
                            onTap: () => _pickTime(d.close, (t) => setState(() => d.close = t)),
                          ),
                        ] else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: const Text('Closed', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w500)),
                          ),
                      ],
                    ),
                  ),
                  if (i < _days.length - 1)
                    const Divider(height: 1, color: AppColors.borderLight, indent: 16, endIndent: 16),
                ],
              );
            }),

          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ModeChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? AppColors.primary : AppColors.borderLight),
        ),
        child: Text(label, style: TextStyle(
          color: selected ? Colors.white : AppColors.textSecondaryLight,
          fontSize: 12, fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        )),
      ),
    );
  }
}

class _TapTimeChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _TapTimeChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time_rounded, size: 13, color: AppColors.primary),
            const SizedBox(width: 5),
            Text(label, style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STEP 4 — Subscription
// ═══════════════════════════════════════════════════════════════════════════════
class _Step4Subscription extends StatelessWidget {
  final String selectedPlan;
  final ValueChanged<String> onPlanChanged;
  const _Step4Subscription({required this.selectedPlan, required this.onPlanChanged});

  static const _plans = [
    (
      name: 'Starter',
      price: 'Free',
      sub: '14-day trial',
      color: AppColors.textSecondaryLight,
      features: ['1 branch', 'Up to 5 employees', 'Basic POS', 'Email support'],
      recommended: false,
    ),
    (
      name: 'Professional',
      price: '\$49',
      sub: 'per month',
      color: AppColors.primary,
      features: ['Up to 3 branches', 'Unlimited employees', 'Full POS + KDS', 'Inventory', 'Reports', 'Priority support'],
      recommended: true,
    ),
    (
      name: 'Enterprise',
      price: '\$149',
      sub: 'per month',
      color: Color(0xFF7C3AED),
      features: ['Unlimited branches', 'Custom integrations', 'Dedicated account manager', 'SLA 99.9%', 'Custom branding'],
      recommended: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepTitle(title: 'Choose a Plan', subtitle: 'Select the plan that fits your business. You can change anytime.'),
          const SizedBox(height: 32),
          Wrap(
            spacing: 20, runSpacing: 20,
            children: _plans.map((plan) {
              final sel = selectedPlan == plan.name;
              return GestureDetector(
                onTap: () => onPlanChanged(plan.name),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 260,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: sel ? (plan.color as Color).withValues(alpha: 0.04) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: sel ? (plan.color as Color) : AppColors.borderLight, width: sel ? 2 : 1),
                    boxShadow: sel ? [BoxShadow(color: (plan.color as Color).withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 8))] : [],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (plan.recommended)
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                          child: const Text('Recommended', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                        ),
                      Text(plan.name, style: TextStyle(color: plan.color as Color, fontWeight: FontWeight.w800, fontSize: 18)),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(plan.price, style: TextStyle(color: AppColors.textPrimaryLight, fontWeight: FontWeight.w900, fontSize: plan.price == 'Free' ? 28 : 32)),
                          if (plan.price != 'Free') ...[
                            const SizedBox(width: 4),
                            Padding(padding: const EdgeInsets.only(bottom: 4), child: Text(plan.sub, style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13))),
                          ],
                        ],
                      ),
                      const SizedBox(height: 20),
                      ...plan.features.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Icon(Icons.check_rounded, size: 15, color: plan.color as Color),
                            const SizedBox(width: 8),
                            Flexible(child: Text(f, style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 13))),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STEP 5 — Success
// ═══════════════════════════════════════════════════════════════════════════════
class _Step5Success extends StatelessWidget {
  final VoidCallback onGoToDashboard;
  const _Step5Success({required this.onGoToDashboard});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated checkmark
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 56),
              ).animate().scale(duration: 700.ms, curve: Curves.elasticOut),
              const SizedBox(height: 32),

              const Text('🎉 Restaurant Created!', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textPrimaryLight, fontSize: 28, fontWeight: FontWeight.w900))
                  .animate(delay: 200.ms).fadeIn(duration: 500.ms),
              const SizedBox(height: 16),
              Text("You're all set. Your restaurant is ready. Let's start taking orders and growing your business.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[500], fontSize: 15, height: 1.6))
                  .animate(delay: 300.ms).fadeIn(duration: 500.ms),
              const SizedBox(height: 40),

              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _StatBadge(icon: Icons.flash_on_rounded, label: 'POS Ready'),
                  const SizedBox(width: 12),
                  _StatBadge(icon: Icons.cloud_done_rounded, label: 'Cloud Synced'),
                  const SizedBox(width: 12),
                  _StatBadge(icon: Icons.security_rounded, label: 'Secured'),
                ],
              ).animate(delay: 400.ms).fadeIn(duration: 500.ms),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity, height: 54,
                child: ElevatedButton.icon(
                  onPressed: onGoToDashboard,
                  icon: const Icon(Icons.dashboard_rounded, size: 20),
                  label: const Text('Go to Dashboard', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0,
                  ),
                ),
              ).animate(delay: 500.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StatBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.borderLight)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── Shared Form Widgets ──────────────────────────────────────────────────────
class _StepTitle extends StatelessWidget {
  final String title, subtitle;
  const _StepTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 24, fontWeight: FontWeight.w900))
            .animate().fadeIn(duration: 400.ms),
        const SizedBox(height: 6),
        Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 14))
            .animate(delay: 60.ms).fadeIn(duration: 400.ms),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String label, hint;
  final IconData icon;
  final bool obscure;
  final VoidCallback? onToggleObscure;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const _Field({
    required this.ctrl, required this.label, required this.hint, required this.icon,
    this.obscure = false, this.onToggleObscure, this.keyboardType, this.validator, this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          obscureText: obscure,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
            prefixIcon: Icon(icon, size: 17, color: AppColors.textSecondaryLight),
            suffixIcon: onToggleObscure != null ? IconButton(
              icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: AppColors.textSecondaryLight),
              onPressed: onToggleObscure,
            ) : null,
            filled: true, fillColor: AppColors.backgroundLight,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.error)),
          ),
          validator: validator,
        ),
      ],
    );
  }
}

class _DropField extends StatelessWidget {
  final String label, value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  const _DropField({required this.label, required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: (v) => onChanged(v!),
          style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 14),
          decoration: InputDecoration(
            filled: true, fillColor: AppColors.backgroundLight,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderLight)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
          ),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
        ),
      ],
    );
  }
}
