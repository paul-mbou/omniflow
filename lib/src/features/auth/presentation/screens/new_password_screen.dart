import 'package:omniflow/src/imports/core_imports.dart';
import 'package:omniflow/src/imports/packages_imports.dart';

class NewPasswordScreen extends HookConsumerWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final obscurePassword = useState(true);
    final obscureConfirmPassword = useState(true);
    final isLoading = useState(false);
    final passwordStrength = useState<double>(0);

    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    void checkPasswordStrength(String password) {
      double strength = 0;
      if (password.length >= 8) strength += 0.25;
      if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
      if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;
      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        strength += 0.25;
      }
      passwordStrength.value = strength;
    }

    Future<void> handleResetPassword() async {
      if (!(formKey.currentState?.validate() ?? false)) return;

      isLoading.value = true;
      // TODO: Call auth provider to reset password
      await Future.delayed(const Duration(seconds: 2));
      isLoading.value = false;

      if (context.mounted) {
        showGlobalToast(message: 'Mot de passe réinitialisé avec succès');
        context.go(AppRoutes.login);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg.w,
            vertical: AppSpacing.lg.h,
          ),
          child: Column(
            children: [
              AuthScreenHeader(
                showBackButton: true,
                title: 'Nouveau mot de passe',
                subtitle:
                    'Choisissez un mot de passe fort pour sécuriser votre compte Omniflow',
                icon: HugeIcons.strokeRoundedSquareLock01,
                iconBackgroundColor: context.appColors.successContainer,
                iconColor: context.appColors.success,
              ),
              SizedBox(height: AppSpacing.xxxl.h),

              // Form
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Password field
                    Text(
                      'Nouveau mot de passe',
                      style: tt.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    TextFormField(
                      controller: passwordController,
                      enabled: !isLoading.value,
                      obscureText: obscurePassword.value,
                      decoration: AppFieldAdornments.withIcons(
                        InputDecoration(
                          hintText: '••••••••',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        leadingIcon: HugeIcons.strokeRoundedSquareLock01,
                        trailingIcon: AppFieldAdornments.suffixAction(
                          icon: obscurePassword.value
                              ? HugeIcons.strokeRoundedViewOff
                              : HugeIcons.strokeRoundedView,
                          onPressed: () =>
                              obscurePassword.value = !obscurePassword.value,
                          tooltip: 'Afficher le mot de passe',
                        ),
                      ),
                      onChanged: (value) => checkPasswordStrength(value),
                      validator: (v) {
                        if (v?.isEmpty ?? true) {
                          return 'Mot de passe requis';
                        }
                        if (v!.length < 8) {
                          return 'Au moins 8 caractères';
                        }
                        if (!RegExp(r'[A-Z]').hasMatch(v)) {
                          return 'Une lettre majuscule requise';
                        }
                        if (!RegExp(r'[0-9]').hasMatch(v)) {
                          return 'Un chiffre requis';
                        }
                        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(v)) {
                          return 'Un caractère spécial requis';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppSpacing.sm.h),

                    // Password strength indicator
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: List.generate(
                            4,
                            (i) => Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: i < 3 ? AppSpacing.xs.w : 0,
                                ),
                                child: Container(
                                  height: 4.h,
                                  decoration: BoxDecoration(
                                    color: passwordStrength.value > i * 0.25
                                        ? (passwordStrength.value < 0.5
                                              ? Colors.red
                                              : passwordStrength.value < 0.75
                                              ? Colors.orange
                                              : Colors.green)
                                        : cs.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(2.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs.h),
                        Text(
                          'Mot de passe ${passwordStrength.value < 0.5
                              ? 'faible'
                              : passwordStrength.value < 0.75
                              ? 'moyen'
                              : 'fort'}',
                          style: tt.labelSmall?.copyWith(
                            color: passwordStrength.value < 0.5
                                ? Colors.red
                                : passwordStrength.value < 0.75
                                ? Colors.orange
                                : Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.md.h),

                    // Password requirements
                    Container(
                      padding: EdgeInsets.all(AppSpacing.md.w),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _RequirementRow(
                            label: 'Au moins 8 caractères',
                            met: (passwordController.text.length >= 8),
                          ),
                          _RequirementRow(
                            label: 'Une lettre majuscule',
                            met: RegExp(
                              r'[A-Z]',
                            ).hasMatch(passwordController.text),
                          ),
                          _RequirementRow(
                            label: 'Un chiffre',
                            met: RegExp(
                              r'[0-9]',
                            ).hasMatch(passwordController.text),
                          ),
                          _RequirementRow(
                            label: r'Un caractère spécial (!@#$…)',
                            met: RegExp(
                              r'[!@#$%^&*(),.?":{}|<>]',
                            ).hasMatch(passwordController.text),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg.h),

                    // Confirm password field
                    Text(
                      'Confirmer le mot de passe',
                      style: tt.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    TextFormField(
                      controller: confirmPasswordController,
                      enabled: !isLoading.value,
                      obscureText: obscureConfirmPassword.value,
                      decoration: AppFieldAdornments.withIcons(
                        InputDecoration(
                          hintText: '••••••••',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        leadingIcon: HugeIcons.strokeRoundedSquareLock01,
                        trailingIcon: AppFieldAdornments.suffixAction(
                          icon: obscureConfirmPassword.value
                              ? HugeIcons.strokeRoundedViewOff
                              : HugeIcons.strokeRoundedView,
                          onPressed: () => obscureConfirmPassword.value =
                              !obscureConfirmPassword.value,
                          tooltip: 'Afficher le mot de passe',
                        ),
                      ),
                      validator: (v) {
                        if (v?.isEmpty ?? true) {
                          return 'Confirmation requise';
                        }
                        if (v != passwordController.text) {
                          return 'Les mots de passe ne correspondent pas';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppSpacing.xxxl.h),

                    // Reset password button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isLoading.value ? null : handleResetPassword,
                        icon: isLoading.value
                            ? SizedBox(
                                height: 20.h,
                                width: 20.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: cs.onPrimary,
                                ),
                              )
                            : const AppIcon(
                                icon: HugeIcons.strokeRoundedShield01,
                              ),
                        label: const Text('Réinitialiser le mot de passe'),
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg.h),

                    // Back to login
                    Center(
                      child: TextButton.icon(
                        onPressed: () => context.go(AppRoutes.login),
                        icon: const AppIcon(
                          icon: HugeIcons.strokeRoundedArrowLeft01,
                          size: AppIconSize.sm,
                        ),
                        label: const Text('Retour à la connexion'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  const _RequirementRow({required this.label, required this.met});

  final String label;
  final bool met;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs.h),
      child: Row(
        children: [
          AppIcon(
            icon: met
                ? HugeIcons.strokeRoundedCheckmarkCircle01
                : HugeIcons.strokeRoundedCircle,
            size: AppIconSize.sm,
            color: met ? Colors.green : cs.outlineVariant,
          ),
          SizedBox(width: AppSpacing.sm.w),
          Text(
            label,
            style: tt.labelSmall?.copyWith(
              color: met ? Colors.green : cs.outlineVariant,
            ),
          ),
        ],
      ),
    );
  }
}
