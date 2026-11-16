import 'package:omniflow/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:omniflow/src/imports/core_imports.dart';
import 'package:omniflow/src/imports/packages_imports.dart';

class SignupScreen extends HookConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameController = useTextEditingController(
      text: 'Jean-Baptiste Mbarga',
    );
    final shopController = useTextEditingController(
      text: 'Boutique Centrale Yaoundé',
    );
    final phoneController = useTextEditingController(text: '6 90 12 34 56');
    final emailController = useTextEditingController(text: 'jean@boutique.cm');
    final passwordController = useTextEditingController();
    final obscurePassword = useState(true);
    final acceptedTerms = useState(false);
    final passwordStrength = useState<double>(0);
    final hasPassword = useState(false);

    final isLoading = ref.watch(authControllerProvider);

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
      hasPassword.value = password.isNotEmpty;
    }

    Future<void> handleSignup() async {
      if (!(formKey.currentState?.validate() ?? false)) return;
      if (!acceptedTerms.value) {
        showGlobalToast(message: 'Veuillez accepter les conditions');
        return;
      }

      ref
          .read(authControllerProvider.notifier)
          .signUp(
            context: context,
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text,
          );
    }

    final strengthColor = passwordStrength.value < 0.5
        ? Colors.red
        : passwordStrength.value < 0.75
        ? Colors.orange
        : Colors.green;
    final strengthLabel = passwordStrength.value < 0.5
        ? 'faible'
        : passwordStrength.value < 0.75
        ? 'moyenne'
        : 'forte';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Column(
            children: [
              SizedBox(height: AppSpacing.lg.h),
              const AuthScreenHeader(
                showBackButton: true,
                title: 'Créer un compte',
                subtitle:
                    'Rejoignez Omniflow et gérez votre boutique en toute simplicité',
              ),
              SizedBox(height: AppSpacing.xxxl.h),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      controller: nameController,
                      enabled: !isLoading,
                      label: 'Nom complet',
                      leadingIcon: HugeIcons.strokeRoundedUser,
                      validator: (v) =>
                          AppUtils.isBlank(v) ? 'Nom requis' : null,
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    AppTextField(
                      controller: shopController,
                      enabled: !isLoading,
                      label: 'Nom de la boutique',
                      leadingIcon: HugeIcons.strokeRoundedStore01,
                      validator: (v) =>
                          AppUtils.isBlank(v) ? 'Boutique requise' : null,
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    Text(
                      'Numéro de téléphone',
                      style: tt.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md.w,
                            vertical: AppSpacing.md.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: cs.outlineVariant),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Text('+237', style: tt.bodyMedium),
                              const AppIcon(
                                icon: HugeIcons.strokeRoundedArrowDown01,
                                size: AppIconSize.sm,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm.w),
                        Expanded(
                          child: AppTextField(
                            controller: phoneController,
                            enabled: !isLoading,
                            label: '',
                            leadingIcon: HugeIcons.strokeRoundedCall,
                            validator: (v) =>
                                AppUtils.isBlank(v) ? 'Téléphone requis' : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    AppTextField(
                      controller: emailController,
                      enabled: !isLoading,
                      label: 'Adresse e-mail',
                      leadingIcon: HugeIcons.strokeRoundedMail01,
                      validator: (v) {
                        if (AppUtils.isBlank(v)) return 'E-mail requis';
                        if (!AppUtils.isValidEmail(v!)) {
                          return 'E-mail invalide';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    AppTextField(
                      controller: passwordController,
                      enabled: !isLoading,
                      label: 'Mot de passe',
                      obscureText: obscurePassword.value,
                      leadingIcon: HugeIcons.strokeRoundedSquareLock01,
                      suffix: AppFieldAdornments.suffixAction(
                        icon: obscurePassword.value
                            ? HugeIcons.strokeRoundedViewOff
                            : HugeIcons.strokeRoundedView,
                        onPressed: () =>
                            obscurePassword.value = !obscurePassword.value,
                        tooltip: 'Afficher le mot de passe',
                      ),
                      onChanged: checkPasswordStrength,
                      validator: (v) {
                        if (AppUtils.isBlank(v)) return 'Mot de passe requis';
                        if (v!.length < 8) return 'Au moins 8 caractères';
                        return null;
                      },
                    ),
                    if (hasPassword.value) ...[
                      SizedBox(height: AppSpacing.sm.h),
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
                                      ? strengthColor
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
                        passwordStrength.value < 0.75
                            ? 'Sécurité $strengthLabel — ajoutez un caractère spécial'
                            : 'Sécurité $strengthLabel',
                        style: tt.labelSmall?.copyWith(color: strengthColor),
                      ),
                    ],
                    SizedBox(height: AppSpacing.md.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24.w,
                          height: 24.h,
                          child: Checkbox(
                            value: acceptedTerms.value,
                            onChanged: (v) => acceptedTerms.value = v ?? false,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm.w),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: 'J\'accepte les ',
                              style: tt.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Conditions d\'utilisation',
                                  style: TextStyle(color: cs.primary),
                                ),
                                const TextSpan(text: ' et la '),
                                TextSpan(
                                  text: 'Politique de confidentialité',
                                  style: TextStyle(color: cs.primary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    AppButton(
                      label: 'Créer mon compte',
                      isLoading: isLoading,
                      onPressed: isLoading ? null : handleSignup,
                      width: ButtonSize.large,
                      isFullWidth: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xl.h),
              const SocialAuthButtons(dividerLabel: 'Ou s\'inscrire avec'),
              SizedBox(height: AppSpacing.xl.h),
              InkWell(
                onTap: () => context.push(AppRoutes.login),
                child: RichText(
                  text: TextSpan(
                    text: 'Déjà un compte ? ',
                    style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                    children: [
                      TextSpan(
                        text: 'Se connecter',
                        style: TextStyle(
                          color: cs.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.xl.h),
            ],
          ),
        ),
      ),
    );
  }
}
