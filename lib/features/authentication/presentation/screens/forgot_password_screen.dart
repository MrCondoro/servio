import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _sent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() => _sent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Left accent strip
          Container(
            width: 6,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: _sent ? _SuccessState() : _FormState(
                    emailCtrl: _emailCtrl,
                    formKey: _formKey,
                    onSubmit: _submit,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormState extends StatelessWidget {
  final TextEditingController emailCtrl;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSubmit;
  const _FormState({required this.emailCtrl, required this.formKey, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Back button
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => context.go('/login'),
              icon: const Icon(Icons.arrow_back_rounded, size: 16),
              label: const Text('Back to Sign In'),
              style: TextButton.styleFrom(foregroundColor: AppColors.textSecondaryLight),
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 24),

          // Icon
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), shape: BoxShape.circle),
            child: const Icon(Icons.lock_reset_rounded, color: AppColors.primary, size: 28),
          ).animate(delay: 60.ms).fadeIn(duration: 400.ms),
          const SizedBox(height: 20),

          const Text('Forgot Password?', style: TextStyle(color: AppColors.textPrimaryLight, fontSize: 26, fontWeight: FontWeight.w800))
              .animate(delay: 100.ms).fadeIn(duration: 400.ms),
          const SizedBox(height: 10),
          Text("No worries — we'll send you a reset link to your registered email address.",
            style: TextStyle(color: Colors.grey[500], fontSize: 14, height: 1.5))
              .animate(delay: 150.ms).fadeIn(duration: 400.ms),
          const SizedBox(height: 32),

          Text('Email Address', style: TextStyle(color: Colors.grey[700], fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextFormField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'you@restaurant.com',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              prefixIcon: const Icon(Icons.email_outlined, size: 18, color: AppColors.textSecondaryLight),
              filled: true, fillColor: AppColors.backgroundLight,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.error)),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Email is required';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
          const SizedBox(height: 28),

          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text('Send Reset Link', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ),
          ).animate(delay: 260.ms).fadeIn(duration: 400.ms),
        ],
      ),
    );
  }
}

class _SuccessState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),
        Center(
          child: Container(
            width: 80, height: 80,
            decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: const Icon(Icons.mark_email_read_rounded, color: AppColors.success, size: 40),
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
        ),
        const SizedBox(height: 28),
        const Text('Check your email!', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textPrimaryLight, fontSize: 26, fontWeight: FontWeight.w800))
            .animate(delay: 200.ms).fadeIn(duration: 400.ms),
        const SizedBox(height: 12),
        Text("We've sent a password reset link. Please check your inbox and follow the instructions.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[500], fontSize: 14, height: 1.5))
            .animate(delay: 280.ms).fadeIn(duration: 400.ms),
        const SizedBox(height: 40),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: () => context.go('/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0,
            ),
            child: const Text('Back to Sign In', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          ),
        ).animate(delay: 360.ms).fadeIn(duration: 400.ms),
      ],
    );
  }
}
