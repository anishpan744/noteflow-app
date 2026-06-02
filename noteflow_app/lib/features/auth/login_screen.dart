import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/design/tokens.dart';
import '../../core/widgets/neon_button.dart';
import 'auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  late final AnimationController _particleCtrl;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _particleCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() => _loading = true);
    try {
      await ref.read(authControllerProvider.notifier).signInWithGoogle();
      if (mounted) {
        final user = ref.read(authControllerProvider).valueOrNull;
        if (user != null) context.go('/notes');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceAll('Exception: ', ''),
              style: const TextStyle(color: kTextPrimary),
            ),
            backgroundColor: kCrimson,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: kBg0,
      body: Stack(
        children: [
          // ── Particle background ───────────────────────────────────────────
          AnimatedBuilder(
            animation: _particleCtrl,
            builder: (_, __) => CustomPaint(
              painter: _ParticlePainter(
                progress: _particleCtrl.value,
                pulse: _loading,
              ),
              child: const SizedBox.expand(),
            ),
          ),

          // ── Centre content ────────────────────────────────────────────────
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo mark
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: kGlassFill,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: kGlassBorder),
                        boxShadow: [
                          BoxShadow(
                            color: kNeon.withValues(alpha: 0.25),
                            blurRadius: 32,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        PhosphorIconsFill.notepad,
                        color: kNeon,
                        size: 36,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // App name
                    Text(
                      'NoteFlow',
                      style: tt.displayLarge?.copyWith(
                        color: kTextPrimary,
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Tagline
                    Text(
                      'Think clearly. Act precisely.',
                      style: tt.bodySmall?.copyWith(
                        color: kTextSecondary,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Google Sign-In button
                    SizedBox(
                      width: double.infinity,
                      child: NeonButton(
                        label: 'Continue with Google',
                        icon: _GoogleLogo(size: 18),
                        color: kNeon,
                        size: NeonButtonSize.large,
                        loading: _loading,
                        onTap: _loading ? null : _signIn,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Your data syncs securely across all devices.',
                      style: tt.labelSmall?.copyWith(color: kTextMuted),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Google logo widget ────────────────────────────────────────────────────────

class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final cx = s / 2;
    final cy = s / 2;
    final r = s * 0.45;

    // Draw a simplified G shape using colored arcs
    final colors = [
      const Color(0xFF4285F4),
      const Color(0xFF34A853),
      const Color(0xFFFBBC05),
      const Color(0xFFEA4335),
    ];
    final sweeps = [math.pi * 0.5, math.pi * 0.5, math.pi * 0.5, math.pi * 0.5];
    final starts = [
      -math.pi * 0.25,
      math.pi * 0.25,
      math.pi * 0.75,
      math.pi * 1.25,
    ];

    for (var i = 0; i < 4; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.18
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        starts[i],
        sweeps[i],
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Particle background painter ───────────────────────────────────────────────

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({required this.progress, required this.pulse});

  final double progress;
  final bool pulse;

  static const _count = 48;
  static final _rng = math.Random(42);

  // Pre-compute stable particle positions and velocities
  static final _positions = List.generate(_count, (_) => [
        _rng.nextDouble(),
        _rng.nextDouble(),
      ]);
  static final _velocities = List.generate(_count, (_) => [
        (_rng.nextDouble() - 0.5) * 0.008,
        (_rng.nextDouble() - 0.5) * 0.008,
      ]);

  @override
  void paint(Canvas canvas, Size size) {
    final speed = pulse ? 2.5 : 1.0;

    // Compute current positions
    final pts = _positions.map((p) {
      double x = (p[0] + _velocities[_positions.indexOf(p)][0] * progress * speed * 12) % 1.0;
      double y = (p[1] + _velocities[_positions.indexOf(p)][1] * progress * speed * 12) % 1.0;
      return Offset(x * size.width, y * size.height);
    }).toList();

    final dotPaint = Paint()
      ..color = kNeon.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    const maxDist = 120.0;

    // Draw connecting lines
    for (var i = 0; i < _count; i++) {
      for (var j = i + 1; j < _count; j++) {
        final d = (pts[i] - pts[j]).distance;
        if (d < maxDist) {
          final alpha = (1 - d / maxDist) * 0.18;
          linePaint.color = kNeon.withValues(alpha: alpha);
          canvas.drawLine(pts[i], pts[j], linePaint);
        }
      }
    }

    // Draw dots
    for (final pt in pts) {
      canvas.drawCircle(pt, 2.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) =>
      old.progress != progress || old.pulse != pulse;
}
