import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

bool get _isWidgetTestBinding =>
    WidgetsBinding.instance.runtimeType.toString().contains('Test');

/// Tactile hover-lift + press-scale wrapper for cards, shortcuts, and buttons.
class BouncyTap extends StatefulWidget {
  const BouncyTap({
    super.key,
    required this.child,
    this.onTap,
    this.scaleDown = 0.94,
    this.hoverScale = 1.02,
    this.enableHaptics = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scaleDown;
  final double hoverScale;
  final bool enableHaptics;

  @override
  State<BouncyTap> createState() => _BouncyTapState();
}

class _BouncyTapState extends State<BouncyTap> {
  bool _pressed = false;
  bool _hovered = false;

  void _setPressed(bool value) {
    if (_pressed == value || widget.onTap == null) return;
    setState(() => _pressed = value);
  }

  void _setHovered(bool value) {
    if (_hovered == value || widget.onTap == null) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final targetScale = _pressed
        ? widget.scaleDown
        : (_hovered ? widget.hoverScale : 1.0);
    final targetOffsetY = _pressed ? 1.0 : (_hovered ? -2.5 : 0.0);

    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onTap == null
            ? null
            : () {
                if (widget.enableHaptics) {
                  unawaited(HapticFeedback.selectionClick());
                }
                widget.onTap?.call();
              },
        child: AnimatedContainer(
          duration: Duration(milliseconds: _pressed ? 120 : 220),
          curve: _pressed ? Curves.easeOutCubic : Curves.easeOutExpo,
          transformAlignment: Alignment.center,
          transform: Matrix4.identity()
            ..translateByDouble(0.0, targetOffsetY, 0.0, 1.0)
            ..scaleByDouble(targetScale, targetScale, 1.0, 1.0),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Smooth GPU-accelerated staggered entrance animation (finite & test-safe).
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delayMs = 0,
    this.durationMs = 480,
    this.offsetY = 22,
  });

  final Widget child;
  final int delayMs;
  final int durationMs;
  final double offsetY;

  @override
  Widget build(BuildContext context) {
    final totalMs = durationMs + delayMs;
    final startFraction = totalMs > 0 ? (delayMs / totalMs).clamp(0.0, 0.7) : 0.0;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: totalMs),
      curve: Curves.easeOutExpo,
      builder: (context, raw, child) {
        final t = startFraction >= 1.0
            ? 1.0
            : ((raw - startFraction) / (1.0 - startFraction)).clamp(0.0, 1.0);
        final scale = 0.965 + (0.035 * t);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, offsetY * (1 - t)),
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

/// Smooth rolling integer counter for KPI values.
class AnimatedCountText extends StatelessWidget {
  const AnimatedCountText({
    super.key,
    required this.value,
    this.prefix = '',
    this.suffix = '',
    this.style,
    this.duration = const Duration(milliseconds: 660),
  });

  final int value;
  final String prefix;
  final String suffix;
  final TextStyle? style;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value.toDouble()),
      duration: duration,
      curve: Curves.easeOutExpo,
      builder: (context, current, _) => Text(
        '$prefix${current.round()}$suffix',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      ),
    );
  }
}

/// Subtle live breathing status dot (automatically steady inside widget tests).
class LivePulseDot extends StatefulWidget {
  const LivePulseDot({
    super.key,
    required this.color,
    this.size = 7,
  });

  final Color color;
  final double size;

  @override
  State<LivePulseDot> createState() => _LivePulseDotState();
}

class _LivePulseDotState extends State<LivePulseDot>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    if (!_isWidgetTestBinding) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1400),
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final core = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: widget.color,
        shape: BoxShape.circle,
      ),
    );

    if (controller == null) return core;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(controller.value);
        return SizedBox(
          width: widget.size + 6,
          height: widget.size + 6,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Transform.scale(
                scale: 1.0 + (0.85 * t),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 0.45 * (1 - t)),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              child!,
            ],
          ),
        );
      },
      child: core,
    );
  }
}

/// Slow ambient vertical float for hero SVG illustrations (test-safe).
class GentleFloat extends StatefulWidget {
  const GentleFloat({
    super.key,
    required this.child,
    this.amplitude = 5.0,
  });

  final Widget child;
  final double amplitude;

  @override
  State<GentleFloat> createState() => _GentleFloatState();
}

class _GentleFloatState extends State<GentleFloat>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    if (!_isWidgetTestBinding) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2600),
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) return widget.child;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final t = Curves.easeInOutSine.transform(controller.value);
        final dy = (t - 0.5) * 2 * widget.amplitude;
        return Transform.translate(
          offset: Offset(0, dy),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
