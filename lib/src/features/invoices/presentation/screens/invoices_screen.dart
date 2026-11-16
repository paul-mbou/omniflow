import 'package:omniflow/src/imports/core_imports.dart';
import 'package:omniflow/src/imports/packages_imports.dart';

class InvoicesScreen extends HookConsumerWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = useState<String>('all');
    final currentPage = useState(1);

    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final invoices = [
      {
        'id': 'FAC-0024',
        'company': 'Épicerie Moderne',
        'amount': 58500,
        'status': 'paid',
        'date': '24 mai 2025',
      },
      {
        'id': 'FAC-0023',
        'company': 'Supermarché Biyem',
        'amount': 124000,
        'status': 'pending',
        'date': '23 mai 2025',
      },
      {
        'id': 'FAC-0022',
        'company': 'Boutique du Coin',
        'amount': 36750,
        'status': 'paid',
        'date': '22 mai 2025',
      },
      {
        'id': 'FAC-0021',
        'company': 'MiniMart Bastos',
        'amount': 98200,
        'status': 'paid',
        'date': '21 mai 2025',
      },
      {
        'id': 'FAC-0020',
        'company': 'Dépôt Central',
        'amount': 215000,
        'status': 'pending',
        'date': '20 mai 2025',
      },
      {
        'id': 'FAC-0019',
        'company': 'Alimentation Plus',
        'amount': 47300,
        'status': 'cancelled',
        'date': '19 mai 2025',
      },
      {
        'id': 'FAC-0018',
        'company': 'Grossiste Mvog-Ada',
        'amount': 340000,
        'status': 'paid',
        'date': '18 mai 2025',
      },
      {
        'id': 'FAC-0017',
        'company': 'Shop Express',
        'amount': 22800,
        'status': 'cancelled',
        'date': '17 mai 2025',
      },
    ];

    final tabs = [
      {'label': 'Toutes', 'count': 24, 'key': 'all'},
      {'label': 'Payées', 'count': 18, 'key': 'paid'},
      {'label': 'En attente', 'count': 4, 'key': 'pending'},
      {'label': 'Annulées', 'count': 2, 'key': 'cancelled'},
    ];

    List<Map<String, dynamic>> getFilteredInvoices() {
      if (selectedTab.value == 'all') {
        return invoices;
      }
      return invoices
          .where((inv) => inv['status'] == selectedTab.value)
          .toList();
    }

    Color getStatusColor(String status) {
      switch (status) {
        case 'paid':
          return Colors.green;
        case 'pending':
          return Colors.orange;
        case 'cancelled':
          return Colors.red;
        default:
          return cs.outline;
      }
    }

    String getStatusLabel(String status) {
      switch (status) {
        case 'paid':
          return 'Payée';
        case 'pending':
          return 'En attente';
        case 'cancelled':
          return 'Annulée';
        default:
          return '';
      }
    }

    return Scaffold(
      appBar: const MainAppBar(
        title: 'Factures',
        subtitle: '24 factures ce mois',
      ),
      bottomNavigationBar: const MainBottomNav(currentTab: MainTab.reports),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search
            Padding(
              padding: EdgeInsets.all(AppSpacing.md.w),
              child: Row(
                children: [
                  const Expanded(
                    child: AppSearchField(
                      hintText: 'Rechercher une facture...',
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm.w),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const AppIcon(
                      icon: HugeIcons.strokeRoundedPlusSign,
                      size: AppIconSize.sm,
                    ),
                    label: const Text('Nouvelle'),
                  ),
                ],
              ),
            ),

            // Tabs
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: tabs
                      .map(
                        (tab) => Padding(
                          padding: EdgeInsets.only(right: AppSpacing.sm.w),
                          child: FilterChip(
                            label: Text('${tab['label']} ${tab['count']}'),
                            selected: selectedTab.value == tab['key'],
                            onSelected: (_) =>
                                selectedTab.value = tab['key'] as String,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

            // Summary cards
            Padding(
              padding: EdgeInsets.all(AppSpacing.md.w),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(AppSpacing.md.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: cs.outline),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '18',
                            style: tt.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            'Payées',
                            style: tt.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm.w),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(AppSpacing.md.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '4',
                            style: tt.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          Text(
                            'En attente',
                            style: tt.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm.w),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(AppSpacing.md.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '2',
                            style: tt.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            'Annulées',
                            style: tt.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Month header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md.w,
                vertical: AppSpacing.sm.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mai 2025',
                    style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Exporter',
                      style: tt.bodySmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Invoices list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: getFilteredInvoices().length,
              itemBuilder: (context, index) {
                final invoice = getFilteredInvoices()[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md.w,
                    vertical: AppSpacing.sm.h,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to invoice details
                    },
                    child: Container(
                      padding: EdgeInsets.all(AppSpacing.md.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: cs.outline),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: cs.primaryContainer,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: AppIcon(
                                icon: HugeIcons.strokeRoundedInvoice01,
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      invoice['id'],
                                      style: tt.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${invoice['amount']} XAF',
                                      style: tt.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppSpacing.xs.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      invoice['company'],
                                      style: tt.bodySmall?.copyWith(
                                        color: cs.onSurfaceVariant,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppSpacing.sm.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: getStatusColor(
                                          invoice['status'],
                                        ).withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(
                                          4.r,
                                        ),
                                      ),
                                      child: Text(
                                        getStatusLabel(invoice['status']),
                                        style: tt.labelSmall?.copyWith(
                                          color: getStatusColor(
                                            invoice['status'],
                                          ),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          AppIcon(
                            icon: HugeIcons.strokeRoundedArrowRight01,
                            color: cs.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: AppSpacing.md.h),

            // Pagination
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const AppIcon(
                      icon: HugeIcons.strokeRoundedArrowLeft01,
                    ),
                    onPressed: currentPage.value > 1
                        ? () => currentPage.value--
                        : null,
                  ),
                  SizedBox(width: AppSpacing.xs.w),
                  ...List.generate(3, (i) => i + 1).map(
                    (page) => Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs.w,
                      ),
                      child: FilterChip(
                        label: Text('$page'),
                        selected: currentPage.value == page,
                        onSelected: (_) => currentPage.value = page,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.xs.w),
                  IconButton(
                    icon: const AppIcon(
                      icon: HugeIcons.strokeRoundedArrowRight01,
                    ),
                    onPressed: currentPage.value < 3
                        ? () => currentPage.value++
                        : null,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
          ],
        ),
      ),
    );
  }
}
