import 'package:omniflow/src/features/auth/presentation/providers/session_provider.dart';
import 'package:omniflow/src/imports/core_imports.dart';
import 'package:omniflow/src/imports/packages_imports.dart';

class SessionListenerWrapper extends ConsumerWidget {
  final Widget child;
  const SessionListenerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SessionState>(sessionProvider, (prev, sessionState) {
      if (sessionState.status == SessionStatus.unknown) return;

      FlutterNativeSplash.remove();

      final target = switch (sessionState.status) {
        SessionStatus.authenticated => AppRoutes.home,
        SessionStatus.unauthenticated => AppRoutes.home,
        SessionStatus.unknown => null,
      };

      if (target != null && appRouter.state.matchedLocation != target) {
        appRouter.go(target);
      }
    });

    return child;
  }
}
