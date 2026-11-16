import '../../imports/imports.dart';

/// Compact HugeIcon for text-field icon slots.
class AppFieldIcon extends StatelessWidget {
  const AppFieldIcon({super.key, required this.icon, this.color});

  final List<List<dynamic>> icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return AppIcon(
      icon: icon,
      size: AppIconSize.field,
      color: color ?? cs.onSurfaceVariant,
    );
  }
}

/// Icon slots and padding for [InputDecoration] text fields.
abstract final class AppFieldAdornments {
  static const BoxConstraints iconConstraints = BoxConstraints(
    minWidth: 36,
    minHeight: 36,
  );

  static const EdgeInsets fieldContentPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 10,
  );

  static Widget leadingSlot(List<List<dynamic>> icon, {Color? color}) {
    return AppFieldIcon(icon: icon, color: color);
  }

  static Widget suffixAction({
    required List<List<dynamic>> icon,
    Color? color,
    VoidCallback? onPressed,
    String? tooltip,
  }) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      icon: AppFieldIcon(icon: icon, color: color),
    );
  }

  /// Applies compact, always-visible icon slots to a decoration.
  static InputDecoration withIcons(
    InputDecoration decoration, {
    List<List<dynamic>>? leadingIcon,
    Color? leadingIconColor,
    Widget? trailingIcon,
  }) {
    return decoration.copyWith(
      isDense: true,
      contentPadding: fieldContentPadding,
      prefixIcon: leadingIcon != null
          ? leadingSlot(leadingIcon, color: leadingIconColor)
          : decoration.prefixIcon,
      prefixIconConstraints: iconConstraints,
      suffixIcon: trailingIcon ?? decoration.suffixIcon,
      suffixIconConstraints: iconConstraints,
    );
  }
}
