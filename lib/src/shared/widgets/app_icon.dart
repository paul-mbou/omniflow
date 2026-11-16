import '../../imports/imports.dart';

/// Displays a [HugeIcon] from the HugeIcons stroke-rounded set.
///
/// Do not use Material [Icons] in UI — always pass a `HugeIcons.strokeRounded*` path.
class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    required this.icon,
    this.size = AppIconSize.md,
    this.color,
  });

  /// HugeIcons path (`List<List<dynamic>>`), e.g. `HugeIcons.strokeRoundedSearch01`.
  final List<List<dynamic>> icon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return HugeIcon(icon: icon, size: size, color: color);
  }
}
