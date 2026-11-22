import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../errors/app_error.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'motion_widgets.dart';

/// Polished Orisale v4 empty/error card with smart 401 re-login CTA.
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.error,
    required this.onRetry,
    this.onReLogin,
  });

  final Object error;
  final VoidCallback onRetry;
  final VoidCallback? onReLogin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final appError = AppErrorMapper.fromObject(error);
    final isUnauthorized = appError is UnauthorizedError;

    final title = isUnauthorized ? 'Sesi Berakhir' : 'Gagal Memuat';
    final subtitle = isUnauthorized
        ? 'Silakan masuk kembali untuk melanjutkan.'
        : appError.userMessage;

    final primaryLabel = isUnauthorized && onReLogin != null
        ? 'Masuk Ulang'
        : 'Coba Lagi';
    final primaryAction =
        isUnauthorized && onReLogin != null ? onReLogin! : onRetry;

    final buttonBg = isDark ? AppColors.darkPrimary : AppColors.lightCharcoal;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: FadeSlideIn(
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xl + 4,
                AppSpacing.xl,
                AppSpacing.xl,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: colorScheme.outline,
                  width: AppSpacing.hairlineBorder,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: isUnauthorized ? 116 : 68,
                    height: isUnauthorized ? 92 : 68,
                    padding: EdgeInsets.all(isUnauthorized ? 10 : 16),
                    decoration: BoxDecoration(
                      color: isUnauthorized
                          ? (isDark
                              ? AppColors.darkSurfaceSoft
                              : AppColors.lightSurfaceSoft)
                          : (isDark
                              ? AppColors.roseSoftDark
                              : AppColors.roseSoftLight),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: isUnauthorized
                        ? SvgPicture.asset(
                            'assets/illustrations/undraw_login.svg',
                            fit: BoxFit.contain,
                          )
                        : Icon(
                            Icons.wifi_off_rounded,
                            size: 32,
                            color: isDark
                                ? const Color(0xFFF87171)
                                : AppColors.rose,
                          ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs + 2),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    child: BouncyTap(
                      onTap: primaryAction,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: buttonBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              isUnauthorized && onReLogin != null
                                  ? Icons.login_rounded
                                  : Icons.refresh_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              primaryLabel,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (isUnauthorized && onReLogin != null) ...<Widget>[
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: onRetry,
                      child: Text(
                        'Muat Ulang',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
