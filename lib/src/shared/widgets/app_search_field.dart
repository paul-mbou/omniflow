import '../../imports/imports.dart';

/// Compact search bar with always-visible leading/trailing icons.
///
/// Uses a [Row] layout so hint text cannot overlap icons (unlike
/// [InputDecoration.prefix], which hides adornments when unfocused).
class AppSearchField extends HookWidget {
  const AppSearchField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.leadingIcon = HugeIcons.strokeRoundedSearch01,
    this.trailingIcon,
    this.trailingIconColor,
    this.onTrailingPressed,
    this.trailingTooltip,
    this.fillColor,
  });

  final String hintText;
  final ValueChanged<String>? onChanged;
  final List<List<dynamic>> leadingIcon;
  final List<List<dynamic>>? trailingIcon;
  final Color? trailingIconColor;
  final VoidCallback? onTrailingPressed;
  final String? trailingTooltip;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final focusNode = useFocusNode();
    useListenable(focusNode);
    final isFocused = focusNode.hasFocus;

    return AnimatedContainer(
      duration: AppDurations.fast,
      decoration: BoxDecoration(
        color: fillColor ?? cs.surface,
        borderRadius: AppBorders.input,
        border: Border.all(
          color: isFocused ? cs.primary : cs.outline,
          width: isFocused ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 4),
        child: Row(
          children: [
            AppFieldIcon(icon: leadingIcon),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                focusNode: focusNode,
                onChanged: onChanged,
                style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                cursorColor: cs.primary,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: tt.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            if (trailingIcon != null)
              AppFieldAdornments.suffixAction(
                icon: trailingIcon!,
                color: trailingIconColor,
                onPressed: onTrailingPressed,
                tooltip: trailingTooltip,
              ),
          ],
        ),
      ),
    );
  }
}
