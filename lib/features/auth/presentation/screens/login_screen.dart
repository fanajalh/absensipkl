import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/errors/app_error.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/motion_widgets.dart';
import '../../../update/presentation/notifiers/app_update_notifier.dart';
import '../../../update/presentation/widgets/app_update_sheet.dart';
import '../../data/datasources/demo_auth_datasource.dart';
import '../notifiers/auth_notifier.dart';
import '../notifiers/auth_state.dart';
import '../widgets/login_form_card.dart';

/// Concise Orisale v4 sign-in screen.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _identifierFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_checkStartupUpdate());
    });
  }

  Future<void> _checkStartupUpdate() async {
    final hasUpdate =
        await ref.read(appUpdateProvider.notifier).checkOnStartupIfNeeded();
    if (!mounted || !hasUpdate) return;
    final release = ref.read(appUpdateProvider).release;
    if (release == null) return;
    await AppUpdateSheet.show(context, isMandatory: release.isMandatory);
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    _identifierFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _fillDemoCredentials() {
    _identifierController.text = DemoAuthDatasource.demoNisn;
    _passwordController.text = DemoAuthDatasource.demoPasscode;
    FocusScope.of(context).unfocus();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    FocusScope.of(context).unfocus();
    await ref.read(authProvider.notifier).login(
          identifier: _identifierController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isSubmitting = switch (authState) {
      AuthAuthenticating() || AuthLoading() => true,
      _ => false,
    };
    final errorMessage = switch (authState) {
      AuthUnauthenticated(:final error) => error?.userMessage,
      _ => null,
    };

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final heroBg = isDark ? AppColors.darkSurfaceSoft : AppColors.lightSurfaceSoft;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xl + MediaQuery.paddingOf(context).bottom,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FadeSlideIn(
                    child: Container(
                      height: 158,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: heroBg,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                      ),
                      child: GentleFloat(
                        amplitude: 5,
                        child: SvgPicture.asset(
                          'assets/illustrations/undraw_login.svg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: SizedBox(
                          width: 38,
                          height: 38,
                          child: SvgPicture.asset(
                            'assets/illustrations/logo.svg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm + 2),
                      Expanded(
                        child: Text(
                          'Masuk',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  LoginFormCard(
                    formKey: _formKey,
                    identifierController: _identifierController,
                    passwordController: _passwordController,
                    identifierFocusNode: _identifierFocus,
                    passwordFocusNode: _passwordFocus,
                    obscurePassword: _obscurePassword,
                    isSubmitting: isSubmitting,
                    errorMessage: errorMessage,
                    onToggleObscure: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                    onFillDemo: _fillDemoCredentials,
                    onSubmit: _submit,
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
