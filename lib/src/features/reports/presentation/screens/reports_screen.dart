import 'package:omniflow/src/imports/core_imports.dart';
import 'package:omniflow/src/imports/packages_imports.dart';

enum _ReportPeriod { today, week, month, year }

class ReportsScreen extends HookConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = useState(_ReportPeriod.month);
    final cs = context.theme.colorScheme;

    return Scaffold(
      appBar: const MainAppBar(
        title: 'Rapports',
        subtitle: 'Vue d\'ensemble financière',
      ),
      bottomNavigationBar: const MainBottomNav(currentTab: MainTab.reports),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColoredBox(
            color: cs.surface,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md.w,
                AppSpacing.sm.h,
                AppSpacing.md.w,
                AppSpacing.sm.h,
              ),
              child: Column(
                children: [
                  _PeriodSelector(
                    selected: selectedPeriod.value,
                    onSelected: (period) => selectedPeriod.value = period,
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  const _DateNavigator(label: 'Mai 2025'),
                ],
              ),
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.md.w,
                    AppSpacing.md.h,
                    AppSpacing.md.w,
                    AppSpacing.md.h,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const _RevenueSummaryCard(),
                      SizedBox(height: AppSpacing.lg.h),
                      const _WeeklyEvolutionCard(),
                      SizedBox(height: AppSpacing.lg.h),
                      const _CategoryRevenueCard(),
                      SizedBox(height: AppSpacing.xl.h),
                      const _TopSellersSection(),
                      SizedBox(height: AppSpacing.md.h),
                      AppButton(
                        label: 'Exporter le rapport (PDF)',
                        variant: ButtonVariant.outline,
                        height: ButtonSize.large,
                        isFullWidth: true,
                        prefixIcon: const AppIcon(
                          icon: HugeIcons.strokeRoundedDownload01,
                        ),
                        onPressed: () {
                          showGlobalToast(message: 'Rapport exporté en PDF');
                        },
                      ),
                    ]),
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

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({required this.selected, required this.onSelected});

  final _ReportPeriod selected;
  final ValueChanged<_ReportPeriod> onSelected;

  static const _periods = [
    (_ReportPeriod.today, 'Aujourd\'hui'),
    (_ReportPeriod.week, 'Semaine'),
    (_ReportPeriod.month, 'Mois'),
    (_ReportPeriod.year, 'Année'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(color: cs.surface),
      child: Row(
        spacing: AppSpacing.xs.w,
        children: [
          for (var i = 0; i < _periods.length; i++) ...[
            Expanded(
              child: FilterChip(
                label: SizedBox(
                  width: double.infinity,
                  child: Text(_periods[i].$2, textAlign: TextAlign.center),
                ),
                selected: selected == _periods[i].$1,
                onSelected: (_) => onSelected(_periods[i].$1),
                showCheckmark: false,
                labelStyle: tt.labelMedium?.copyWith(
                  color: selected == _periods[i].$1
                      ? cs.onPrimary
                      : cs.onSurfaceVariant,
                  fontWeight: selected == _periods[i].$1
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
                selectedColor: cs.primary,
                backgroundColor: cs.surfaceContainerHighest,
                side: BorderSide.none,
                padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppBorders.full,
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DateNavigator extends StatelessWidget {
  const _DateNavigator({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final tt = context.theme.textTheme;

    return Row(
      spacing: AppSpacing.xs.w,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _NavCircleButton(
          icon: HugeIcons.strokeRoundedArrowLeft01,
          onPressed: () {},
        ),
        Text(
          label,
          style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        _NavCircleButton(
          icon: HugeIcons.strokeRoundedArrowRight01,
          onPressed: () {},
        ),
      ],
    );
  }
}

class _NavCircleButton extends StatelessWidget {
  const _NavCircleButton({required this.icon, required this.onPressed});

  final List<List<dynamic>> icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Material(
      color: cs.surfaceContainerHighest,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 36.w,
          height: 36.w,
          child: Center(
            child: AppIcon(
              icon: icon,
              size: AppIconSize.sm,
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _RevenueSummaryCard extends StatelessWidget {
  const _RevenueSummaryCard();

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final semantic = context.appColors;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: AppBorders.lg,
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chiffre d\'affaires — Mai 2025',
            style: tt.bodySmall?.copyWith(
              color: cs.onPrimary.withValues(alpha: 0.85),
            ),
          ),
          SizedBox(height: AppSpacing.sm.h),
          Text(
            '3 850 000 XAF',
            style: tt.headlineMedium?.copyWith(
              color: cs.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSpacing.sm.h),
          Row(
            children: [
              AppIcon(
                icon: HugeIcons.strokeRoundedAnalytics03,
                size: AppIconSize.sm,
                color: cs.onPrimary,
              ),
              SizedBox(width: AppSpacing.xs.w),
              Text(
                '+18,3 % vs avril',
                style: tt.labelMedium?.copyWith(
                  color: cs.onPrimary.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          Divider(color: cs.onPrimary.withValues(alpha: 0.2), height: 1),
          SizedBox(height: AppSpacing.md.h),
          Row(
            children: [
              const Expanded(
                child: _SummaryMetric(label: 'Dépenses', value: '1 420 000'),
              ),
              Container(
                width: 1,
                height: 40.h,
                color: cs.onPrimary.withValues(alpha: 0.2),
              ),
              const Expanded(
                child: _SummaryMetric(
                  label: 'Bénéfice net',
                  value: '2 430 000',
                ),
              ),
              Container(
                width: 1,
                height: 40.h,
                color: cs.onPrimary.withValues(alpha: 0.2),
              ),
              const Expanded(
                child: _SummaryMetric(label: 'Ventes', value: '847'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      children: [
        Text(
          label,
          style: tt.bodySmall?.copyWith(
            color: cs.onPrimary.withValues(alpha: 0.85),
          ),
        ),
        SizedBox(height: AppSpacing.xs.h),
        Text(
          value,
          style: tt.titleSmall?.copyWith(
            color: cs.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _WeeklyEvolutionCard extends StatelessWidget {
  const _WeeklyEvolutionCard();

  static const _values = [0.4, 0.55, 0.65, 1.0];
  static const _labels = ['S1', 'S2', 'S3', 'S4'];

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Évolution hebdomadaire',
          style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: AppSpacing.xs.h),
        _ReportCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 140.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(_labels.length, (index) {
                    return _WeeklyBar(
                      label: _labels[index],
                      value: _values[index],
                      highlighted: index == 3,
                    );
                  }),
                ),
              ),
              SizedBox(height: AppSpacing.md.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Semaine 1–4',
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  Text(
                    'Total: 3 850 000 XAF',
                    style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeeklyBar extends StatelessWidget {
  const _WeeklyBar({
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
        if (highlighted)
          Text(
            '100%',
            style: tt.labelSmall?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w600,
            ),
          )
        else
          SizedBox(height: AppSpacing.md.h),
        SizedBox(height: AppSpacing.xs.h),
        Container(
          width: 36.w,
          height: 90.h * value,
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

class _CategoryRevenueCard extends StatelessWidget {
  const _CategoryRevenueCard();

  static const _categories = [
    _CategoryData(
      label: 'Alimentation',
      percentage: 48,
      amount: '1 847 200 XAF',
      colorIndex: 0,
    ),
    _CategoryData(
      label: 'Hygiène',
      percentage: 22,
      amount: '847 000 XAF',
      colorIndex: 1,
    ),
    _CategoryData(
      label: 'Boisson',
      percentage: 18,
      amount: '693 400 XAF',
      colorIndex: 2,
    ),
    _CategoryData(
      label: 'Laitier',
      percentage: 12,
      amount: '462 400 XAF',
      colorIndex: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final semantic = context.appColors;
    final colors = [
      cs.primary,
      cs.secondary,
      semantic.warning,
      cs.onSurfaceVariant,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Revenus par catégorie',
          style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: AppSpacing.xs.h),
        _ReportCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: AppBorders.sm,
                child: SizedBox(
                  height: 10.h,
                  child: Row(
                    children: [
                      for (var i = 0; i < _categories.length; i++)
                        Expanded(
                          flex: _categories[i].percentage,
                          child: Container(
                            color: colors[_categories[i].colorIndex],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),
              for (var i = 0; i < _categories.length; i++) ...[
                if (i > 0) SizedBox(height: AppSpacing.md.h),
                _CategoryRow(
                  data: _categories[i],
                  color: colors[_categories[i].colorIndex],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryData {
  const _CategoryData({
    required this.label,
    required this.percentage,
    required this.amount,
    required this.colorIndex,
  });

  final String label;
  final int percentage;
  final String amount;
  final int colorIndex;
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.data, required this.color});

  final _CategoryData data;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tt = context.theme.textTheme;

    return Row(
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: AppSpacing.sm.w),
        Expanded(child: Text(data.label, style: tt.bodyMedium)),
        Text(
          '${data.percentage}%',
          style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(width: AppSpacing.md.w),
        Text(
          data.amount,
          style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _TopSellersSection extends StatelessWidget {
  const _TopSellersSection();

  static const _products = [
    _TopProduct(
      rank: 1,
      name: 'Huile Végétale 1L',
      sold: 312,
      amount: '374 400 XAF',
    ),
    _TopProduct(
      rank: 2,
      name: 'Riz 5kg Parfumé',
      sold: 68,
      amount: '306 000 XAF',
    ),
    _TopProduct(
      rank: 3,
      name: 'Lait Gloria 400g',
      sold: 96,
      amount: '268 800 XAF',
    ),
    _TopProduct(rank: 4, name: 'Sucre 5kg', sold: 74, amount: '259 000 XAF'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Meilleures ventes',
              style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                children: [
                  Text(
                    'Voir tout',
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
        ),
        SizedBox(height: AppSpacing.xs.h),
        _ReportCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < _products.length; i++) ...[
                _TopProductTile(product: _products[i]),
                if (i < _products.length - 1)
                  Divider(height: 1, color: cs.outlineVariant),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TopProduct {
  const _TopProduct({
    required this.rank,
    required this.name,
    required this.sold,
    required this.amount,
  });

  final int rank;
  final String name;
  final int sold;
  final String amount;
}

class _TopProductTile extends StatelessWidget {
  const _TopProductTile({required this.product});

  final _TopProduct product;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final isFirst = product.rank == 1;

    return Padding(
      padding: EdgeInsets.all(AppSpacing.md.w),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: isFirst ? cs.primary : cs.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${product.rank}',
                style: tt.labelMedium?.copyWith(
                  color: isFirst ? cs.onPrimary : cs.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: AppSpacing.xxs.h),
                Text(
                  '${product.sold} vendus',
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Text(
            product.amount,
            style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppBorders.lg,
        border: Border.all(color: cs.outline),
        boxShadow: AppShadows.subtle,
      ),
      child: child,
    );
  }
}
