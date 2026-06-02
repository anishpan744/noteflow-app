import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Wrapper around [PhosphorIcon] with an optional neon glow shadow.
class GlowIcon extends StatelessWidget {
  const GlowIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.glowColor,
    this.glowRadius = 10.0,
  });

  final PhosphorIconData icon;
  final double? size;
  final Color? color;
  final Color? glowColor;
  final double glowRadius;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? Theme.of(context).iconTheme.color;
    final glow = glowColor;

    if (glow == null) {
      return PhosphorIcon(icon, size: size, color: resolvedColor);
    }

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Blurred glow layer behind the icon
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: glow.withValues(alpha: 0.55),
                  blurRadius: glowRadius,
                  spreadRadius: glowRadius * 0.25,
                ),
              ],
            ),
          ),
        ),
        PhosphorIcon(icon, size: size, color: resolvedColor),
      ],
    );
  }
}
