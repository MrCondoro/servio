import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(authStateControllerProvider.notifier).login(
        _emailCtrl.text.trim(),
        _passCtrl.text,
      );
    }
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
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ));
      } else if (next.hasValue && next.value != null) {
        context.go('/dashboard');
      }
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: isDesktop ? _buildDesktop(authState) : _buildMobile(authState),
    );
  }

  // ── Desktop split-panel ───────────────────────────────────────────────────
  Widget _buildDesktop(AsyncValue authState) {
    return Row(
      children: [
        // Left brand panel
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.backgroundDark, Color(0xFF134E4A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ServioWordmark()
                    .animate().fadeIn(duration: 600.ms),
                const SizedBox(height: 40),
                const Text(
                  'Welcome back,\nRestaurateur.',
                  style: TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1.5),
                ).animate(delay: 100.ms).fadeIn(duration: 600.ms).slideX(begin: -0.1),
                const SizedBox(height: 20),
                Text(
                  'Manage orders, staff, inventory and customers\nfrom one powerful platform.',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 16, height: 1.6),
                ).animate(delay: 200.ms).fadeIn(duration: 600.ms),
                const SizedBox(height: 56),
                ...[
                  (Icons.flash_on_rounded, 'Fast order processing'),
                  (Icons.analytics_rounded, 'Real-time analytics'),
                  (Icons.cloud_sync_rounded, 'Cloud synced'),
                ].asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                        child: Icon(e.value.$1, color: AppColors.accent, size: 18),
                      ),
                      const SizedBox(width: 14),
                      Text(e.value.$2, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
                    ],
                  ).animate(delay: (300 + e.key * 80).ms).fadeIn(duration: 500.ms).slideX(begin: -0.05),
                )),
              ],
            ),
          ),
        ),

        // Right form panel
        Container(
          width: 460,
          color: Colors.white,
          padding: const EdgeInsets.all(56),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _formChildren(authState),
          ),
        ),
      ],
    );
  }

  // ── Mobile ────────────────────────────────────────────────────────────────
  Widget _buildMobile(AsyncValue authState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 80, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ServioWordmark(dark: false)
              .animate().fadeIn(duration: 600.ms),
          const SizedBox(height: 40),
          ..._formChildren(authState),
        ],
      ),
    );
  }

  // ── Shared form content ───────────────────────────────────────────────────
  List<Widget> _formChildren(AsyncValue authState) {
    return [
      Text('Sign In', style: TextStyle(color: Colors.grey[900], fontSize: 28, fontWeight: FontWeight.w900))
          .animate().fadeIn(duration: 500.ms),
      const SizedBox(height: 8),
      Text('Enter your credentials to access your dashboard.', style: TextStyle(color: Colors.grey[500], fontSize: 14))
          .animate(delay: 60.ms).fadeIn(duration: 500.ms),
      const SizedBox(height: 36),

      Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email
            _FormLabel(label: 'Email Address'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 14),
              decoration: _inputDeco('you@restaurant.com', prefixIcon: Icons.email_outlined),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email is required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ).animate(delay: 120.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: 20),

            // Password
            _FormLabel(label: 'Password'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _passCtrl,
              obscureText: _obscure,
              style: const TextStyle(color: AppColors.textPrimaryLight, fontSize: 14),
              decoration: _inputDeco('••••••••',
                prefixIcon: Icons.lock_outline_rounded,
                suffix: IconButton(
                  icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: AppColors.textSecondaryLight),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Password is required' : null,
            ).animate(delay: 180.ms).fadeIn(duration: 400.ms),

            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 20, height: 20,
                      child: Checkbox(
                        value: _rememberMe,
                        onChanged: (v) => setState(() => _rememberMe = v ?? false),
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('Remember me', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  ],
                ),
                GestureDetector(
                  onTap: () => context.go('/forgot-password'),
                  child: Text('Forgot Password?', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ],
            ).animate(delay: 240.ms).fadeIn(duration: 400.ms),

            const SizedBox(height: 30),

            // Submit
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: authState.isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: authState.isLoading
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : const Text('Sign In', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ).animate(delay: 300.ms).fadeIn(duration: 400.ms),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? ", style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                GestureDetector(
                  onTap: () => context.go('/register'),
                  child: Text('Create Account', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w700)),
                ),
              ],
            ).animate(delay: 360.ms).fadeIn(duration: 400.ms),
          ],
        ),
      ),
    ];
  }

  InputDecoration _inputDeco(String hint, {required IconData prefixIcon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      prefixIcon: Icon(prefixIcon, size: 18, color: AppColors.textSecondaryLight),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.backgroundLight,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.error)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.error, width: 1.5)),
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String label;
  const _FormLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 13, fontWeight: FontWeight.w600));
  }
}

class _ServioWordmark extends StatelessWidget {
  final bool dark;
  const _ServioWordmark({this.dark = true});

  @override
  Widget build(BuildContext context) {
    final textColor = dark ? Colors.white : AppColors.textPrimaryLight;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accent], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.eco_rounded, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 10),
        Text('Servio', style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
        Container(
          margin: const EdgeInsets.only(left: 5, bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(5)),
          child: const Text('POS', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
        ),
      ],
    );
  }
}
