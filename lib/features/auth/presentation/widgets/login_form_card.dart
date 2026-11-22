import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/testing/app_widget_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// Pure UI concise login fields & charcoal CTA button.
class LoginFormCard extends StatelessWidget {
  const LoginFormCard({
    super.key,
    required this.formKey,
    required this.identifierController,
    required this.passwordController,
    required this.identifierFocusNode,
    required this.passwordFocusNode,
    required this.obscurePassword,
    required this.isSubmitting,
    required this.errorMessage,
    required this.onToggleObscure,
    required this.onFillDemo,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController identifierController;
  final TextEditingController passwordController;
  final FocusNode identifierFocusNode;
  final FocusNode passwordFocusNode;
  final bool obscurePassword;
  final bool isSubmitting;
  final String? errorMessage;
  final VoidCallback onToggleObscure;
  final VoidCallback onFillDemo;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (errorMessage != null) ...<Widget>[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color:
                    isDark ? AppColors.roseSoftDark : AppColors.roseSoftLight,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 20,
                    color: AppColors.rose,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            isDark ? AppColors.darkTextPrimary : AppColors.rose,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          Text(
            'NISN / Email',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs + 2),
          TextFormField(
            key: AppWidgetKeys.loginNisnField,
            controller: identifierController,
            focusNode: identifierFocusNode,
            enabled: !isSubmitting,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const <String>[AutofillHints.username],
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontFeatures: const <FontFeature>[
                FontFeature.tabularFigures(),
              ],
            ),
            decoration: const InputDecoration(
              hintText: '0078451920',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'NISN / Email wajib diisi.';
              }
              return null;
            },
            onFieldSubmitted: (_) => passwordFocusNode.requestFocus(),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Kata Sandi',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs + 2),
          TextFormField(
            key: AppWidgetKeys.loginPasswordField,
            controller: passwordController,
            focusNode: passwordFocusNode,
            enabled: !isSubmitting,
            obscureText: obscurePassword,
            textInputAction: TextInputAction.done,
            autofillHints: const <String>[AutofillHints.password],
            decoration: InputDecoration(
              hintText: 'Kata sandi',
              suffixIcon: IconButton(
                tooltip: obscurePassword
                    ? 'Tampilkan kata sandi'
                    : 'Sembunyikan kata sandi',
                onPressed: isSubmitting ? null : onToggleObscure,
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Kata sandi wajib diisi.';
              }
              if (value.trim().length < 4) {
                return 'Kata sandi minimal 4 karakter.';
              }
              return null;
            },
            onFieldSubmitted: (_) => onSubmit(),
          ),
          if (kDebugMode) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                key: AppWidgetKeys.loginDemoFillButton,
                onPressed: isSubmitting ? null : onFillDemo,
                child: const Text(
                  'Isi Akun Demo',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ] else
            const SizedBox(height: AppSpacing.lg),
          FilledButton(
            key: AppWidgetKeys.loginSubmitButton,
            onPressed: isSubmitting ? null : onSubmit,
            child: isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2.2,
                    ),
                  )
                : const Text('Masuk'),
          ),
        ],
      ),
    );
  }
}
