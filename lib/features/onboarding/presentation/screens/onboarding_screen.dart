import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/testing/app_widget_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../settings/presentation/notifiers/settings_notifier.dart';
import '../widgets/onboarding_slide_view.dart';

/// Concise Sky Blue onboarding persisting `onboardingSeen` on completion.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  static const List<OnboardingSlideData> _slides = <OnboardingSlideData>[
    OnboardingSlideData(
      title: 'Absensi DUDI Akurat',
      description: 'Cek radius kantor langsung dari perangkat.',
      svgAssetPath: 'assets/illustrations/undraw_onboarding.svg',
    ),
    OnboardingSlideData(
      title: 'Selfie Kamera Langsung',
      description: 'Verifikasi cepat tanpa unggah dari galeri.',
      svgAssetPath: 'assets/illustrations/undraw_checkin.svg',
    ),
    OnboardingSlideData(
      title: 'Jurnal & Rekap',
      description: 'Catat aktivitas harian dan pantau kehadiran.',
      svgAssetPath: 'assets/illustrations/undraw_jurnal.svg',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    unawaited(HapticFeedback.lightImpact());
    await ref.read(settingsProvider.notifier).completeOnboarding();
  }

  Future<void> _next() async {
    if (_currentIndex >= _slides.length - 1) {
      await _complete();
      return;
    }
    unawaited(HapticFeedback.selectionClick());
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isLast = _currentIndex == _slides.length - 1;
    final topColor =
        isDark ? const Color(0xFF0E4D7B) : AppColors.lightPrimary;
    final bottomColor =
        isDark ? const Color(0xFF0A3759) : AppColors.lightPrimaryDeep;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[topColor, bottomColor],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxContentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.xs,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        key: AppWidgetKeys.onboardingSkipButton,
                        onPressed: _complete,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Lewati',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Absensi PKL',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _slides.length,
                      onPageChanged: (index) {
                        setState(() => _currentIndex = index);
                      },
                      itemBuilder: (context, index) => OnboardingSlideView(
                        slide: _slides[index],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.xl + MediaQuery.paddingOf(context).bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _OnboardingDotsIndicator(
                          count: _slides.length,
                          activeIndex: _currentIndex,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        FilledButton(
                          key: AppWidgetKeys.onboardingNextButton,
                          onPressed: _next,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.lightCharcoal,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 54),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusMd),
                            ),
                          ),
                          child: Text(isLast ? 'Mulai' : 'Lanjut'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingDotsIndicator extends StatelessWidget {
  const _OnboardingDotsIndicator({
    required this.count,
    required this.activeIndex,
  });

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(count, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white
                : Colors.white.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
