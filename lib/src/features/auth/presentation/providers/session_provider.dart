import 'dart:async';
import 'package:omniflow/src/imports/imports.dart';
import 'package:omniflow/src/features/auth/domain/entities/user.dart';
import 'package:omniflow/src/features/auth/domain/repositories/auth_repository.dart';

import 'package:omniflow/src/features/auth/data/repositories/auth_repository_impl.dart';

/// Provides the AuthRepository instance
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

/// Provides a stream of auth state changes
final authStateStreamProvider = StreamProvider<AppUser?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.onAuthStateChanged;
});

/// Provides the current session state
final sessionProvider = NotifierProvider<SessionNotifier, SessionState>(
  SessionNotifier.new,
);

/// Session states
enum SessionStatus { unknown, authenticated, unauthenticated }

class SessionState {
  final SessionStatus status;
  final AppUser? user;

  const SessionState({this.status = SessionStatus.unknown, this.user});

  SessionState copyWith({SessionStatus? status, AppUser? user}) {
    return SessionState(status: status ?? this.status, user: user ?? this.user);
  }
}

class SessionNotifier extends Notifier<SessionState> {
  late final AuthRepository _repository;
  StreamSubscription<AppUser?>? _authSub;

  @override
  SessionState build() {
    _repository = ref.read(authRepositoryProvider);
    ref.onDispose(() => _authSub?.cancel());
    _init();
    return const SessionState();
  }

  Future<void> _init() async {
    // Check persisted session first
    final result = await _repository.checkAuthState();
    result.fold(
      (_) => state = const SessionState(status: SessionStatus.unauthenticated),
      (user) {
        if (user != null) {
          state = SessionState(status: SessionStatus.authenticated, user: user);
        } else {
          state = const SessionState(status: SessionStatus.unauthenticated);
        }
      },
    );

    await _authSub?.cancel();

    // Listen for future changes
    _authSub = _repository.onAuthStateChanged.listen((user) {
      if (user != null) {
        state = SessionState(status: SessionStatus.authenticated, user: user);
      } else {
        state = const SessionState(status: SessionStatus.unauthenticated);
      }
    });
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const SessionState(status: SessionStatus.unauthenticated);
  }
}
