import 'package:omniflow/src/imports/core_imports.dart';
import 'package:omniflow/src/imports/packages_imports.dart';

class CheckoutScreen extends HookConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = useState('Tout');
    final selectedPaymentMethod = useState('cash');

    final selectedProducts = useState<List<Map<String, dynamic>>>([
      {
        'id': 1,
        'name': 'Huile Végétale 1L',
        'price': 1200,
        'quantity': 1,
        'category': 'Alimentation',
      },
      {
        'id': 2,
        'name': 'Savon Protex',
        'price': 500,
        'quantity': 2,
        'category': 'Hygiène',
      },
    ]);

    final catalog = useMemoized(
      () => [
        {
          'id': 1,
          'name': 'Huile Végétale 1L',
          'price': 1200,
          'category': 'Alimentation',
        },
        {'id': 2, 'name': 'Savon Protex', 'price': 500, 'category': 'Hygiène'},
        {'id': 3, 'name': 'Riz 5kg', 'price': 4500, 'category': 'Alimentation'},
        {
          'id': 4,
          'name': 'Lait Gloria 400g',
          'price': 2800,
          'category': 'Laitier',
        },
        {
          'id': 5,
          'name': 'Eau Minérale 1L',
          'price': 400,
          'category': 'Boisson',
        },
        {
          'id': 6,
          'name': 'Sucre 1kg',
          'price': 750,
          'category': 'Alimentation',
        },
      ],
      [],
    );

    const categories = [
      'Tout',
      'Alimentation',
      'Hygiène',
      'Boisson',
      'Laitier',
    ];

    double calculateSubtotal() {
      return selectedProducts.value.fold<double>(
        0,
        (sum, product) =>
            sum + (product['price'] as int) * (product['quantity'] as int),
      );
    }

    double calculateTax(double subtotal) => subtotal * 0.1925;

    double calculateTotal() {
      final subtotal = calculateSubtotal();
      return subtotal + calculateTax(subtotal);
    }

    void addProductToCart(Map<String, dynamic> product) {
      final index = selectedProducts.value.indexWhere(
        (p) => p['id'] == product['id'],
      );
      if (index >= 0) {
        final updated = [...selectedProducts.value];
        updated[index] = {
          ...updated[index],
          'quantity': (updated[index]['quantity'] as int) + 1,
        };
        selectedProducts.value = updated;
      } else {
        selectedProducts.value = [
          ...selectedProducts.value,
          {...product, 'quantity': 1},
        ];
      }
    }

    void removeProductFromCart(int productId) {
      selectedProducts.value = selectedProducts.value
          .where((p) => p['id'] != productId)
          .toList();
    }

    void updateProductQuantity(int productId, int newQuantity) {
      if (newQuantity <= 0) {
        removeProductFromCart(productId);
        return;
      }
      final index = selectedProducts.value.indexWhere(
        (p) => p['id'] == productId,
      );
      if (index >= 0) {
        final updated = [...selectedProducts.value];
        updated[index] = {...updated[index], 'quantity': newQuantity};
        selectedProducts.value = updated;
      }
    }

    Future<void> handleCheckout() async {
      showGlobalToast(
        message: 'Encaissement de ${_formatAmount(calculateTotal())}',
      );
      await Future<void>.delayed(const Duration(seconds: 1));
      if (context.mounted) {
        selectedProducts.value = [];
      }
    }

    final filteredCatalog = catalog.where((product) {
      if (selectedCategory.value == 'Tout') return true;
      return product['category'] == selectedCategory.value;
    }).toList();

    final cartCount = selectedProducts.value.fold<int>(
      0,
      (sum, p) => sum + (p['quantity'] as int),
    );

    final subtotal = calculateSubtotal();
    final tax = calculateTax(subtotal);
    final total = calculateTotal();

    return Scaffold(
      appBar: const MainAppBar(
        title: 'Caisse',
        subtitle: 'Session du 24 mai 2025',
      ),
      bottomNavigationBar: const MainBottomNav(currentTab: MainTab.checkout),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: AppSpacing.lg.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md.w,
                AppSpacing.md.h,
                AppSpacing.md.w,
                AppSpacing.sm.h,
              ),
              child: AppSearchField(
                hintText: 'Chercher un produit ou scanner...',
                fillColor: context.colors.surface,
                trailingIcon: HugeIcons.strokeRoundedQrCode01,
                trailingIconColor: context.colors.primary,
                onTrailingPressed: () {},
                trailingTooltip: 'Scanner',
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
              child: Row(
                children: [
                  for (var index = 0; index < categories.length; index++) ...[
                    if (index > 0) SizedBox(width: AppSpacing.sm.w),
                    FilterChip(
                      label: Text(categories[index]),
                      selected: selectedCategory.value == categories[index],
                      onSelected: (_) =>
                          selectedCategory.value = categories[index],
                      showCheckmark: false,
                      labelStyle: TextStyle(
                        color: selectedCategory.value == categories[index]
                            ? context.colors.onPrimary
                            : context.colors.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                      selectedColor: context.colors.primary,
                      backgroundColor: context.colors.surfaceContainerHighest,
                      side: BorderSide(
                        color: selectedCategory.value == categories[index]
                            ? context.colors.primary
                            : context.colors.outlineVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: AppSpacing.sm.h,
                  crossAxisSpacing: AppSpacing.sm.w,
                  childAspectRatio: 2 / 1.9,
                ),
                itemCount: filteredCatalog.length,
                itemBuilder: (context, index) {
                  final product = filteredCatalog[index];
                  final isSelected = selectedProducts.value.any(
                    (p) => p['id'] == product['id'],
                  );
                  return _ProductCard(
                    name: product['name'] as String,
                    price: product['price'] as int,
                    selected: isSelected,
                    onTap: () => addProductToCart(product),
                  );
                },
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
              child: _CartSection(
                itemCount: cartCount,
                products: selectedProducts.value,
                subtotal: subtotal,
                tax: tax,
                total: total,
                onDecrease: (id, qty) => updateProductQuantity(id, qty - 1),
                onIncrease: (id, qty) => updateProductQuantity(id, qty + 1),
                onRemove: removeProductFromCart,
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
              child: _PaymentMethodSection(
                selected: selectedPaymentMethod.value,
                onSelected: (method) => selectedPaymentMethod.value = method,
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
              child: AppButton(
                label: 'Encaisser · ${_formatAmount(total)}',
                isFullWidth: true,
                prefixIcon: const AppIcon(
                  icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                ),
                onPressed: selectedProducts.value.isEmpty
                    ? null
                    : handleCheckout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatAmount(double value) {
  final raw = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && (raw.length - i) % 3 == 0) {
      buffer.write(' ');
    }
    buffer.write(raw[i]);
  }
  return '${buffer.toString()} XAF';
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.name,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final int price;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: AppBorders.lg,
          border: Border.all(
            color: selected ? cs.primary : cs.outline,
            width: selected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(AppSpacing.xs.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 4,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: selected
                            ? cs.primaryContainer
                            : cs.surfaceContainerHighest,
                        borderRadius: AppBorders.sm,
                      ),
                      child: Center(
                        child: AppIcon(
                          icon: HugeIcons.strokeRoundedPackage01,
                          color: selected ? cs.primary : cs.onSurfaceVariant,
                          size: AppIconSize.sm,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  Expanded(
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: tt.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    _formatAmount(price.toDouble()),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tt.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Positioned(
                top: 6.r,
                right: 6.r,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: cs.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(3.r),
                    child: AppIcon(
                      icon: HugeIcons.strokeRoundedTick02,
                      color: cs.onPrimary,
                      size: AppIconSize.xs,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CartSection extends StatelessWidget {
  const _CartSection({
    required this.itemCount,
    required this.products,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.onDecrease,
    required this.onIncrease,
    required this.onRemove,
  });

  final int itemCount;
  final List<Map<String, dynamic>> products;
  final double subtotal;
  final double tax;
  final double total;
  final void Function(int id, int qty) onDecrease;
  final void Function(int id, int qty) onIncrease;
  final void Function(int id) onRemove;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: AppBorders.lg,
        border: Border.all(color: cs.outline),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.md.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Panier',
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm.w,
                    vertical: AppSpacing.xs.h,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '$itemCount articles',
                    style: tt.labelSmall?.copyWith(
                      color: cs.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (products.isEmpty)
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg.w),
              child: Text(
                'Aucun article sélectionné',
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            )
          else ...[
            const Divider(),
            for (var i = 0; i < products.length; i++) ...[
              _CartLineItem(
                name: products[i]['name'] as String,
                quantity: products[i]['quantity'] as int,
                lineTotal:
                    (products[i]['price'] as int) *
                    (products[i]['quantity'] as int),
                onDecrease: () => onDecrease(
                  products[i]['id'] as int,
                  products[i]['quantity'] as int,
                ),
                onIncrease: () => onIncrease(
                  products[i]['id'] as int,
                  products[i]['quantity'] as int,
                ),
                onRemove: () => onRemove(products[i]['id'] as int),
              ),
              if (i < products.length - 1)
                Divider(height: 1, color: cs.outlineVariant),
            ],
          ],
          Divider(height: 1, color: cs.outlineVariant),
          Padding(
            padding: EdgeInsets.all(AppSpacing.md.w),
            child: Column(
              children: [
                _SummaryRow(
                  label: 'Sous-total',
                  value: _formatAmount(subtotal),
                ),
                SizedBox(height: AppSpacing.sm.h),
                _SummaryRow(label: 'TVA (19,25%)', value: _formatAmount(tax)),
                SizedBox(height: AppSpacing.md.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.primary,
                      ),
                    ),
                    Text(
                      _formatAmount(total),
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartLineItem extends StatelessWidget {
  const _CartLineItem({
    required this.name,
    required this.quantity,
    required this.lineTotal,
    required this.onDecrease,
    required this.onIncrease,
    required this.onRemove,
  });

  final String name;
  final int quantity;
  final int lineTotal;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.sm.h,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs.w),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: AppBorders.sm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _QtyButton(
                  icon: HugeIcons.strokeRoundedMinusSign,
                  onTap: onDecrease,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm.w),
                  child: Text(
                    '$quantity',
                    style: tt.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                _QtyButton(
                  icon: HugeIcons.strokeRoundedPlusSign,
                  onTap: onIncrease,
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm.w),
          SizedBox(
            width: 72.w,
            child: Text(
              _formatAmount(lineTotal.toDouble()),
              textAlign: TextAlign.end,
              style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: AppIcon(
              icon: HugeIcons.strokeRoundedCancel01,
              size: AppIconSize.sm,
              color: cs.onSurfaceVariant,
            ),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});

  final List<List<dynamic>> icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppBorders.sm,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xs.w),
        child: AppIcon(icon: icon, size: AppIconSize.xs),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
        Text(value, style: tt.bodySmall),
      ],
    );
  }
}

class _PaymentMethodSection extends StatelessWidget {
  const _PaymentMethodSection({
    required this.selected,
    required this.onSelected,
  });

  final String selected;
  final ValueChanged<String> onSelected;

  static const _methods = [
    (id: 'cash', label: 'Espèces', icon: HugeIcons.strokeRoundedMoney01),
    (
      id: 'mobile',
      label: 'Mobile Money',
      icon: HugeIcons.strokeRoundedSmartPhone01,
    ),
    (id: 'card', label: 'Carte', icon: HugeIcons.strokeRoundedCreditCard),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mode de paiement',
          style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
        ),
        SizedBox(height: AppSpacing.sm.h),
        Row(
          children: _methods.map((method) {
            final isSelected = selected == method.id;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: method.id != 'card' ? AppSpacing.sm.w : 0,
                ),
                child: GestureDetector(
                  onTap: () => onSelected(method.id),
                  child: AnimatedContainer(
                    duration: AppDurations.fast,
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
                    decoration: BoxDecoration(
                      color: isSelected ? cs.primaryContainer : cs.surface,
                      borderRadius: AppBorders.lg,
                      border: Border.all(
                        color: isSelected ? cs.primary : cs.outline,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        AppIcon(
                          icon: method.icon,
                          size: AppIconSize.md,
                          color: isSelected ? cs.primary : cs.onSurfaceVariant,
                        ),
                        SizedBox(height: AppSpacing.xs.h),
                        Text(
                          method.label,
                          textAlign: TextAlign.center,
                          style: tt.labelSmall?.copyWith(
                            color: isSelected
                                ? cs.primary
                                : cs.onSurfaceVariant,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
