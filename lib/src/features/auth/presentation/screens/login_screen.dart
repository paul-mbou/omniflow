import 'package:omniflow/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:omniflow/src/imports/core_imports.dart';
import 'package:omniflow/src/imports/packages_imports.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController(text: 'jean@boutique.cm');
    final passwordController = useTextEditingController();
    final obscurePassword = useState(true);

    final isLoading = ref.watch(authControllerProvider);

    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    Future<void> handleLogin() async {
      if (!(formKey.currentState?.validate() ?? false)) return;

      ref
          .read(authControllerProvider.notifier)
          .login(
            context: context,
            email: emailController.text,
            password: passwordController.text,
          );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: Column(
            children: [
              SizedBox(height: AppSpacing.xxxl.h),
              const AppBrandLogo(),
              SizedBox(height: AppSpacing.lg.h),
              Text(
                'Bon retour',
                style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: AppSpacing.sm.h),
              Text(
                'Connectez-vous à votre espace Omniflow',
                textAlign: TextAlign.center,
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
              SizedBox(height: AppSpacing.xxxl.h),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      validator: (v) {
                        if (AppUtils.isBlank(v)) return 'Mot de passe requis';
                        if (v!.length < 6) {
                          return 'Mot de passe trop court';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () => context.push(AppRoutes.forgotPassword),
                        child: Text(
                          'Mot de passe oublié ?',
                          style: tt.bodySmall?.copyWith(color: cs.primary),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    AppButton(
                      label: 'Se connecter',
                      isLoading: isLoading,
                      onPressed: isLoading ? null : handleLogin,
                      width: ButtonSize.large,
                      isFullWidth: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xl.h),
              const SocialAuthButtons(),
              SizedBox(height: AppSpacing.xl.h),
              InkWell(
                onTap: () => context.push(AppRoutes.signup),
                child: RichText(
                  text: TextSpan(
                    text: 'Pas encore de compte ? ',
                    style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                    children: [
                      TextSpan(
                        text: 'Créer un compte',
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
