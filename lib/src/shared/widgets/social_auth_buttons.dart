import '../../imports/imports.dart';

/// Google and Apple sign-in buttons shown on auth screens.
class SocialAuthButtons extends StatelessWidget {
  const SocialAuthButtons({super.key, this.dividerLabel = 'Ou continuer avec'});

  final String dividerLabel;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: AppDivider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
              child: Text(
                dividerLabel,
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ),
            const Expanded(child: AppDivider()),
          ],
        ),
        SizedBox(height: AppSpacing.lg.h),
        Row(
          children: [
            Expanded(
              child: _SocialButton(
                icon: SvgPicture.asset(AppAssets.googleIcon, height: 20.h),
                label: 'Google',
                onPressed: () {},
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: _SocialButton(
                icon: SvgPicture.asset(AppAssets.appleIcon, height: 20.h),
                label: 'Apple',
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final Widget icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
        side: BorderSide(color: cs.outlineVariant),
        shape: const RoundedRectangleBorder(borderRadius: AppBorders.button),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(width: AppSpacing.sm.w),
          Text(label, style: tt.labelLarge),
        ],
      ),
    );
  }
}
