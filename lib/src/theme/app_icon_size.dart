/// Fixed logical-pixel icon sizes for [AppIcon] / [HugeIcon].
///
/// Icons must **not** use ScreenUtil `.r` or `.sp` — Material icon metrics are
/// density-independent (dp), and HugeIcons stroke weight already reads larger
/// than Material icons at the same size.
abstract final class AppIconSize {
  /// Quantity steppers, badges, dense inline controls.
  static const double xs = 14;

  /// List tiles, KPI chips, trailing chevrons.
  static const double sm = 16;

  /// Inline search / text-field adornments.
  static const double field = 18;

  /// Default — form fields, toolbar actions, payment tiles.
  static const double md = 20;

  /// Bottom navigation, primary toolbar icons.
  static const double lg = 22;

  /// Quick-action emphasis (still compact).
  static const double xl = 24;

  /// Auth hero, empty states, error illustrations.
  static const double hero = 40;
}
