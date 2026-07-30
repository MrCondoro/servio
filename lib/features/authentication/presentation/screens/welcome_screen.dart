import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  String _lang = 'EN';
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 900;

    return Scaffold(
      body: Stack(
        children: [
          // ── Animated gradient background ─────────────────────────────
          AnimatedBuilder(
            animation: _bgController,
            builder: (_, __) => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.backgroundDark,
                    Color.lerp(AppColors.backgroundDark,
                        const Color(0xFF134E4A), _bgController.value)!,
                    AppColors.backgroundDark,
                  ],
                ),
              ),
            ),
          ),

          // ── Decorative circles ────────────────────────────────────────
          Positioned(
            top: -80, right: -80,
            child: AnimatedBuilder(
              animation: _bgController,
              builder: (_, __) => Container(
                width: 320, height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary
                      .withValues(alpha: 0.06 + _bgController.value * 0.04),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -120, left: -60,
            child: Container(
              width: 400, height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withValues(alpha: 0.04),
              ),
            ),
          ),

          // ── Main content ─────────────────────────────────────────────
          isDesktop
              ? _DesktopLayout(lang: _lang, onLangChange: (l) => setState(() => _lang = l), bgAnim: _bgController)
              : _MobileLayout(lang: _lang, onLangChange: (l) => setState(() => _lang = l)),
        ],
      ),
    );
  }
}

// ── Desktop: side-by-side layout ─────────────────────────────────────────────
class _DesktopLayout extends StatelessWidget {
  final String lang;
  final ValueChanged<String> onLangChange;
  final AnimationController bgAnim;
  const _DesktopLayout({required this.lang, required this.onLangChange, required this.bgAnim});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left — brand visual
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                _ServioLogo()
                    .animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
                const SizedBox(height: 48),

                // Tagline
                const Text(
                  'Run Your\nRestaurant\nSmarter.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                    letterSpacing: -1.5,
                  ),
                ).animate(delay: 150.ms).fadeIn(duration: 600.ms).slideX(begin: -0.1),
                const SizedBox(height: 20),

                Text(
                  'The all-in-one POS, inventory, and analytics\nplatform built for modern restaurants.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 16,
                    height: 1.6,
                  ),
                ).animate(delay: 250.ms).fadeIn(duration: 600.ms),
                const SizedBox(height: 60),

                // Restaurant illustration
                AnimatedBuilder(
                  animation: bgAnim,
                  builder: (_, __) => SizedBox(
                    height: 220,
                    child: CustomPaint(
                      painter: _RestaurantIllustrationPainter(bgAnim.value),
                      size: const Size(double.infinity, 220),
                    ),
                  ),
                ).animate(delay: 350.ms).fadeIn(duration: 800.ms),

                const SizedBox(height: 40),

                // Feature pills
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  children: [
                    _FeaturePill(icon: Icons.receipt_long_rounded, label: 'Smart Orders'),
                    _FeaturePill(icon: Icons.analytics_rounded, label: 'Live Analytics'),
                    _FeaturePill(icon: Icons.inventory_2_rounded, label: 'Inventory'),
                    _FeaturePill(icon: Icons.people_rounded, label: 'Team Management'),
                  ],
                ).animate(delay: 450.ms).fadeIn(duration: 600.ms),
              ],
            ),
          ),
        ),

        // Right — action panel
        Container(
          width: 460,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            border: const Border(left: BorderSide(color: AppColors.borderDark)),
          ),
          child: _ActionPanel(lang: lang, onLangChange: onLangChange),
        ),
      ],
    );
  }
}

// ── Mobile layout ─────────────────────────────────────────────────────────────
class _MobileLayout extends StatelessWidget {
  final String lang;
  final ValueChanged<String> onLangChange;
  const _MobileLayout({required this.lang, required this.onLangChange});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 64, 28, 40),
      child: Column(
        children: [
          _ServioLogo().animate().fadeIn(duration: 600.ms),
          const SizedBox(height: 32),
          const Text(
            'Run Your Restaurant\nSmarter.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1),
          ).animate(delay: 100.ms).fadeIn(duration: 600.ms),
          const SizedBox(height: 16),
          Text(
            'The all-in-one POS, inventory, and\nanalytics platform for modern restaurants.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14, height: 1.6),
          ).animate(delay: 200.ms).fadeIn(duration: 600.ms),
          const SizedBox(height: 48),
          _ActionPanel(lang: lang, onLangChange: onLangChange),
        ],
      ),
    );
  }
}

// ── Shared action panel ───────────────────────────────────────────────────────
class _ActionPanel extends StatelessWidget {
  final String lang;
  final ValueChanged<String> onLangChange;
  const _ActionPanel({required this.lang, required this.onLangChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome back text
          Text(
            'Welcome to Servio',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 24, fontWeight: FontWeight.w800),
          ).animate(delay: 200.ms).fadeIn(duration: 600.ms),
          const SizedBox(height: 8),
          Text(
            'Sign in to your account or create a new one to get started.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14, height: 1.5),
          ).animate(delay: 250.ms).fadeIn(duration: 600.ms),
          const SizedBox(height: 40),

          // Sign In button
          _PrimaryButton(
            label: 'Sign In',
            icon: Icons.login_rounded,
            onTap: () => context.go('/login'),
          ).animate(delay: 300.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1),

          const SizedBox(height: 14),

          // Create Account
          _SecondaryButton(
            label: 'Create Account',
            icon: Icons.storefront_rounded,
            onTap: () => context.go('/register'),
          ).animate(delay: 380.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1),

          const SizedBox(height: 28),

          // Divider
          Row(
            children: [
              Expanded(child: Container(height: 1, color: AppColors.borderDark)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text('or continue with', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 12)),
              ),
              Expanded(child: Container(height: 1, color: AppColors.borderDark)),
            ],
          ).animate(delay: 460.ms).fadeIn(duration: 500.ms),

          const SizedBox(height: 20),

          // Google
          _SocialButton(
            label: 'Continue with Google',
            iconColor: const Color(0xFF4285F4),
            iconData: Icons.g_mobiledata_rounded,
            onTap: () {},
          ).animate(delay: 520.ms).fadeIn(duration: 500.ms),

          const SizedBox(height: 56),

          // Language selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ['EN', 'FR', 'AR'].map((l) {
              final sel = lang == l;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => onLangChange(l),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: sel ? AppColors.primary : AppColors.borderDark),
                    ),
                    child: Text(l, style: TextStyle(color: sel ? Colors.white : Colors.white.withValues(alpha: 0.5), fontSize: 13, fontWeight: sel ? FontWeight.w700 : FontWeight.w400)),
                  ),
                ),
              );
            }).toList(),
          ).animate(delay: 600.ms).fadeIn(duration: 500.ms),

          const SizedBox(height: 24),

          // Legal
          Text(
            'By continuing, you agree to our Terms of Service\nand Privacy Policy.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 11, height: 1.6),
          ).animate(delay: 700.ms).fadeIn(duration: 500.ms),
        ],
      ),
    );
  }
}

// ── Servio Logo ───────────────────────────────────────────────────────────────
class _ServioLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.eco_rounded, color: Colors.white, size: 26),
        ),
        const SizedBox(width: 14),
        const Text(
          'Servio',
          style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5),
        ),
        Container(
          margin: const EdgeInsets.only(left: 6, bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text('POS', style: TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)),
        ),
      ],
    );
  }
}

// ── Feature Pill ──────────────────────────────────────────────────────────────
class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeaturePill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.accent),
          const SizedBox(width: 7),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ── Buttons ───────────────────────────────────────────────────────────────────
class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _SecondaryButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final Color iconColor;
  final IconData iconData;
  final VoidCallback onTap;
  const _SocialButton({required this.label, required this.iconColor, required this.iconData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData, color: iconColor, size: 22),
              const SizedBox(width: 10),
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Restaurant Illustration (CustomPainter) ───────────────────────────────────
class _RestaurantIllustrationPainter extends CustomPainter {
  final double anim;
  _RestaurantIllustrationPainter(this.anim);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    final w = size.width;
    final h = size.height;

    // Ground
    final groundPaint = Paint()..color = AppColors.surfaceDark.withValues(alpha: 0.4);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, h * 0.75, w, h * 0.25), const Radius.circular(12)), groundPaint);

    // Building body
    final buildPaint = Paint()..color = AppColors.surfaceDark;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.05, h * 0.2, w * 0.55, h * 0.56), const Radius.circular(8)), buildPaint);

    // Roof
    final roofPaint = Paint()..color = AppColors.primary;
    final roofPath = Path()
      ..moveTo(w * 0.02, h * 0.22)
      ..lineTo(w * 0.32, h * 0.05)
      ..lineTo(w * 0.62, h * 0.22)
      ..close();
    canvas.drawPath(roofPath, roofPaint);

    // Windows (animated glow)
    final winPaint = Paint()..color = AppColors.accent.withValues(alpha: 0.7 + anim * 0.3);
    for (int i = 0; i < 3; i++) {
      final x = w * 0.10 + i * w * 0.15;
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x, h * 0.28, w * 0.1, h * 0.14), const Radius.circular(4)), winPaint);
    }

    // Door
    final doorPaint = Paint()..color = AppColors.borderDark;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.22, h * 0.54, w * 0.12, h * 0.22), const Radius.circular(4)), doorPaint);

    // Sign
    final signPaint = Paint()..color = AppColors.primary;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.08, h * 0.38, w * 0.47, h * 0.1), const Radius.circular(4)), signPaint);

    // Right building (small)
    final rb = Paint()..color = AppColors.surfaceDark.withValues(alpha: 0.7);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.65, h * 0.36, w * 0.28, h * 0.40), const Radius.circular(6)), rb);

    // Small windows
    final sw = Paint()..color = AppColors.warning.withValues(alpha: 0.5 + anim * 0.4);
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.68 + j * w * 0.1, h * 0.42 + i * h * 0.14, w * 0.07, h * 0.09), const Radius.circular(3)),
          sw,
        );
      }
    }

    // Street lights (animated)
    final lightPole = Paint()..color = AppColors.borderDark..strokeWidth = 2..style = PaintingStyle.stroke;
    final lightGlow = Paint()..color = AppColors.warning.withValues(alpha: 0.6 + anim * 0.4);
    for (final lx in [w * 0.04, w * 0.62]) {
      canvas.drawLine(Offset(lx, h * 0.76), Offset(lx, h * 0.45), lightPole);
      canvas.drawLine(Offset(lx, h * 0.45), Offset(lx + w * 0.05, h * 0.45), lightPole);
      canvas.drawCircle(Offset(lx + w * 0.05, h * 0.45), 5, lightGlow);
    }

    // Stars / dots
    final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.3 + anim * 0.3);
    final rand = math.Random(42);
    for (int i = 0; i < 20; i++) {
      canvas.drawCircle(
        Offset(rand.nextDouble() * w, rand.nextDouble() * h * 0.3),
        rand.nextDouble() * 1.5 + 0.5, starPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RestaurantIllustrationPainter old) => old.anim != anim;
}
