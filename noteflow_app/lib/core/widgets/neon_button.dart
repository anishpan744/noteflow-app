import 'package:flutter/material.dart';
import '../design/tokens.dart';
import '../design/animations.dart';

enum NeonButtonSize { small, normal, large }

class NeonButton extends StatefulWidget {
  const NeonButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.color = kNeon,
    this.size = NeonButtonSize.normal,
    this.ghost = false,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onTap;
  final Widget? icon;
  final Color color;
  final NeonButtonSize size;

  /// Ghost variant — transparent fill, colored border + text only.
  final bool ghost;

  /// Shows a CircularProgressIndicator in place of content.
  final bool loading;

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _glowAnim;

  bool _hovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: kCurveOut),
    );
    _glowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: kCurveOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    if (widget.onTap == null || widget.loading) return;
    _controller.forward();
  }

  void _onTapUp(_) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() => _controller.reverse();

  // ── Size config ──────────────────────────────────────────────────────────
  double get _height => switch (widget.size) {
        NeonButtonSize.small  => 36,
        NeonButtonSize.normal => 48,
        NeonButtonSize.large  => 56,
      };

  double get _fontSize => switch (widget.size) {
        NeonButtonSize.small  => 13,
        NeonButtonSize.normal => 15,
        NeonButtonSize.large  => 17,
      };

  EdgeInsets get _padding => switch (widget.size) {
        NeonButtonSize.small  => const EdgeInsets.symmetric(horizontal: 16),
        NeonButtonSize.normal => const EdgeInsets.symmetric(horizontal: 24),
        NeonButtonSize.large  => const EdgeInsets.symmetric(horizontal: 32),
      };

  @override
  Widget build(BuildContext context) {
    final color = widget.color;
    final disabled = widget.onTap == null || widget.loading;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit:  (_) => setState(() => _hovering = false),
      cursor: disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown:   _onTapDown,
        onTapUp:     _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final glowOpacity = _glowAnim.value * 0.4;
            final hoverFill = _hovering && !disabled
                ? color.withValues(alpha: 0.15)
                : Colors.transparent;
            // Filled: blend 20% white on hover for a clear brightness increase
            final fillColor = widget.ghost
                ? hoverFill
                : disabled
                    ? color.withValues(alpha: 0.3)
                    : _hovering
                        ? Color.alphaBlend(
                            Colors.white.withValues(alpha: 0.22), color)
                        : color;

            return Transform.scale(
              scale: disabled ? 1.0 : _scaleAnim.value,
              child: AnimatedContainer(
                duration: kDurationFast,
                height: _height,
                padding: _padding,
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(_height / 2),
                  border: Border.all(
                    color: disabled
                        ? color.withValues(alpha: 0.3)
                        : color,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: glowOpacity),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                    if (_hovering && !disabled)
                      BoxShadow(
                        color: color.withValues(alpha: 0.30),
                        blurRadius: 20,
                      ),
                  ],
                ),
                child: child,
              ),
            );
          },
          child: _buildContent(disabled),
        ),
      ),
    );
  }

  Widget _buildContent(bool disabled) {
    final color    = widget.color;
    final textColor = widget.ghost ? color : (disabled ? color.withValues(alpha: 0.5) : kBg0);

    if (widget.loading) {
      return SizedBox(
        height: _height,
        child: Center(
          child: SizedBox(
            width: _fontSize + 4,
            height: _fontSize + 4,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          IconTheme(
            data: IconThemeData(color: textColor, size: _fontSize + 2),
            child: widget.icon!,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          widget.label,
          style: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: _fontSize,
            fontWeight: FontWeight.w600,
            color: textColor,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
