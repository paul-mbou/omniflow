import 'package:omniflow/src/imports/core_imports.dart';
import 'package:omniflow/src/imports/packages_imports.dart';

import 'package:omniflow/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:omniflow/src/features/auth/data/repositories/auth_repository_impl.dart';

// Provides the single instance of AuthRepositoryImpl
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authControllerProvider = NotifierProvider<AuthController, bool>(
  AuthController.new,
);

class AuthController extends Notifier<bool> {
  late final AuthRepository _repository;

  @override
  bool build() {
    _repository = ref.read(authRepositoryProvider);
    return false;
  }

  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    state = true;

    final result = await _repository.login(email: email, password: password);

    state = false;
    result.fold(
      (failure) {
        if (context.mounted) {
          showToast(context, message: failure.message, status: 'error');
        }
      },
      (user) {
        if (rootContext?.mounted ?? false) {
          rootContext!.go(AppRoutes.home);
        }
      },
    );
  }

  Future<void> signUp({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    state = true;

    final result = await _repository.signUp(
      name: name,
      email: email,
      password: password,
    );

    state = false;
    result.fold(
      (failure) {
        if (context.mounted) {
          showToast(context, message: failure.message, status: 'error');
        }
      },
      (user) {
        if (rootContext?.mounted ?? false) {
          rootContext!.go(AppRoutes.home);
        }
      },
    );
  }

  Future<void> forgotPassword({
    required BuildContext context,
    required String email,
  }) async {
    state = true;

    final result = await _repository.forgotPassword(email: email);

    state = false;
    result.fold(
      (failure) {
        if (context.mounted) {
          showToast(context, message: failure.message, status: 'error');
        }
      },
      (success) {
        if (context.mounted) {
          showToast(
            context,
            message: 'Password reset link sent successfully',
            status: 'success',
          );
        }
        if (context.mounted) {
          context.go(AppRoutes.login);
        }
      },
    );
  }
}
