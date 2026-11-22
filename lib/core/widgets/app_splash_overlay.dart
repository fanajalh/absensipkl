import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

bool get _isWidgetTestBinding =>
    WidgetsBinding.instance.runtimeType.toString().contains('Test');

/// Ultra-minimalist icon-only splash screen with silky zoom-out → zoom-in motion.
class AppSplashOverlay extends StatefulWidget {
  const AppSplashOverlay({
    super.key,
    required this.child,
    this.holdDuration = const Duration(milliseconds: 2400),
    this.exitDuration = const Duration(milliseconds: 650),
    this.forceShowInTests = false,
  });

  final Widget child;
  final Duration holdDuration;
  final Duration exitDuration;
  final bool forceShowInTests;

  @override
  State<AppSplashOverlay> createState() => _AppSplashOverlayState();
}

class _AppSplashOverlayState extends State<AppSplashOverlay>
    with TickerProviderStateMixin {
  late final bool _enabled;
  late final AnimationController _introController;
  late final AnimationController _exitController;
  Timer? _dismissTimer;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _enabled = widget.forceShowInTests || !_isWidgetTestBinding;
    _introController = AnimationController(
      vsync: this,
      duration: widget.holdDuration,
    );
    _exitController = AnimationController(
      vsync: this,
      duration: widget.exitDuration,
    );

    if (!_enabled) {
      _dismissed = true;
      return;
    }

    if (widget.forceShowInTests) {
      _startChoreography();
    } else {
      // Wait until the first real frame paints so Web/Android never misses the start.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _dismissed) return;
        _startChoreography();
      });
    }
  }

  void _startChoreography() {
    _introController.forward();
    _dismissTimer = Timer(widget.holdDuration, _startExit);
  }

  void _startExit() {
    if (!mounted || _dismissed) return;
    _exitController.forward().whenComplete(() {
      if (!mounted) return;
      setState(() => _dismissed = true);
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _introController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  double _computeIconScale(double introT, double exitT) {
    // Phase 1 (0.00..0.48): Silky zoom out (1.16 -> 0.78)
    // Phase 2 (0.48..1.00): Silky zoom in  (0.78 -> 1.12)
    // Exit    (0.00..1.00): Smooth launch zoom in (1.12 -> 2.35) while dissolving
    final double baseScale;
    if (introT < 0.48) {
      final p = Curves.easeInOutSine.transform(introT / 0.48);
      baseScale = 1.16 - (0.38 * p);
    } else {
      final p = Curves.easeInOutCubic.transform((introT - 0.48) / 0.52);
      baseScale = 0.78 + (0.34 * p);
    }

    if (exitT <= 0.0) return baseScale;
    final exitCurve = Curves.easeInOutQuart.transform(exitT);
    return baseScale + (1.23 * exitCurve);
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return widget.child;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canvasColor =
        isDark ? const Color(0xFF0A0D14) : const Color(0xFFFAFBFD);

    return Stack(
      children: <Widget>[
        widget.child,
        Positioned.fill(
          child: AnimatedBuilder(
            animation: Listenable.merge(<Listenable>[
              _introController,
              _exitController,
            ]),
            builder: (context, _) {
              final introT = _introController.value;
              final exitT = _exitController.value;
              final fadeIn = Curves.easeOutCubic.transform(
                (introT / 0.22).clamp(0.0, 1.0),
              );
              final overlayOpacity =
                  (1.0 - Curves.easeInOutCubic.transform(exitT)).clamp(0.0, 1.0);
              final scale = _computeIconScale(introT, exitT);

              return IgnorePointer(
                ignoring: exitT > 0.2,
                child: Opacity(
                  opacity: overlayOpacity,
                  child: ColoredBox(
                    color: canvasColor,
                    child: Center(
                      child: Opacity(
                        opacity: fadeIn,
                        child: Transform.scale(
                          scale: scale,
                          child: SizedBox(
                            width: 88,
                            height: 88,
                            child: SvgPicture.asset(
                              'assets/illustrations/logo_glyph.svg',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
