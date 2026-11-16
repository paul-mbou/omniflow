import 'package:flutter/material.dart';

/// Design tokens extracted from Omniflow UI screenshots (2025 handoff).
///
/// Source screens: Connexion, Inscription, Mot de passe oublié, Vérification OTP,
/// Nouveau mot de passe, Tableau de bord, Caisse, Produits, Rapports, Factures.
abstract final class OmniflowTokens {
  OmniflowTokens._();

  // ── Brand ─────────────────────────────────────────────────────────────────

  static const Color primary = Color(0xFF1D4ED8);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // ── Surfaces ──────────────────────────────────────────────────────────────

  /// App canvas — light cool gray, not pure white.
  static const Color scaffold = Color(0xFFF8F9FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF1F5F9);

  // ── Text ──────────────────────────────────────────────────────────────────

  static const Color onSurface = Color(0xFF111827);
  static const Color onSurfaceVariant = Color(0xFF6B7280);

  // ── Borders ───────────────────────────────────────────────────────────────

  static const Color outline = Color(0xFFE5E7EB);
  static const Color outlineVariant = Color(0xFFE5E7EB);

  // ── Containers ────────────────────────────────────────────────────────────

  static const Color primaryContainer = Color(0xFFEFF6FF);
  static const Color onPrimaryContainer = Color(0xFF1D4ED8);
  static const Color secondaryContainer = Color(0xFFEBF2FF);

  // ── Semantic ──────────────────────────────────────────────────────────────

  static const Color success = Color(0xFF059669);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color successContainer = Color(0xFFECFDF5);
  static const Color onSuccessContainer = Color(0xFF065F46);

  static const Color warning = Color(0xFFD97706);
  static const Color onWarning = Color(0xFFFFFFFF);
  static const Color warningContainer = Color(0xFFFFFBEB);
  static const Color onWarningContainer = Color(0xFF92400E);

  static const Color error = Color(0xFFDC2626);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onErrorContainer = Color(0xFF991B1B);

  static const Color info = Color(0xFF1D4ED8);
  static const Color onInfo = Color(0xFFFFFFFF);
  static const Color infoContainer = Color(0xFFEFF6FF);
  static const Color onInfoContainer = Color(0xFF1E40AF);

  // ── Layout ────────────────────────────────────────────────────────────────

  static const double pagePadding = 24;
  static const double buttonHeight = 56;
  static const double inputHeight = 52;

  // ── Radii (logical px, apply via AppBorders or .r in widgets) ───────────

  static const double radiusXs = 8;
  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 20;
  static const double radiusXl = 24;
}
