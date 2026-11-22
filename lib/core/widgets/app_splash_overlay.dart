import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';

bool get _isWidgetTestBinding =>
    WidgetsBinding.instance.runtimeType.toString().contains('Test');

/// Smooth Orisale v4 branded splash overlay shown on app launch.
/// Automatically bypassed during widget tests unless [forceShowInTests] is true.
class AppSplashOverlay extends StatefulWidget {
  const AppSplashOverlay({
    super.key,
    required this.child,
    this.holdDuration = const Duration(milliseconds: 1450),
    this.exitDuration = const Duration(milliseconds: 420),
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

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return widget.child;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final topColor =
        isDark ? const Color(0xFF0E4D7B) : AppColors.lightPrimary;
    final bottomColor =
        isDark ? const Color(0xFF0A3759) : AppColors.lightPrimaryDeep;

    final logoCurve = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.0, 0.42, curve: Curves.easeOutExpo),
    );
    final textCurve = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.14, 0.56, curve: Curves.easeOutExpo),
    );
    final barCurve = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.08, 0.96, curve: Curves.easeInOutCubic),
    );
    final exitCurve = CurvedAnimation(
      parent: _exitController,
      curve: Curves.easeOutExpo,
    );

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
              final exitT = exitCurve.value;
              final overlayOpacity = (1.0 - exitT).clamp(0.0, 1.0);
              final exitScale = 1.0 + (0.045 * exitT);

              final logoT = logoCurve.value;
              final textT = textCurve.value;
              final barT = barCurve.value;

              return IgnorePointer(
                ignoring: exitT > 0.15,
                child: Opacity(
                  opacity: overlayOpacity,
                  child: Transform.scale(
                    scale: exitScale,
                    child: Material(
                      color: Colors.transparent,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[topColor, bottomColor],
                          ),
                        ),
                        child: SafeArea(
                          child: Column(
                            children: <Widget>[
                              const Spacer(),
                              Opacity(
                                opacity: logoT.clamp(0.0, 1.0),
                                child: Transform.translate(
                                  offset: Offset(0, 18 * (1 - logoT)),
                                  child: Transform.scale(
                                    scale: 0.80 + (0.20 * logoT),
                                    child: Container(
                                      width: 86,
                                      height: 86,
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(26),
                                        border: Border.all(
                                          color: Colors.white
                                              .withValues(alpha: 0.35),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/illustrations/logo_glyph.svg',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Opacity(
                                opacity: textT.clamp(0.0, 1.0),
                                child: Transform.translate(
                                  offset: Offset(0, 14 * (1 - textT)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Absensi PKL',
                                        style: theme.textTheme.headlineSmall
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.6,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'PT fanajalh.id',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: Colors.white
                                              .withValues(alpha: 0.84),
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 36),
                                child: Opacity(
                                  opacity: textT.clamp(0.0, 1.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(999),
                                    child: Container(
                                      width: 96,
                                      height: 4,
                                      color:
                                          Colors.white.withValues(alpha: 0.24),
                                      alignment: Alignment.centerLeft,
                                      child: FractionallySizedBox(
                                        widthFactor: barT.clamp(0.05, 1.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(999),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
