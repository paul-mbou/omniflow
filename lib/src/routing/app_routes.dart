/// Centralized route path constants for GoRouter.
///
/// Use these variables instead of raw strings throughout the app.
/// Example: `context.go(AppRoutes.onboarding)` instead of `context.go('/')`.
abstract final class AppRoutes {
  AppRoutes._();

  // Splash & Onboarding
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';

  // Authentication
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String forgotPasswordSendCode = '/forgot-password-send-code';
  static const String verifyCode = '/verify-code';
  static const String newPassword = '/new-password';

  // Main App
  static const String home = '/';
  static const String checkout = '/checkout';
  static const String invoices = '/invoices';
  static const String products = '/products';
  static const String reports = '/reports';
}
