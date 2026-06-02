import 'package:flutter/material.dart';
import '../design/animations.dart';

class ColorFlagChip extends StatelessWidget {
  const ColorFlagChip({
    super.key,
    required this.label,
    required this.color,
    this.selected = false,
    this.onTap,
    this.small = false,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback? onTap;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final fillOpacity  = selected ? 0.30 : 0.18;
    final borderWidth  = selected ? 1.5 : 1.0;
    final fontSize     = small ? 11.0 : 13.0;
    final hPadding     = small ? 10.0 : 14.0;
    final height       = small ? 26.0 : 32.0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: kDurationFast,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: hPadding),
        decoration: BoxDecoration(
          color: color.withValues(alpha: fillOpacity),
          borderRadius: BorderRadius.circular(height / 2),
          border: Border.all(
            color: color.withValues(alpha: selected ? 0.9 : 0.5),
            width: borderWidth,
          ),
          boxShadow: selected
              ? [BoxShadow(color: color.withValues(alpha: 0.20), blurRadius: 8)]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: fontSize,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? color : color.withValues(alpha: 0.85),
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
