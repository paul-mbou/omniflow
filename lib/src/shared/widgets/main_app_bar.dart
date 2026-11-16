import '../../imports/imports.dart';

/// App bar used on main tab screens — title, optional subtitle, actions.
class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showLogo = true,
    this.actions,
  });

  final String title;
  final String? subtitle;
  final bool showLogo;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return AppBar(
      title: Row(
        children: [
          if (showLogo) ...[
            const AppBrandLogo(size: 36),
            SizedBox(width: AppSpacing.sm.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions:
          actions ??
          [
            _AppBarIconButton(
              icon: HugeIcons.strokeRoundedNotification01,
              onPressed: () {},
            ),
            _AppBarIconButton(
              icon: HugeIcons.strokeRoundedMenu01,
              onPressed: () {},
            ),
          ],
    );
  }
}

class _AppBarIconButton extends StatelessWidget {
  const _AppBarIconButton({required this.icon, required this.onPressed});

  final List<List<dynamic>> icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(right: AppSpacing.xs.w),
      child: Material(
        color: cs.surfaceContainerHighest,
        shape: const CircleBorder(),
        child: IconButton(
          icon: AppIcon(icon: icon, size: AppIconSize.md),
          onPressed: onPressed,
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }
}
