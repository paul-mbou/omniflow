import 'dart:async';

import 'package:omniflow/src/imports/core_imports.dart';
import 'package:omniflow/src/imports/packages_imports.dart';

class CodeVerificationScreen extends HookConsumerWidget {
  const CodeVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = useState<List<String>>(['', '', '', '', '', '']);
    final isLoading = useState(false);
    final timeRemaining = useState(270); // 4:30 minutes
    final focusNodes = useMemoized(
      () => List.generate(6, (_) => FocusNode()),
      [],
    );

    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    // Timer effect
    useEffect(() {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (timeRemaining.value > 0) {
          timeRemaining.value--;
        } else {
          timer.cancel();
        }
      });
      return () {};
    }, []);

    Future<void> handleVerifyCode() async {
      final fullCode = code.value.join();
      if (fullCode.length != 6) {
        showGlobalToast(message: 'Veuillez entrer un code à 6 chiffres');
        return;
      }

      isLoading.value = true;
      // TODO: Call auth provider to verify code
      await Future.delayed(const Duration(seconds: 2));
      isLoading.value = false;

      // Navigate to new password screen
      if (context.mounted) {
        context.push('/new-password');
      }
    }

    Future<void> handleResendCode() async {
      isLoading.value = true;
      // TODO: Call auth provider to resend code
      await Future.delayed(const Duration(seconds: 2));
      isLoading.value = false;
      timeRemaining.value = 270;
    }

    String formatTime(int seconds) {
      final int minutes = seconds ~/ 60;
      final int secs = seconds % 60;
      return '$minutes:${secs.toString().padLeft(2, '0')}';
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
                showBackButton: true,
                title: 'Vérification du code',
                icon: HugeIcons.strokeRoundedShield01,
              ),
              SizedBox(height: AppSpacing.sm.h),
              Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text: 'Nous avons envoyé un code à 6 chiffres à\n',
                  style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                  children: [
                    TextSpan(
                      text: 'jean@boutique.cm',
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.xxxl.h),

              // Code input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: 50.w,
                    height: 60.h,
                    child: TextFormField(
                      focusNode: focusNodes[index],
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        counter: const Offstage(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: cs.outline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: cs.primary, width: 2),
                        ),
                      ),
                      style: tt.headlineSmall,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          code.value[index] = value;
                          if (index < 5) {
                            focusNodes[index + 1].requestFocus();
                          } else {
                            focusNodes[index].unfocus();
                          }
                        } else {
                          code.value[index] = '';
                        }
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.md.h),

              // Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppIcon(
                    icon: HugeIcons.strokeRoundedClock01,
                    size: AppIconSize.sm,
                    color: cs.onSurfaceVariant,
                  ),
                  SizedBox(width: AppSpacing.xs.w),
                  Text.rich(
                    TextSpan(
                      text: 'Code expirant dans ',
                      style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                      children: [
                        TextSpan(
                          text: formatTime(timeRemaining.value),
                          style: tt.bodySmall?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xxxl.h),

              // Verify button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isLoading.value ? null : handleVerifyCode,
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
                          icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                        ),
                  label: const Text('Vérifier le code'),
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),

              // Resend code
              Center(
                child: Column(
                  children: [
                    Text(
                      'Vous n\'avez pas reçu le code ?',
                      style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    SizedBox(height: AppSpacing.xs.h),
                    TextButton.icon(
                      onPressed: timeRemaining.value > 0
                          ? null
                          : handleResendCode,
                      icon: const AppIcon(icon: HugeIcons.strokeRoundedRefresh),
                      label: const Text('Renvoyer le code'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),

              // Modify email
              Center(
                child: TextButton.icon(
                  onPressed: () => context.pop(),
                  icon: const AppIcon(
                    icon: HugeIcons.strokeRoundedEdit01,
                    size: AppIconSize.sm,
                  ),
                  label: const Text('Modifier l\'adresse e-mail'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
