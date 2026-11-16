import 'package:omniflow/src/imports/core_imports.dart';
import 'package:omniflow/src/imports/packages_imports.dart';

class ForgotPasswordSendCodeScreen extends HookConsumerWidget {
  const ForgotPasswordSendCodeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController(text: 'jean@boutique.cm');
    final phoneController = useTextEditingController();
    final phoneCountryCode = useState('+237');
    final selectedMethod = useState<String>('email');
    final isLoading = useState(false);

    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    Future<void> handleSendCode() async {
      if (!(formKey.currentState?.validate() ?? false)) return;

      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      isLoading.value = false;

      if (context.mounted) {
        context.push(AppRoutes.verifyCode);
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
              const AuthScreenHeader(
                title: 'Mot de passe oublié ?',
                subtitle:
                    'Saisissez votre e-mail ou numéro de téléphone pour recevoir un code de vérification',
              ),
              SizedBox(height: AppSpacing.xxxl.h),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          _MethodTab(
                            label: 'E-mail',
                            icon: HugeIcons.strokeRoundedMail01,
                            selected: selectedMethod.value == 'email',
                            onTap: () => selectedMethod.value = 'email',
                          ),
                          _MethodTab(
                            label: 'SMS',
                            icon: HugeIcons.strokeRoundedSmartPhone01,
                            selected: selectedMethod.value == 'sms',
                            onTap: () => selectedMethod.value = 'sms',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    if (selectedMethod.value == 'email') ...[
                      Text(
                        'Adresse e-mail',
                        style: tt.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm.h),
                      TextFormField(
                        controller: emailController,
                        enabled: !isLoading.value,
                        decoration: AppFieldAdornments.withIcons(
                          InputDecoration(
                            hintText: 'jean@boutique.cm',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          leadingIcon: HugeIcons.strokeRoundedMail01,
                        ),
                        validator: (v) {
                          if (v?.isEmpty ?? true) return 'E-mail requis';
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v!)) {
                            return 'E-mail invalide';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSpacing.md.h),
                      Container(
                        padding: EdgeInsets.all(AppSpacing.md.w),
                        decoration: BoxDecoration(
                          color: cs.primaryContainer.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: cs.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppIcon(
                              icon: HugeIcons.strokeRoundedInformationCircle,
                              color: cs.primary,
                              size: AppIconSize.md,
                            ),
                            SizedBox(width: AppSpacing.sm.w),
                            Expanded(
                              child: Text(
                                'Un code à 6 chiffres sera envoyé à cette adresse. Vérifiez vos courriers indésirables si vous ne recevez rien sous 2 minutes.',
                                style: tt.bodySmall?.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Numéro de téléphone',
                        style: tt.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm.h),
                      Row(
                        children: [
                          DropdownButton<String>(
                            value: phoneCountryCode.value,
                            items: ['+237', '+33', '+225', '+230']
                                .map(
                                  (code) => DropdownMenuItem(
                                    value: code,
                                    child: Text(code),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) phoneCountryCode.value = value;
                            },
                          ),
                          SizedBox(width: AppSpacing.sm.w),
                          Expanded(
                            child: TextFormField(
                              controller: phoneController,
                              enabled: !isLoading.value,
                              decoration: AppFieldAdornments.withIcons(
                                InputDecoration(
                                  hintText: '6 90 12 34 56',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                leadingIcon: HugeIcons.strokeRoundedCall,
                              ),
                              validator: (v) {
                                if (v?.isEmpty ?? true) {
                                  return 'Téléphone requis';
                                }
                                if (!RegExp(
                                  r'^\d{9,}$',
                                ).hasMatch(v!.replaceAll(' ', ''))) {
                                  return 'Téléphone invalide';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: AppSpacing.xxxl.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isLoading.value ? null : handleSendCode,
                        icon: isLoading.value
                            ? SizedBox(
                                height: 20.h,
                                width: 20.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: cs.onPrimary,
                                ),
                              )
                            : const AppIcon(icon: HugeIcons.strokeRoundedSent),
                        label: Text(
                          isLoading.value ? 'Envoi...' : 'Envoyer le code',
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg.h),
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

class _MethodTab extends StatelessWidget {
  const _MethodTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final List<List<dynamic>> icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          margin: EdgeInsets.all(AppSpacing.xs.w),
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
          decoration: BoxDecoration(
            color: selected ? cs.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: selected ? AppShadows.subtle : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIcon(
                icon: icon,
                color: selected ? cs.primary : cs.onSurfaceVariant,
                size: AppIconSize.md,
              ),
              SizedBox(width: AppSpacing.sm.w),
              Text(
                label,
                style: tt.bodyMedium?.copyWith(
                  color: selected ? cs.primary : cs.onSurfaceVariant,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
