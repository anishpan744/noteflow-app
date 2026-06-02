import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ── Durations ─────────────────────────────────────────────────────────────────
const kDurationFast = Duration(milliseconds: 150);
const kDurationMed  = Duration(milliseconds: 300);
const kDurationSlow = Duration(milliseconds: 600);

// ── Curves ────────────────────────────────────────────────────────────────────
// easeOutExpo: fast start, smooth deceleration
const kCurveOut    = Cubic(0.19, 1.0, 0.22, 1.0);
// easeInExpo: slow start, fast exit
const kCurveIn     = Cubic(0.95, 0.05, 0.795, 0.035);
// Spring: elastic overshoot
const kCurveSpring = Curves.elasticOut;

// ── Page route transition ─────────────────────────────────────────────────────
// Horizontal slide + fade; used in GoRouter routes.
CustomTransitionPage<T> pageRouteTransition<T>({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: kDurationMed,
    reverseTransitionDuration: kDurationFast,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideAnim = Tween<Offset>(
        begin: const Offset(0.04, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: kCurveOut));

      final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: kCurveOut),
      );

      return FadeTransition(
        opacity: fadeAnim,
        child: SlideTransition(position: slideAnim, child: child),
      );
    },
  );
}
