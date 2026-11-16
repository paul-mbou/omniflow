import '../../imports/imports.dart';

/// Omniflow brand mark — blue rounded square with a lightning bolt.
class AppBrandLogo extends StatelessWidget {
  const AppBrandLogo({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: AppBorders.brand,
      ),
      child: Center(
        child: AppIcon(
          icon: HugeIcons.strokeRoundedFlash,
          color: cs.onPrimary,
          size: size * 0.4,
        ),
      ),
    );
  }
}
