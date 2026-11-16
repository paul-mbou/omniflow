import 'package:omniflow/src/features/auth/presentation/providers/session_provider.dart';
import 'package:omniflow/src/imports/core_imports.dart';
import 'package:omniflow/src/imports/packages_imports.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final semantic = context.appColors;

    final session = ref.watch(sessionProvider);
    final userName = session.user?.name ?? 'Jean-Baptiste';

    return Scaffold(
      appBar: const MainAppBar(
        title: 'Omniflow',
        subtitle: 'Boutique Centrale',
      ),
      bottomNavigationBar: const MainBottomNav(currentTab: MainTab.home),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroHeader(userName: userName),
            Transform.translate(
              offset: Offset(0, -AppSpacing.lg.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
                child: Row(
                  children: [
                    Expanded(
                      child: _KpiCard(
                        icon: HugeIcons.strokeRoundedShoppingBag01,
                        badgeLabel: '+5',
                        badgeColor: semantic.successContainer!,
                        badgeTextColor: semantic.success,
                        value: '34 ventes',
                        label: 'Ventes aujourd\'hui',
                      ),
                    ),
                    SizedBox(width: AppSpacing.md.w),
                    Expanded(
                      child: _KpiCard(
                        icon: HugeIcons.strokeRoundedAlert01,
                        badgeLabel: 'urgent',
                        badgeColor: cs.errorContainer,
                        badgeTextColor: cs.error,
                        value: '7 articles',
                        label: 'Stock critique',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg.w,
                0,
                AppSpacing.lg.w,
                AppSpacing.lg.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    title: 'Ventes cette semaine',
                    actionLabel: 'Rapport complet',
                    onAction: () => context.go(AppRoutes.reports),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  const _WeeklySalesChart(),
                  SizedBox(height: AppSpacing.xl.h),
                  _SectionHeader(
                    title: 'Dernières ventes',
                    actionLabel: 'Voir tout',
                    onAction: () => context.go(AppRoutes.checkout),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  const _ListCard(
                    children: [
                      _SaleTile(
                        icon: HugeIcons.strokeRoundedMoney01,
                        title: 'Vente #0042',
                        subtitle: 'Espèces · 14:32',
                        amount: '25 000 XAF',
                      ),
                      _SaleTile(
                        icon: HugeIcons.strokeRoundedSmartPhone01,
                        title: 'Vente #0041',
                        subtitle: 'Mobile Money · 13:17',
                        amount: '58 500 XAF',
                      ),
                      _SaleTile(
                        icon: HugeIcons.strokeRoundedMoney01,
                        title: 'Vente #0040',
                        subtitle: 'Espèces · 11:05',
                        amount: '12 300 XAF',
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xl.h),
                  _SectionHeader(
                    title: 'Alertes de stock',
                    actionLabel: 'Gérer',
                    onAction: () => context.go(AppRoutes.products),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  const _ListCard(
                    children: [
                      _StockAlertTile(
                        product: 'Huile de palme 1L',
                        category: 'Alimentation',
                        quantity: '1',
                        minStock: '10',
                        tone: _AlertTone.critical,
                      ),
                      _StockAlertTile(
                        product: 'Savon Protex x6',
                        category: 'Hygiène',
                        quantity: '3',
                        minStock: '8',
                        tone: _AlertTone.warning,
                      ),
                      _StockAlertTile(
                        product: 'Sucre 5kg',
                        category: 'Alimentation',
                        quantity: '0',
                        minStock: '5',
                        tone: _AlertTone.critical,
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xl.h),
                  Text(
                    'Actions rapides',
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionButton(
                          icon: HugeIcons.strokeRoundedPlusSign,
                          label: 'Nouvelle vente',
                          onTap: () => context.go(AppRoutes.checkout),
                        ),
                      ),
                      Expanded(
                        child: _QuickActionButton(
                          icon: HugeIcons.strokeRoundedPackage01,
                          label: 'Ajouter produit',
                          onTap: () => context.go(AppRoutes.products),
                        ),
                      ),
                      Expanded(
                        child: _QuickActionButton(
                          icon: HugeIcons.strokeRoundedTask01,
                          label: 'Inventaire',
                          onTap: () => context.go(AppRoutes.invoices),
                        ),
                      ),
                      Expanded(
                        child: _QuickActionButton(
                          icon: HugeIcons.strokeRoundedShoppingCart01,
                          label: 'Caisse',
                          onTap: () => context.go(AppRoutes.checkout),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final semantic = context.appColors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg.w,
        AppSpacing.md.h,
        AppSpacing.lg.w,
        AppSpacing.xxl.h,
      ),
      decoration: BoxDecoration(
        color: cs.primary,
        // borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bonjour,',
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onPrimary.withValues(alpha: 0.85),
                      ),
                    ),
                    Text(
                      userName,
                      style: tt.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 26.r,
                backgroundColor: cs.onPrimary.withValues(alpha: 0.2),
                backgroundImage: const NetworkImage(
                  'https://i.pravatar.cc/150?img=12',
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacing.md.w),
            decoration: BoxDecoration(
              color: cs.onPrimary.withValues(alpha: 0.12),
              borderRadius: AppBorders.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chiffre d\'affaires du jour',
                        style: tt.bodySmall?.copyWith(
                          color: cs.onPrimary.withValues(alpha: 0.85),
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs.h),
                      Text(
                        '847 500 XAF',
                        style: tt.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm.w,
                    vertical: AppSpacing.xs.h,
                  ),
                  decoration: BoxDecoration(
                    color: semantic.successContainer,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '+12,4%',
                    style: tt.labelSmall?.copyWith(
                      color: semantic.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.icon,
    required this.badgeLabel,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.value,
    required this.label,
  });

  final List<List<dynamic>> icon;
  final String badgeLabel;
  final Color badgeColor;
  final Color badgeTextColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppBorders.lg,
        border: Border.all(color: cs.outline),
        boxShadow: AppShadows.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: AppBorders.sm,
                ),
                child: Center(
                  child: AppIcon(
                    icon: icon,
                    color: cs.primary,
                    size: AppIconSize.sm,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm.w,
                  vertical: AppSpacing.xs.h,
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  badgeLabel,
                  style: tt.labelSmall?.copyWith(
                    color: badgeTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          Text(
            value,
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            label,
            style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            children: [
              Text(
                actionLabel,
                style: tt.labelLarge?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                size: AppIconSize.sm,
                color: cs.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeeklySalesChart extends StatelessWidget {
  const _WeeklySalesChart();

  static const _days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
  static const _values = [0.35, 0.5, 0.62, 0.72, 1.0, 0.55, 0.38];

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppBorders.lg,
        border: Border.all(color: cs.outline),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 120.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_days.length, (index) {
                return _BarItem(
                  label: _days[index],
                  value: _values[index],
                  highlighted: index == 4,
                );
              }),
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lun — Dim',
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
              Text(
                'Total: 3 248 000 XAF',
                style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  const _BarItem({
    required this.label,
    required this.value,
    required this.highlighted,
  });

  final String label;
  final double value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 28.w,
          height: 80.h * value,
          decoration: BoxDecoration(
            color: highlighted ? cs.primary : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        SizedBox(height: AppSpacing.sm.h),
        Text(
          label,
          style: tt.labelSmall?.copyWith(
            color: highlighted ? cs.primary : cs.onSurfaceVariant,
            fontWeight: highlighted ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppBorders.lg,
        border: Border.all(color: cs.outline),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              Divider(height: 1, color: cs.outlineVariant),
          ],
        ],
      ),
    );
  }
}

class _SaleTile extends StatelessWidget {
  const _SaleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  final List<List<dynamic>> icon;
  final String title;
  final String subtitle;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final semantic = context.appColors;

    return Padding(
      padding: EdgeInsets.all(AppSpacing.md.w),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: AppBorders.sm,
            ),
            child: Center(
              child: AppIcon(
                icon: icon,
                color: cs.primary,
                size: AppIconSize.sm,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: tt.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: semantic.success,
            ),
          ),
        ],
      ),
    );
  }
}

enum _AlertTone { critical, warning }

class _StockAlertTile extends StatelessWidget {
  const _StockAlertTile({
    required this.product,
    required this.category,
    required this.quantity,
    required this.minStock,
    required this.tone,
  });

  final String product;
  final String category;
  final String quantity;
  final String minStock;
  final _AlertTone tone;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final semantic = context.appColors;

    final toneColor = tone == _AlertTone.critical ? cs.error : semantic.warning;
    final toneContainer = tone == _AlertTone.critical
        ? cs.errorContainer
        : semantic.warningContainer!;

    return Padding(
      padding: EdgeInsets.all(AppSpacing.md.w),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: toneContainer,
              borderRadius: AppBorders.sm,
            ),
            child: Center(
              child: AppIcon(
                icon: HugeIcons.strokeRoundedPackage01,
                color: toneColor,
                size: AppIconSize.sm,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product,
                  style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  category,
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                quantity,
                style: tt.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: toneColor,
                ),
              ),
              Text(
                'min: $minStock',
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final List<List<dynamic>> icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AppIcon(
                icon: icon,
                color: cs.primary,
                size: AppIconSize.md,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.sm.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: tt.labelSmall?.copyWith(fontWeight: FontWeight.w500),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
