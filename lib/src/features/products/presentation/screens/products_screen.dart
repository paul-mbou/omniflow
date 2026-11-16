import 'package:omniflow/src/imports/core_imports.dart';
import 'package:omniflow/src/imports/packages_imports.dart';

class ProductsScreen extends HookConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = useState<String>('all');
    final viewMode = useState<String>('list');
    final sortBy = useState<String>('name');
    final searchQuery = useState<String>('');

    final cs = context.theme.colorScheme;

    final products = useMemoized(
      () => const [
        _ProductData(
          id: 'ALM-001',
          name: 'Huile Végétale 1L',
          category: 'Alimentation',
          price: 1200,
          stock: 1,
        ),
        _ProductData(
          id: 'HYG-014',
          name: 'Savon Protex x6',
          category: 'Hygiène',
          price: 3000,
          stock: 3,
        ),
        _ProductData(
          id: 'ALM-002',
          name: 'Riz 5kg Parfumé',
          category: 'Alimentation',
          price: 4500,
          stock: 22,
        ),
        _ProductData(
          id: 'LAI-008',
          name: 'Lait Gloria 400g',
          category: 'Laitier',
          price: 2800,
          stock: 14,
        ),
        _ProductData(
          id: 'BOI-003',
          name: 'Eau Minérale 1.5L',
          category: 'Boisson',
          price: 400,
          stock: 0,
        ),
        _ProductData(
          id: 'ALM-007',
          name: 'Sucre 5kg',
          category: 'Alimentation',
          price: 3500,
          stock: 2,
        ),
        _ProductData(
          id: 'BOI-011',
          name: 'Café Nescafé 100g',
          category: 'Boisson',
          price: 1800,
          stock: 8,
        ),
        _ProductData(
          id: 'ALM-009',
          name: 'Farine de blé 1kg',
          category: 'Alimentation',
          price: 650,
          stock: 30,
        ),
      ],
      [],
    );

    final filteredProducts = useMemoized(() {
      final result = products.where((product) {
        if (selectedCategory.value != 'all' &&
            product.category != selectedCategory.value) {
          return false;
        }
        final query = searchQuery.value.trim().toLowerCase();
        if (query.isEmpty) return true;
        return product.name.toLowerCase().contains(query) ||
            product.id.toLowerCase().contains(query) ||
            product.category.toLowerCase().contains(query);
      }).toList();

      final sorted = [...result];
      switch (sortBy.value) {
        case 'price':
          sorted.sort((a, b) => a.price.compareTo(b.price));
        case 'stock':
          sorted.sort((a, b) => a.stock.compareTo(b.stock));
        default:
          sorted.sort((a, b) => a.name.compareTo(b.name));
      }

      return sorted;
    }, [products, selectedCategory.value, searchQuery.value, sortBy.value]);

    final inStockCount = products
        .where((p) => p.status == _StockStatus.ok)
        .length;
    final lowCount = products
        .where((p) => p.status == _StockStatus.warning)
        .length;
    final criticalCount = products
        .where((p) => p.status == _StockStatus.critical)
        .length;

    final sortLabel = switch (sortBy.value) {
      'price' => 'Prix',
      'stock' => 'Stock',
      _ => 'Nom',
    };

    return Scaffold(
      appBar: MainAppBar(
        title: 'Produits',
        subtitle: '${products.length} références',
      ),
      bottomNavigationBar: const MainBottomNav(currentTab: MainTab.products),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const AppIcon(icon: HugeIcons.strokeRoundedPlusSign),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md.w,
              AppSpacing.md.h,
              AppSpacing.md.w,
              AppSpacing.sm.h,
            ),
            child: AppSearchField(
              hintText: 'Rechercher un produit...',
              fillColor: cs.surfaceContainerHighest,
              onChanged: (value) => searchQuery.value = value,
              trailingIcon: HugeIcons.strokeRoundedFilter,
              trailingIconColor: cs.primary,
              onTrailingPressed: () {},
              trailingTooltip: 'Filtrer',
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
            child: Row(
              children: [
                for (
                  var index = 0;
                  index < _categoryFilters.length;
                  index++
                ) ...[
                  if (index > 0) SizedBox(width: AppSpacing.sm.w),
                  _CategoryChip(
                    label: _categoryFilters[index].label,
                    selected:
                        selectedCategory.value == _categoryFilters[index].value,
                    onSelected: () =>
                        selectedCategory.value = _categoryFilters[index].value,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
            child: _InventoryStatsRow(
              total: products.length,
              inStock: inStockCount,
              low: lowCount,
              critical: criticalCount,
            ),
          ),
          SizedBox(height: AppSpacing.sm.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
            child: Row(
              children: [
                Text(
                  'Trié par: $sortLabel',
                  style: context.theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                _SortActionButton(
                  label: 'Trier',
                  icon: HugeIcons.strokeRoundedSortByDown01,
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (dialogContext) => SimpleDialog(
                        title: const Text('Trier par'),
                        children: [
                          SimpleDialogOption(
                            onPressed: () {
                              sortBy.value = 'name';
                              Navigator.pop(dialogContext);
                            },
                            child: const Text('Nom'),
                          ),
                          SimpleDialogOption(
                            onPressed: () {
                              sortBy.value = 'price';
                              Navigator.pop(dialogContext);
                            },
                            child: const Text('Prix'),
                          ),
                          SimpleDialogOption(
                            onPressed: () {
                              sortBy.value = 'stock';
                              Navigator.pop(dialogContext);
                            },
                            child: const Text('Stock'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(width: AppSpacing.sm.w),
                _SortActionButton(
                  label: viewMode.value == 'list' ? 'Liste' : 'Grille',
                  icon: viewMode.value == 'list'
                      ? HugeIcons.strokeRoundedListView
                      : HugeIcons.strokeRoundedGridView,
                  onPressed: () => viewMode.value = viewMode.value == 'list'
                      ? 'grid'
                      : 'list',
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.sm.h),
          Expanded(
            child: ColoredBox(
              color: cs.surface,
              child: viewMode.value == 'list'
                  ? ListView.separated(
                      padding: EdgeInsets.only(bottom: AppSpacing.xxl.h),
                      itemCount: filteredProducts.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        color: cs.outlineVariant,
                        indent: AppSpacing.md.w,
                        endIndent: AppSpacing.md.w,
                      ),
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return _ProductListTile(product: product, onTap: () {});
                      },
                    )
                  : GridView.builder(
                      padding: EdgeInsets.all(AppSpacing.md.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: AppSpacing.md.w,
                        mainAxisSpacing: AppSpacing.md.h,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return _ProductGridCard(product: product, onTap: () {});
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

const _categoryFilters = [
  _CategoryFilter(label: 'Tout', value: 'all'),
  _CategoryFilter(label: 'Aliment.', value: 'Alimentation'),
  _CategoryFilter(label: 'Hygiène', value: 'Hygiène'),
  _CategoryFilter(label: 'Boisson', value: 'Boisson'),
];

class _CategoryFilter {
  const _CategoryFilter({required this.label, required this.value});

  final String label;
  final String value;
}

enum _StockStatus { critical, warning, ok }

class _ProductData {
  const _ProductData({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
  });

  final String id;
  final String name;
  final String category;
  final int price;
  final int stock;

  _StockStatus get status {
    if (stock <= 1) return _StockStatus.critical;
    if (stock <= 7) return _StockStatus.warning;
    return _StockStatus.ok;
  }
}

String _formatAmount(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && (raw.length - i) % 3 == 0) {
      buffer.write(' ');
    }
    buffer.write(raw[i]);
  }
  return '${buffer.toString()} XAF';
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      showCheckmark: false,
      labelStyle: TextStyle(
        color: selected ? cs.onPrimary : cs.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
      selectedColor: cs.primary,
      backgroundColor: cs.surfaceContainerHighest,
      side: BorderSide(color: selected ? cs.primary : cs.outlineVariant),
    );
  }
}

class _InventoryStatsRow extends StatelessWidget {
  const _InventoryStatsRow({
    required this.total,
    required this.inStock,
    required this.low,
    required this.critical,
  });

  final int total;
  final int inStock;
  final int low;
  final int critical;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final semantic = context.appColors;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _StatCell(
                value: '$total',
                label: 'Produits',
                valueColor: cs.onSurface,
              ),
            ),
            VerticalDivider(width: 1, color: cs.outlineVariant),
            Expanded(
              child: _StatCell(
                value: '$inStock',
                label: 'En stock',
                valueColor: semantic.success,
              ),
            ),
            VerticalDivider(width: 1, color: cs.outlineVariant),
            Expanded(
              child: _StatCell(
                value: '$low',
                label: 'Faible',
                valueColor: semantic.warning,
              ),
            ),
            VerticalDivider(width: 1, color: cs.outlineVariant),
            Expanded(
              child: _StatCell(
                value: '$critical',
                label: 'Critique',
                valueColor: cs.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  final String value;
  final String label;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      children: [
        Text(
          value,
          style: tt.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
        SizedBox(height: AppSpacing.xxs.h),
        Text(
          label,
          style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _SortActionButton extends StatelessWidget {
  const _SortActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final List<List<dynamic>> icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs.w),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: tt.labelLarge?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: AppSpacing.xxs.w),
          AppIcon(icon: icon, size: AppIconSize.sm, color: cs.primary),
        ],
      ),
    );
  }
}

class _ProductListTile extends StatelessWidget {
  const _ProductListTile({required this.product, required this.onTap});

  final _ProductData product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final tone = _stockTone(context, product.status);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md.w,
          vertical: AppSpacing.md.h,
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: tone.container,
                borderRadius: AppBorders.sm,
              ),
              child: Center(
                child: AppIcon(
                  icon: HugeIcons.strokeRoundedPackage01,
                  color: tone.foreground,
                  size: AppIconSize.md,
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
                    style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppSpacing.xxs.h),
                  Text(
                    '${product.id} · ${product.category}',
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.sm.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatAmount(product.price),
                  style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: AppSpacing.xs.h),
                _StockBadge(stock: product.stock, status: product.status),
              ],
            ),
            SizedBox(width: AppSpacing.sm.w),
            AppIcon(
              icon: HugeIcons.strokeRoundedArrowRight01,
              color: cs.onSurfaceVariant,
              size: AppIconSize.sm,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductGridCard extends StatelessWidget {
  const _ProductGridCard({required this.product, required this.onTap});

  final _ProductData product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final tone = _stockTone(context, product.status);

    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: cs.outline),
          borderRadius: AppBorders.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: tone.container,
                  borderRadius: BorderRadius.vertical(
                    top: AppBorders.lg.topLeft,
                  ),
                ),
                child: Center(
                  child: AppIcon(
                    icon: HugeIcons.strokeRoundedPackage01,
                    color: tone.foreground,
                    size: AppIconSize.lg,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.sm.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: tt.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppSpacing.xxs.h),
                  Text(
                    '${product.id} · ${product.category}',
                    style: tt.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      height: 1.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _formatAmount(product.price),
                          style: tt.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _StockBadge(stock: product.stock, status: product.status),
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

class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.stock, required this.status});

  final int stock;
  final _StockStatus status;

  @override
  Widget build(BuildContext context) {
    final tt = context.theme.textTheme;
    final tone = _stockTone(context, status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm.w,
        vertical: AppSpacing.xxs.h,
      ),
      decoration: BoxDecoration(
        color: tone.badgeBackground,
        borderRadius: AppBorders.button,
      ),
      child: Text(
        '$stock unités',
        style: tt.labelSmall?.copyWith(
          color: tone.foreground,
          fontWeight: FontWeight.w600,
          height: 1.1,
        ),
      ),
    );
  }
}

class _StockTone {
  const _StockTone({
    required this.foreground,
    required this.container,
    required this.badgeBackground,
  });

  final Color foreground;
  final Color container;
  final Color badgeBackground;
}

_StockTone _stockTone(BuildContext context, _StockStatus status) {
  final cs = context.theme.colorScheme;
  final semantic = context.appColors;

  return switch (status) {
    _StockStatus.critical => _StockTone(
      foreground: cs.error,
      container: cs.errorContainer,
      badgeBackground: cs.errorContainer,
    ),
    _StockStatus.warning => _StockTone(
      foreground: semantic.warning,
      container: semantic.warningContainer!,
      badgeBackground: semantic.warningContainer!,
    ),
    _StockStatus.ok => _StockTone(
      foreground: semantic.success,
      container: cs.surfaceContainerHighest,
      badgeBackground: semantic.successContainer!,
    ),
  };
}
