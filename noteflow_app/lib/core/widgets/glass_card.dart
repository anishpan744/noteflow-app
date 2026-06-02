import 'dart:ui';
import 'package:flutter/material.dart';
import '../design/tokens.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.blur = 12.0,
    this.borderRadius = 16.0,
    this.glowColor,
    this.padding = const EdgeInsets.all(16),
    this.margin,
  });

  final Widget child;
  final double blur;
  final double borderRadius;
  final Color? glowColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    final glow = glowColor;

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: kGlassFill,
              borderRadius: radius,
              border: Border.all(color: kGlassBorder, width: 1.0),
              boxShadow: [
                // Base depth shadow
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
                // Optional neon glow
                if (glow != null)
                  BoxShadow(
                    color: glow.withValues(alpha: 0.15),
                    blurRadius: 24,
                    spreadRadius: 0,
                  ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
