import 'package:go_router/go_router.dart';
import 'package:omniflow/src/features/auth/presentation/screens/code_verification_screen.dart';
import 'package:omniflow/src/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:omniflow/src/features/auth/presentation/screens/forgot_password_send_code_screen.dart';
// Auth screens
import 'package:omniflow/src/features/auth/presentation/screens/login_screen.dart';
import 'package:omniflow/src/features/auth/presentation/screens/new_password_screen.dart';
import 'package:omniflow/src/features/auth/presentation/screens/signup_screen.dart';
import 'package:omniflow/src/features/checkout/presentation/screens/checkout_screen.dart';
// Main app screens
import 'package:omniflow/src/features/home/presentation/screens/home_page.dart';
import 'package:omniflow/src/features/invoices/presentation/screens/invoices_screen.dart';
// Onboarding
import 'package:omniflow/src/features/onboarding/presentation/screens/onboarding_page.dart';
import 'package:omniflow/src/features/products/presentation/screens/products_screen.dart';
import 'package:omniflow/src/features/reports/presentation/screens/reports_screen.dart';
import 'package:omniflow/src/routing/app_routes.dart';
import 'package:omniflow/src/routing/global_navigator.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: <RouteBase>[
    // Onboarding
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),

    // Authentication routes
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      name: 'signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgotPassword',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPasswordSendCode,
      name: 'forgotPasswordSendCode',
      builder: (context, state) => const ForgotPasswordSendCodeScreen(),
    ),
    GoRoute(
      path: AppRoutes.verifyCode,
      name: 'verifyCode',
      builder: (context, state) => const CodeVerificationScreen(),
    ),
    GoRoute(
      path: AppRoutes.newPassword,
      name: 'newPassword',
      builder: (context, state) => const NewPasswordScreen(),
    ),

    // Main app routes
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.checkout,
      name: 'checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: AppRoutes.invoices,
      name: 'invoices',
      builder: (context, state) => const InvoicesScreen(),
    ),
    GoRoute(
      path: AppRoutes.products,
      name: 'products',
      builder: (context, state) => const ProductsScreen(),
    ),
    GoRoute(
      path: AppRoutes.reports,
      name: 'reports',
      builder: (context, state) => const ReportsScreen(),
    ),
  ],
);
