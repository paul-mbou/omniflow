import '../../imports/imports.dart';

/// Header block for auth screens — back button, logo, title and subtitle.
class AuthScreenHeader extends StatelessWidget {
  const AuthScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = true,
    this.icon,
    this.iconBackgroundColor,
    this.iconColor,
  });

  final String title;
  final String? subtitle;
  final bool showBackButton;
  final List<List<dynamic>>? icon;
  final Color? iconBackgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      children: [
        if (showBackButton)
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const AppIcon(icon: HugeIcons.strokeRoundedArrowLeft01),
              onPressed: () => context.pop(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        if (showBackButton) SizedBox(height: AppSpacing.xl.h),
        if (icon != null)
          Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              color: iconBackgroundColor ?? cs.primaryContainer,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: AppIcon(
              icon: icon!,
              size: AppIconSize.hero,
              color: iconColor ?? cs.primary,
            ),
          )
        else
          const AppBrandLogo(),
        SizedBox(height: AppSpacing.lg.h),
        Text(
          title,
          style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          SizedBox(height: AppSpacing.sm.h),
          Text(
            subtitle!,
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
