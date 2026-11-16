import '../../imports/imports.dart';

enum MainTab { home, checkout, products, reports }

/// Bottom navigation shared across main app screens.
class MainBottomNav extends StatelessWidget {
  const MainBottomNav({super.key, required this.currentTab});

  final MainTab currentTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentTab.index,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: AppIcon(
            icon: HugeIcons.strokeRoundedGridView,
            size: AppIconSize.lg,
          ),
          activeIcon: AppIcon(
            icon: HugeIcons.strokeRoundedGridView,
            size: AppIconSize.lg,
          ),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: AppIcon(
            icon: HugeIcons.strokeRoundedShoppingCart01,
            size: AppIconSize.lg,
          ),
          activeIcon: AppIcon(
            icon: HugeIcons.strokeRoundedShoppingCart01,
            size: AppIconSize.lg,
          ),
          label: 'Caisse',
        ),
        BottomNavigationBarItem(
          icon: AppIcon(
            icon: HugeIcons.strokeRoundedPackage01,
            size: AppIconSize.lg,
          ),
          activeIcon: AppIcon(
            icon: HugeIcons.strokeRoundedPackage01,
            size: AppIconSize.lg,
          ),
          label: 'Produits',
        ),
        BottomNavigationBarItem(
          icon: AppIcon(
            icon: HugeIcons.strokeRoundedBarChart,
            size: AppIconSize.lg,
          ),
          activeIcon: AppIcon(
            icon: HugeIcons.strokeRoundedBarChart,
            size: AppIconSize.lg,
          ),
          label: 'Rapports',
        ),
      ],
      onTap: (index) {
        final tab = MainTab.values[index];
        if (tab == currentTab) return;

        switch (tab) {
          case MainTab.home:
            context.go(AppRoutes.home);
          case MainTab.checkout:
            context.go(AppRoutes.checkout);
          case MainTab.products:
            context.go(AppRoutes.products);
          case MainTab.reports:
            context.go(AppRoutes.reports);
        }
      },
    );
  }
}
