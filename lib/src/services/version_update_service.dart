import '../imports/imports.dart';

/// Checks the app store for updates and prompts the user via [upgrader].
class VersionUpdateService {
  VersionUpdateService._();
  static final VersionUpdateService instance = VersionUpdateService._();

  Upgrader _createUpgrader({String? minAppVersion}) {
    return Upgrader(
      minAppVersion: minAppVersion,
      debugLogging: false,
    );
  }

  /// Check if a newer version of the app is available in the store.
  FutureEither<UpgraderVersionInfo?> checkForUpdate() async {
    return runTask(() async {
      final upgrader = _createUpgrader();
      await upgrader.initialize();
      if (!upgrader.isUpdateAvailable()) return null;
      return upgrader.versionInfo;
    }, requiresNetwork: true);
  }

  /// High-level method to check for updates and show the dialog automatically if available.
  FutureEither<void> checkAndShowUpdate({bool mandatory = false}) async {
    return runTask(() async {
      final upgrader = _createUpgrader();
      await upgrader.initialize();
      if (!upgrader.isUpdateAvailable()) return;

      final context = rootContext;
      if (context == null) {
        AppLogger.warning('Cannot show update dialog: rootContext is null');
        return;
      }
      if (!context.mounted) return;

      await _showAlert(
        context: context,
        upgrader: upgrader,
        mandatory: mandatory,
      );
    }, requiresNetwork: true);
  }

  /// Display a platform-specific update dialog.
  FutureEither<void> showUpdateAlert({
    bool mandatory = false,
    String? title,
    String? content,
    String? cancelText,
    String? updateText,
  }) async {
    return runTask(() async {
      final context = rootContext;
      if (context == null) return;

      final upgrader = _createUpgrader();
      await upgrader.initialize();
      if (!upgrader.isUpdateAvailable()) return;
      if (!context.mounted) return;

      await _showAlert(
        context: context,
        upgrader: upgrader,
        mandatory: mandatory,
        title: title,
        content: content,
        cancelText: cancelText,
        updateText: updateText,
      );
    }, requiresNetwork: true);
  }

  /// Display an update bottom sheet.
  FutureEither<void> showUpdateBottomSheet({
    bool mandatory = false,
    String? title,
    Widget? content,
  }) async {
    return runTask(() async {
      final context = rootContext;
      if (context == null) return;

      final upgrader = _createUpgrader();
      await upgrader.initialize();
      if (!upgrader.isUpdateAvailable()) return;
      if (!context.mounted) return;

      await _showBottomSheet(
        context: context,
        upgrader: upgrader,
        mandatory: mandatory,
        title: title,
        content: content,
      );
    }, requiresNetwork: true);
  }

  /// Display a dedicated update page.
  FutureEither<void> showUpdatePage({
    bool mandatory = false,
    Widget? page,
  }) async {
    return runTask(() async {
      final context = rootContext;
      if (context == null) return;

      final upgrader = _createUpgrader();
      await upgrader.initialize();
      if (!upgrader.isUpdateAvailable()) return;

      if (!context.mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) =>
              page ??
              Scaffold(
                appBar: AppBar(
                  title: const Text('New version available'),
                  automaticallyImplyLeading: !mandatory,
                ),
                body: UpgradeCard(
                  upgrader: upgrader,
                  showIgnore: !mandatory,
                  showLater: !mandatory,
                ),
              ),
        ),
      );
    }, requiresNetwork: true);
  }

  Future<void> _showAlert({
    required BuildContext context,
    required Upgrader upgrader,
    bool mandatory = false,
    String? title,
    String? content,
    String? cancelText,
    String? updateText,
  }) async {
    if (!context.mounted) return;

    final messages = upgrader.determineMessages(context);
    final isBlocked = mandatory || upgrader.blocked();
    final releaseNotes = upgrader.releaseNotes;

    await showDialog<void>(
      context: context,
      barrierDismissible: !mandatory,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title ??
              messages.message(UpgraderMessage.title) ??
              'Update Available'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(content ?? upgrader.body(messages)),
                if (releaseNotes != null && releaseNotes.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  Text(
                    messages.message(UpgraderMessage.releaseNotes) ??
                        'Release Notes',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Text(releaseNotes),
                ],
              ],
            ),
          ),
          actions: [
            if (!isBlocked)
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  cancelText ??
                      messages.message(UpgraderMessage.buttonTitleLater) ??
                      'UPDATE LATER',
                ),
              ),
            TextButton(
              onPressed: () async {
                await upgrader.sendUserToAppStore();
                if (dialogContext.mounted && !isBlocked) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text(
                updateText ??
                    messages.message(UpgraderMessage.buttonTitleUpdate) ??
                    'UPDATE',
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showBottomSheet({
    required BuildContext context,
    required Upgrader upgrader,
    bool mandatory = false,
    String? title,
    Widget? content,
  }) async {
    if (!context.mounted) return;

    final messages = upgrader.determineMessages(context);
    final isBlocked = mandatory || upgrader.blocked();

    await showModalBottomSheet<void>(
      context: context,
      isDismissible: !mandatory,
      enableDrag: !mandatory,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.all(AppSpacing.xl.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title ??
                    messages.message(UpgraderMessage.title) ??
                    'Update Available',
                style: context.theme.textTheme.titleLarge,
              ),
              SizedBox(height: AppSpacing.md.h),
              content ?? Text(upgrader.body(messages)),
              SizedBox(height: AppSpacing.lg.h),
              AppButton(
                label: messages.message(UpgraderMessage.buttonTitleUpdate) ??
                    'UPDATE',
                onPressed: () async {
                  await upgrader.sendUserToAppStore();
                  if (sheetContext.mounted) {
                    Navigator.of(sheetContext).pop();
                  }
                },
              ),
              if (!isBlocked) ...[
                SizedBox(height: AppSpacing.sm.h),
                AppButton(
                  label: messages.message(UpgraderMessage.buttonTitleLater) ??
                      'UPDATE LATER',
                  variant: ButtonVariant.secondary,
                  onPressed: () => Navigator.of(sheetContext).pop(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
