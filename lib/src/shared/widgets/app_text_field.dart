import '../../imports/core_imports.dart';

/// A themed text form field wrapping [TextFormField].
///
/// Use [leadingIcon] with a `HugeIcons.strokeRounded*` path. Icons use the
/// compact `prefixIcon` slot (always visible). For search bars prefer
/// [AppSearchField].
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.leadingIcon,
    this.leadingIconColor,
    this.suffix,
    this.initialValue,
    this.autofocus = false,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final List<List<dynamic>>? leadingIcon;
  final Color? leadingIconColor;
  final Widget? suffix;
  final String? initialValue;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      autofocus: autofocus,
      style: tt.bodyMedium?.copyWith(color: cs.onSurface),
      cursorColor: cs.primary,
      decoration: AppFieldAdornments.withIcons(
        InputDecoration(labelText: label, hintText: hint),
        leadingIcon: leadingIcon,
        leadingIconColor: leadingIconColor,
        trailingIcon: suffix,
      ),
    );
  }
}
