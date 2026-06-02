import 'package:flutter/material.dart';
import '../design/animations.dart';

/// Animates each child in sequentially with a 50 ms stagger.
///
/// Wrap any list of widgets to give them a smooth fade+slide entry:
/// ```dart
/// StaggeredList(children: myWidgets)
/// ```
class StaggeredList extends StatefulWidget {
  const StaggeredList({
    super.key,
    required this.children,
    this.itemDelay = const Duration(milliseconds: 50),
    this.itemDuration = kDurationMed,
    this.direction = Axis.vertical,
  });

  final List<Widget> children;
  final Duration itemDelay;
  final Duration itemDuration;
  final Axis direction;

  @override
  State<StaggeredList> createState() => _StaggeredListState();
}

class _StaggeredListState extends State<StaggeredList>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _fades;
  late final List<Animation<Offset>> _slides;

  @override
  void initState() {
    super.initState();
    final count = widget.children.length;

    _controllers = List.generate(count, (_) {
      return AnimationController(vsync: this, duration: widget.itemDuration);
    });

    _fades = _controllers.map((c) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: c, curve: kCurveOut),
      );
    }).toList();

    _slides = _controllers.map((c) {
      return Tween<Offset>(
        begin: widget.direction == Axis.vertical
            ? const Offset(0, 0.06)
            : const Offset(0.06, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: c, curve: kCurveOut));
    }).toList();

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    for (var i = 0; i < _controllers.length; i++) {
      if (!mounted) return;
      await Future.delayed(widget.itemDelay * i);
      if (!mounted) return;
      _controllers[i].forward();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.children.length, (i) {
        return FadeTransition(
          opacity: _fades[i],
          child: SlideTransition(
            position: _slides[i],
            child: widget.children[i],
          ),
        );
      }),
    );
  }
}
