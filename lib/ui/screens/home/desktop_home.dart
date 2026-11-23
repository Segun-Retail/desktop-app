import 'package:flutter/material.dart';

mixin _ResponsiveTextStyles {
  TextStyle _responsiveTextStyle(
    BuildContext context, {
    required double size,
    Color? color,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    final width = MediaQuery.sizeOf(context).width;
    final scale = width < 700
        ? 1.2
        : width < 1100
        ? 1.35
        : width < 1450
        ? 1.5
        : 1.7;
    return TextStyle(
      fontSize: size * scale,
      color: color,
      fontWeight: fontWeight,
    );
  }
}

class DesktopHome extends StatefulWidget {
  const DesktopHome({super.key});

  @override
  State<DesktopHome> createState() => _DesktopHomeState();
}

class _DesktopHomeState extends State<DesktopHome> {
  static const _ink = Color(0xFF171A19);
  static const _muted = Color(0xFF858C89);
  static const _green = Color(0xFF167D68);

  final _items = const [
    _MenuItem('Dashboard', Icons.space_dashboard_outlined),
    _MenuItem('Workspace', Icons.grid_view_rounded),
    _MenuItem('Bill & Invoices', Icons.receipt_long_outlined, [
      'Create Bill',
      'Process Payment',
      'Invoice History',
    ]),
    _MenuItem('Inventory', Icons.inventory_2_outlined, [
      'Inventory Centre',
      'Item List',
      'Inventory Site List',
      'Adjust Quantity/Value on Hand',
      'Transfer Inventory',
      'Receive Item',
    ]),
    _MenuItem('Customers', Icons.people_outline_rounded, [
      'Customer Details',
      'New Customer',
    ]),
    _MenuItem('Banking', Icons.account_balance_outlined, [
      'Payment',
      'Withdrawal',
      'Refund',
    ]),
    _MenuItem('Accounting', Icons.calculate_outlined),
    _MenuItem('Staff', Icons.badge_outlined, ['Add Staff', 'View All Users']),
  ];

  String _selected = 'Dashboard';
  String? _expandedMenu;
  bool _isEditingQuickActions = false;
  final List<_QuickAction> _quickActions = List.of(_defaultQuickActions);
  final List<_InventoryRow> _inventoryItems = [
    _InventoryRow('SKU-1001', 'Retail Item A', '24', '\$12.50'),
    _InventoryRow('SKU-1002', 'Retail Item B', '8', '\$18.00'),
    _InventoryRow('SKU-1003', 'Retail Item C', '0', '\$7.25'),
  ];
  final List<String> _inventorySites = ['Main Store', 'Warehouse'];

  double _responsiveFont(BuildContext context, double size) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 700) return size * 1.2;
    if (width < 1100) return size * 1.35;
    if (width < 1450) return size * 1.5;
    return size * 1.7;
  }

  @override
  Widget build(BuildContext context) {
    final sidebarWidth = MediaQuery.sizeOf(context).width < 1100
        ? 230.0
        : 270.0;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SizedBox(width: sidebarWidth, child: _buildSidebar(context)),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 1, bottom: 12),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: _responsiveFont(context, 18),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [for (final item in _items) _buildMenuButton(item)],
            ),
          ),
          InkWell(
            onTap: () => _confirmLogout(context),
            child: const Padding(
              padding: EdgeInsets.only(top: 10, left: 1),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout_rounded, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Log out',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(_MenuItem item, {VoidCallback? onTap}) {
    final isSelected = item.label == _selected;
    final isExpanded = _expandedMenu == item.label;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap:
              onTap ??
              () {
                setState(() {
                  if (item.children.isNotEmpty) {
                    _selected = item.children.first;
                    _expandedMenu = isExpanded ? null : item.label;
                  } else {
                    _selected = item.label;
                  }
                });
              },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 11),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _responsiveFont(context, 12),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (item.children.isNotEmpty)
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 15,
                  ),
              ],
            ),
          ),
        ),
        Container(height: 1, color: const Color(0xFF333333)),
        if (isExpanded)
          for (final child in item.children)
            InkWell(
              onTap: () => setState(() => _selected = child),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 2, 8),
                child: Text(
                  child,
                  style: TextStyle(
                    color: _selected == child
                        ? Colors.white
                        : const Color(0xFFBDBDBD),
                    fontSize: _responsiveFont(context, 10),
                  ),
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _QuickActionsBar(
          selected: _selected,
          actions: _quickActions,
          isEditing: _isEditingQuickActions,
          onEditToggle: () =>
              setState(() => _isEditingQuickActions = !_isEditingQuickActions),
          onReorder: (oldIndex, newIndex) => setState(() {
            if (newIndex < 0 || newIndex >= _quickActions.length) return;
            final action = _quickActions.removeAt(oldIndex);
            _quickActions.insert(newIndex, action);
          }),
          onAdd: _addQuickAction,
          onRemove: (action) {
            if (_quickActions.length > 1) {
              setState(() => _quickActions.remove(action));
            }
          },
          onAction: _handleQuickAction,
        ),
        Expanded(child: _buildSelectedPage()),
      ],
    );
  }

  void _handleQuickAction(String destination) {
    if (destination == 'Print') {
      _showMessage('Print action is ready for this screen.');
      return;
    }
    setState(() {
      _selected = destination;
      if (destination.startsWith('Inventory') ||
          destination == 'Item List' ||
          destination == 'Receive Item' ||
          destination == 'Transfer Inventory' ||
          destination.startsWith('Adjust Quantity')) {
        _expandedMenu = 'Inventory';
      }
    });
  }

  Future<void> _addQuickAction() async {
    final existing = _quickActions.map((action) => action.destination).toSet();
    final available = _allQuickActions
        .where((action) => !existing.contains(action.destination))
        .toList();
    if (available.isEmpty) {
      _showMessage('All available navigation actions are already on the bar.');
      return;
    }

    final action = await showDialog<_QuickAction>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Add navigation button'),
        children: [
          for (final option in available)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, option),
              child: Row(
                children: [
                  Icon(option.icon, size: 20),
                  const SizedBox(width: 12),
                  Text(option.label),
                ],
              ),
            ),
        ],
      ),
    );
    if (action != null && mounted) {
      setState(() => _quickActions.add(action));
    }
  }

  Widget _buildSelectedPage() {
    if (_selected == 'Create Bill') {
      return _buildCreateBillPage();
    }
    if (_selected == 'New Customer') {
      return _buildNewCustomerPage();
    }
    if (_selected == 'Refund') {
      return _buildRefundPage();
    }
    if (_selected == 'Staff' || _selected == 'Add Staff') {
      return _buildStaffPage();
    }
    if (_selected == 'View All Users') {
      return _buildAllUsersPage();
    }
    if (_selected == 'Inventory Centre') {
      return _buildInventoryCentrePage();
    }
    if (_inventoryPages.contains(_selected)) {
      return _buildInventoryOperationPage(_selected);
    }
    if (_selected == 'Process Payment' || _selected == 'Payment') {
      return _buildPaymentPage();
    }
    if (_selected.startsWith('Invoice History')) {
      return _buildInvoiceHistoryPage();
    }

    final isDashboard = _selected == 'Dashboard';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 34),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE9ECEA))),
          ),
          child: Row(
            children: [
              Text(
                _selected,
                style: TextStyle(
                  color: _ink,
                  fontSize: _responsiveFont(context, 17),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (MediaQuery.sizeOf(context).width >= 900)
                Container(
                  width: 260,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F7F6),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: const Color(0xFFE8EBE9)),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search anything...',
                      hintStyle: TextStyle(color: _muted, fontSize: 12),
                      prefixIcon: Icon(Icons.search, size: 17, color: _muted),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 10),
                    ),
                  ),
                ),
              const SizedBox(width: 18),
              IconButton(
                tooltip: 'Notifications',
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_rounded, size: 21),
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 17,
                backgroundColor: Color(0xFFE6F2EE),
                child: Text('A', style: TextStyle(color: _green, fontSize: 12)),
              ),
            ],
          ),
        ),
        Expanded(
          child: isDashboard ? _buildDashboard() : _buildSectionPlaceholder(),
        ),
      ],
    );
  }

  Widget _buildCreateBillPage() {
    return Column(
      children: [
        Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFBDBDBD))),
          ),
          child: Row(
            children: [
              const Text(
                'Notifications',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _showMessage('No new notifications'),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                icon: const Icon(Icons.notifications_none, size: 16),
              ),
            ],
          ),
        ),
        Expanded(
          child: _CreateBillForm(
            onBack: () => setState(() => _selected = 'Dashboard'),
            onPrint: () => _showMessage('Print bill'),
            onSend: () => _showMessage('Bill sent'),
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceHistoryPage() {
    return Column(
      children: [
        Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFBDBDBD))),
          ),
          child: Row(
            children: [
              const Text(
                'Notifications',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _showMessage('No new notifications'),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                icon: const Icon(Icons.notifications_none, size: 16),
              ),
            ],
          ),
        ),
        Expanded(
          child: _InvoiceHistoryView(
            onBack: () => setState(() => _selected = 'Dashboard'),
            onMessage: _showMessage,
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryCentrePage() {
    return Column(
      children: [
        Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFBDBDBD))),
          ),
          child: Row(
            children: [
              const Text(
                'Notifications',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _showMessage('No new notifications'),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                icon: const Icon(Icons.notifications_none, size: 16),
              ),
            ],
          ),
        ),
        Expanded(
          child: _InventoryCentreView(
            onBack: () => setState(() => _selected = 'Dashboard'),
            onDeposit: () => _showMessage('Deposit inventory'),
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryOperationPage(String title) {
    final descriptions = <String, String>{
      'Item List':
          'Browse your product catalogue and current stock at a glance.',
      'Inventory Site List':
          'View the locations where your inventory is stored.',
      'Adjust Quantity/Value on Hand':
          'Correct stock counts and values with a traceable adjustment.',
      'Transfer Inventory': 'Move selected items from one site to another.',
      'Receive Item': 'Record incoming stock and add it to an inventory site.',
    };

    return Column(
      children: [
        _buildNotificationStrip(),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 760;
              final padding = compact ? 14.0 : 26.0;
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(padding, 20, padding, 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: _ink,
                            fontSize: _responsiveFont(context, 22),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          descriptions[title] ??
                              'Manage inventory for your store.',
                          style: const TextStyle(color: _muted, fontSize: 13),
                        ),
                        const SizedBox(height: 20),
                        if (title == 'Item List')
                          _buildInventoryItemsList(compact),
                        if (title == 'Inventory Site List')
                          _buildInventorySitesList(compact),
                        if (title == 'Adjust Quantity/Value on Hand')
                          _buildInventoryAdjustment(compact),
                        if (title == 'Transfer Inventory')
                          _buildInventoryTransfer(compact),
                        if (title == 'Receive Item')
                          _buildInventoryReceiving(compact),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryItemsList(bool compact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _inventoryMetric(
              'Items in catalogue',
              '${_inventoryItems.length}',
              Icons.inventory_2_outlined,
            ),
            _inventoryMetric(
              'Low stock',
              '${_inventoryItems.where((item) => (int.tryParse(item.quantity) ?? 0) > 0 && (int.tryParse(item.quantity) ?? 0) <= 10).length}',
              Icons.warning_amber_rounded,
            ),
            _inventoryMetric(
              'Out of stock',
              '${_inventoryItems.where((item) => (int.tryParse(item.quantity) ?? 0) == 0).length}',
              Icons.remove_shopping_cart_outlined,
            ),
          ],
        ),
        const SizedBox(height: 18),
        _inventoryPanel(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search item name or SKU',
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF7F8F7),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE1E5E3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE1E5E3),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!compact) ...[
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 170,
                      child: DropdownButtonFormField<String>(
                        initialValue: _inventorySites.first,
                        isDense: true,
                        decoration: const InputDecoration(
                          labelText: 'Inventory site',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          for (final site in _inventorySites)
                            DropdownMenuItem(value: site, child: Text(site)),
                        ],
                        onChanged: (_) {},
                      ),
                    ),
                  ],
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: _showAddInventoryItemDialog,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add Item'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _inventoryTable(
                columns: const [
                  'SKU',
                  'Item name',
                  'On hand',
                  'Unit value',
                  'Stock status',
                ],
                rows: [
                  for (final item in _inventoryItems)
                    [
                      item.sku,
                      item.name,
                      item.quantity,
                      item.value,
                      (int.tryParse(item.quantity) ?? 0) == 0
                          ? 'Out of stock'
                          : (int.tryParse(item.quantity) ?? 0) <= 10
                          ? 'Low stock'
                          : 'In stock',
                    ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInventorySitesList(bool compact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _inventoryMetric(
              'Active sites',
              '${_inventorySites.length}',
              Icons.location_on_outlined,
            ),
            _inventoryMetric(
              'Items tracked',
              '${_inventoryItems.length}',
              Icons.inventory_2_outlined,
            ),
            _inventoryMetric(
              'Primary site',
              _inventorySites.first,
              Icons.storefront_outlined,
            ),
          ],
        ),
        const SizedBox(height: 18),
        _inventoryPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Inventory locations',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: _showAddInventorySiteDialog,
                    icon: const Icon(Icons.add_location_alt_outlined, size: 18),
                    label: const Text('Add Site'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _inventoryTable(
                columns: const [
                  'Site name',
                  'Site type',
                  'Items stocked',
                  'Status',
                ],
                rows: [
                  for (var index = 0; index < _inventorySites.length; index++)
                    [
                      _inventorySites[index],
                      index == 0 ? 'Primary location' : 'Stock location',
                      '${_inventoryItems.length}',
                      'Active',
                    ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryAdjustment(bool compact) {
    final controlWidth = compact ? double.infinity : 280.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _inventoryMetric(
              'Selected item',
              _inventoryItems.first.name,
              Icons.inventory_2_outlined,
            ),
            _inventoryMetric(
              'Quantity on hand',
              _inventoryItems.first.quantity,
              Icons.numbers_rounded,
            ),
            _inventoryMetric(
              'Current value',
              _inventoryItems.first.value,
              Icons.payments_outlined,
            ),
          ],
        ),
        const SizedBox(height: 18),
        _inventoryPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Adjustment details',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 14,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: controlWidth,
                    child: _inventoryDropdown(
                      'Item',
                      _inventoryItems.map((item) => item.name).toList(),
                    ),
                  ),
                  SizedBox(
                    width: controlWidth,
                    child: _inventoryDropdown(
                      'Inventory site',
                      _inventorySites,
                    ),
                  ),
                  SizedBox(
                    width: controlWidth,
                    child: _inventoryDropdown('Adjustment type', const [
                      'Quantity adjustment',
                      'Value adjustment',
                    ]),
                  ),
                  SizedBox(
                    width: controlWidth,
                    child: _inventoryTextField(
                      'New quantity on hand',
                      numeric: true,
                    ),
                  ),
                  SizedBox(
                    width: controlWidth,
                    child: _inventoryTextField('New unit value', numeric: true),
                  ),
                  SizedBox(
                    width: compact ? double.infinity : 574,
                    child: _inventoryTextField('Reason / note', maxLines: 2),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: () =>
                      _showMessage('Inventory adjustment recorded.'),
                  icon: const Icon(Icons.save_outlined, size: 18),
                  label: const Text('Save Adjustment'),
                  style: FilledButton.styleFrom(backgroundColor: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryTransfer(bool compact) {
    final siteWidth = compact ? double.infinity : 330.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _inventoryPanel(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 12,
            children: [
              SizedBox(
                width: siteWidth,
                child: _inventoryDropdown('From site', _inventorySites),
              ),
              Icon(Icons.arrow_forward_rounded, color: _green, size: 24),
              SizedBox(
                width: siteWidth,
                child: _inventoryDropdown('To site', _inventorySites),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _inventoryPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Items to transfer',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () =>
                        _showMessage('Choose an item from the inventory list.'),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add Item'),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _inventoryTable(
                columns: const [
                  'SKU',
                  'Item name',
                  'Available',
                  'Transfer quantity',
                  'Unit value',
                ],
                rows: [
                  for (final item in _inventoryItems.take(3))
                    [item.sku, item.name, item.quantity, '0', item.value],
                ],
              ),
              const SizedBox(height: 16),
              _inventoryTextField('Transfer note (optional)', maxLines: 2),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: () => _showMessage('Inventory transfer recorded.'),
                  icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                  label: const Text('Transfer Inventory'),
                  style: FilledButton.styleFrom(backgroundColor: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryReceiving(bool compact) {
    final fieldWidth = compact ? double.infinity : 250.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _inventoryPanel(
          child: Wrap(
            spacing: 14,
            runSpacing: 12,
            children: [
              SizedBox(
                width: fieldWidth,
                child: _inventoryTextField('Supplier / vendor'),
              ),
              SizedBox(
                width: fieldWidth,
                child: _inventoryTextField('Supplier reference'),
              ),
              SizedBox(
                width: fieldWidth,
                child: _inventoryDropdown('Receiving site', _inventorySites),
              ),
              SizedBox(
                width: fieldWidth,
                child: _inventoryTextField(
                  'Date received',
                  initialValue: '14/06/2026',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _inventoryPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Received items',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () =>
                        _showMessage('Choose an item to add to this receipt.'),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add Item'),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _inventoryTable(
                columns: const [
                  'SKU',
                  'Item name',
                  'Quantity received',
                  'Unit cost',
                  'Line total',
                ],
                rows: [
                  for (final item in _inventoryItems.take(3))
                    [item.sku, item.name, '0', item.value, item.value],
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () =>
                        setState(() => _selected = 'Inventory Centre'),
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: const Text('Back'),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () => _showMessage('Received stock recorded.'),
                    icon: const Icon(Icons.check_rounded, size: 18),
                    label: const Text('Save Receipt'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _inventoryMetric(String label, String value, IconData icon) {
    return Container(
      constraints: const BoxConstraints(minWidth: 190),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E6E4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4F0),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: _green, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: _muted, fontSize: 11)),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: _ink,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _inventoryPanel({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD9DEDC)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  Widget _inventoryTable({
    required List<String> columns,
    required List<List<String>> rows,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFBDBDBD)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: const WidgetStatePropertyAll(Colors.black),
          dataRowMinHeight: 44,
          dataRowMaxHeight: 52,
          headingTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
          columns: [
            for (final column in columns) DataColumn(label: Text(column)),
          ],
          rows: [
            for (final row in rows)
              DataRow(
                cells: [
                  for (var index = 0; index < row.length; index++)
                    DataCell(
                      index == row.length - 1 &&
                              (row[index] == 'Low stock' ||
                                  row[index] == 'Out of stock' ||
                                  row[index] == 'In stock' ||
                                  row[index] == 'Active')
                          ? _inventoryStatus(row[index])
                          : Text(row[index]),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _inventoryStatus(String status) {
    final color = status == 'Out of stock'
        ? const Color(0xFFFCE8E8)
        : status == 'Low stock'
        ? const Color(0xFFFFF3D6)
        : const Color(0xFFE5F3EC);
    final textColor = status == 'Out of stock'
        ? const Color(0xFFB42318)
        : status == 'Low stock'
        ? const Color(0xFF8A5A00)
        : _green;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _inventoryDropdown(String label, List<String> values) {
    return DropdownButtonFormField<String>(
      initialValue: values.first,
      isDense: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: [
        for (final value in values)
          DropdownMenuItem(value: value, child: Text(value)),
      ],
      onChanged: (_) {},
    );
  }

  Widget _inventoryTextField(
    String label, {
    bool numeric = false,
    int maxLines = 1,
    String? initialValue,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      keyboardType: numeric
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildInventoryForm({
    required List<String> fields,
    required String buttonLabel,
    required String successMessage,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var index = 0; index < fields.length; index++) ...[
              Text(
                fields[index],
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 7),
              if (index == 0 && fields[index] == 'Item')
                DropdownButtonFormField<String>(
                  initialValue: _inventoryItems.first.name,
                  items: [
                    for (final item in _inventoryItems)
                      DropdownMenuItem(
                        value: item.name,
                        child: Text(item.name),
                      ),
                  ],
                  onChanged: (_) {},
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                )
              else if (fields[index].toLowerCase().contains('site') ||
                  fields[index].toLowerCase().contains('from site') ||
                  fields[index].toLowerCase().contains('to site'))
                DropdownButtonFormField<String>(
                  initialValue: _inventorySites.first,
                  items: [
                    for (final site in _inventorySites)
                      DropdownMenuItem(value: site, child: Text(site)),
                  ],
                  onChanged: (_) {},
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                )
              else
                TextField(
                  keyboardType:
                      fields[index].toLowerCase().contains('quantity') ||
                          fields[index].toLowerCase().contains('value') ||
                          fields[index].toLowerCase().contains('cost')
                      ? const TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Enter ${fields[index].toLowerCase()}',
                    border: const OutlineInputBorder(),
                  ),
                ),
              const SizedBox(height: 14),
            ],
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: () => _showMessage(successMessage),
                icon: const Icon(Icons.check_rounded, size: 18),
                label: Text(buttonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentPage() {
    return Column(
      children: [
        _buildNotificationStrip(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selected,
                  style: TextStyle(
                    color: _ink,
                    fontSize: _responsiveFont(context, 22),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text('Record a customer payment against an invoice.'),
                const SizedBox(height: 20),
                _buildInventoryForm(
                  fields: const [
                    'Invoice number',
                    'Customer',
                    'Amount',
                    'Payment method',
                  ],
                  buttonLabel: 'Record Payment',
                  successMessage: 'Payment recorded.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationStrip() {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFBDBDBD))),
      ),
      child: Row(
        children: [
          const Text(
            'Notifications',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => _showMessage('No new notifications'),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            icon: const Icon(Icons.notifications_none, size: 16),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddInventoryItemDialog() async {
    final skuController = TextEditingController();
    final nameController = TextEditingController();
    final quantityController = TextEditingController(text: '0');
    final valueController = TextEditingController(text: '0.00');
    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add inventory item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: skuController,
              decoration: const InputDecoration(labelText: 'SKU'),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Item name'),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity on hand'),
            ),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(labelText: 'Unit value'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save Item'),
          ),
        ],
      ),
    );
    if (shouldSave == true && mounted) {
      setState(
        () => _inventoryItems.add(
          _InventoryRow(
            skuController.text,
            nameController.text,
            quantityController.text,
            '\$${valueController.text}',
          ),
        ),
      );
      _showMessage('Inventory item added.');
    }
    skuController.dispose();
    nameController.dispose();
    quantityController.dispose();
    valueController.dispose();
  }

  Future<void> _showAddInventorySiteDialog() async {
    final controller = TextEditingController();
    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add inventory site'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Site name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save Site'),
          ),
        ],
      ),
    );
    if (shouldSave == true && controller.text.trim().isNotEmpty && mounted) {
      setState(() => _inventorySites.add(controller.text.trim()));
      _showMessage('Inventory site added.');
    }
    controller.dispose();
  }

  Widget _buildRefundPage() {
    return Column(
      children: [
        Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFBDBDBD))),
          ),
          child: Row(
            children: [
              const Text(
                'Notifications',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _showMessage('No new notifications'),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                icon: const Icon(Icons.notifications_none, size: 16),
              ),
            ],
          ),
        ),
        Expanded(
          child: _RefundForm(
            onBack: () => setState(() => _selected = 'Dashboard'),
            onMessage: _showMessage,
          ),
        ),
      ],
    );
  }

  Widget _buildNewCustomerPage() {
    return Column(
      children: [
        Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFBDBDBD))),
          ),
          child: Row(
            children: [
              const Text(
                'Notifications',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _showMessage('No new notifications'),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                icon: const Icon(Icons.notifications_none, size: 16),
              ),
            ],
          ),
        ),
        Expanded(
          child: _NewCustomerForm(
            onBack: () => setState(() => _selected = 'Dashboard'),
            onMessage: _showMessage,
          ),
        ),
      ],
    );
  }

  Widget _buildStaffPage() {
    return Column(
      children: [
        Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFBDBDBD))),
          ),
          child: Row(
            children: [
              const Text(
                'Notifications',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _showMessage('No new notifications'),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                icon: const Icon(Icons.notifications_none, size: 16),
              ),
            ],
          ),
        ),
        Expanded(
          child: _StaffForm(
            onBack: () => setState(() => _selected = 'Dashboard'),
            onMessage: _showMessage,
          ),
        ),
      ],
    );
  }

  Widget _buildAllUsersPage() {
    return Column(
      children: [
        Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFBDBDBD))),
          ),
          child: Row(
            children: [
              const Text(
                'Notifications',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _showMessage('No new notifications'),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                icon: const Icon(Icons.notifications_none, size: 16),
              ),
            ],
          ),
        ),
        Expanded(
          child: _AllUsersView(
            onBack: () => setState(() => _selected = 'Staff'),
            onAddStaff: () => setState(() => _selected = 'Add Staff'),
          ),
        ),
      ],
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good morning, Administrator 👋',
            style: TextStyle(
              color: _ink,
              fontSize: _responsiveFont(context, 25),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Here’s what’s happening with your store today.',
            style: TextStyle(color: _muted, fontSize: 13),
          ),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4F0),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFDCECE5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your store at a glance',
                        style: TextStyle(
                          color: _ink,
                          fontSize: _responsiveFont(context, 17),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'Choose a section from the menu to manage your business.',
                        style: TextStyle(
                          color: const Color(0xFF63736D),
                          fontSize: _responsiveFont(context, 12),
                        ),
                      ),
                      const SizedBox(height: 18),
                      FilledButton.icon(
                        onPressed: () =>
                            setState(() => _selected = 'Inventory'),
                        icon: const Icon(Icons.inventory_2_outlined, size: 16),
                        label: Text('View inventory'),
                        style: FilledButton.styleFrom(
                          backgroundColor: _green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 13,
                          ),
                          textStyle: TextStyle(
                            fontSize: _responsiveFont(context, 12),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  width: 104,
                  height: 104,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    size: 52,
                    color: _green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Quick access',
            style: TextStyle(
              color: _ink,
              fontSize: _responsiveFont(context, 15),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              _QuickAccessCard(
                icon: Icons.receipt_long_outlined,
                title: 'Bill & Invoices',
                subtitle: 'Create and review invoices',
                onTap: () => setState(() => _selected = 'Bill & Invoices'),
              ),
              _QuickAccessCard(
                icon: Icons.people_outline_rounded,
                title: 'Customers',
                subtitle: 'View your customer list',
                onTap: () => setState(() => _selected = 'Customers'),
              ),
              _QuickAccessCard(
                icon: Icons.bar_chart_rounded,
                title: 'Reporting',
                subtitle: 'Check store performance',
                onTap: () => setState(() => _selected = 'Reporting'),
              ),
            ],
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 760
                  ? 3
                  : constraints.maxWidth >= 480
                  ? 2
                  : 1;
              final cardWidth =
                  (constraints.maxWidth - 14 * (columns - 1)) / columns;

              return Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: const _StatCard(
                      label: 'Today’s sales',
                      value: '\$0.00',
                      icon: Icons.trending_up,
                      tint: Color(0xFFE6F3ED),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: const _StatCard(
                      label: 'Open invoices',
                      value: '0',
                      icon: Icons.description_outlined,
                      tint: Color(0xFFEEF0FA),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: const _StatCard(
                      label: 'Products',
                      value: '0',
                      icon: Icons.inventory_2_outlined,
                      tint: Color(0xFFFFF2E6),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionPlaceholder() {
    final item = _items.firstWhere(
      (entry) => entry.label == _selected,
      orElse: () => _MenuItem(_selected, Icons.description_outlined),
    );
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4F0),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(item.icon, color: _green, size: 30),
          ),
          const SizedBox(height: 18),
          Text(
            _selected,
            style: const TextStyle(
              color: _ink,
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'This section is ready for us to build next.',
            style: TextStyle(color: _muted, fontSize: 13),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => setState(() => _selected = 'Dashboard'),
            icon: const Icon(Icons.arrow_back, size: 16),
            label: const Text('Back to dashboard'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.logout_rounded),
        title: const Text('Log out?'),
        content: const Text('You can sign back in whenever you’re ready.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (shouldLogout == true && context.mounted) Navigator.pop(context);
  }
}

class _NewCustomerForm extends StatefulWidget {
  final VoidCallback onBack;
  final ValueChanged<String> onMessage;

  const _NewCustomerForm({required this.onBack, required this.onMessage});

  @override
  State<_NewCustomerForm> createState() => _NewCustomerFormState();
}

class _NewCustomerFormState extends State<_NewCustomerForm>
    with _ResponsiveTextStyles {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 900;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        compact ? 16 : 28,
        18,
        compact ? 16 : 28,
        22,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: compact ? 1 : 2,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFDBDBDB)),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Create New Customer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _newCustomerField("Customer's Name", _nameController),
                      const SizedBox(height: 12),
                      _newCustomerField(
                        'Phone Number',
                        _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),
                      _newCustomerField(
                        'Location (Optional)',
                        _locationController,
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: widget.onBack,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                              side: const BorderSide(color: Color(0xFFBDBDBD)),
                              minimumSize: const Size(74, 34),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            child: const Text(
                              'Back',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                          const Spacer(),
                          FilledButton(
                            onPressed: _createCustomer,
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(94, 34),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                            child: const Text(
                              'Create',
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (!compact) ...[
                const SizedBox(width: 18),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFDBDBDB)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customer Details',
                          style: _responsiveTextStyle(
                            context,
                            size: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _detailRow('Border', '16'),
                        _detailRow('Padding', '16'),
                        _detailRow('Pending', '8'),
                        _detailRow('Refund', '1'),
                        const SizedBox(height: 12),
                        Text(
                          'Customer activity',
                          style: _responsiveTextStyle(
                            context,
                            size: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'New customer profiles are added here and ready for checkout, invoice, and customer history tracking.',
                          style: _responsiveTextStyle(
                            context,
                            size: 11,
                            color: const Color(0xFF5E5E5E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _newCustomerField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _responsiveTextStyle(context, size: 10)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: _billInputDecoration(),
            style: _responsiveTextStyle(context, size: 11),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: _responsiveTextStyle(
                context,
                size: 10,
                color: const Color(0xFF5F5F5F),
              ),
            ),
          ),
          Text(
            value,
            style: _responsiveTextStyle(
              context,
              size: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _createCustomer() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final location = _locationController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      widget.onMessage('Customer name and phone number are required.');
      return;
    }

    widget.onMessage(
      'Customer created for $name${location.isNotEmpty ? ' from $location' : ''}',
    );
    _nameController.clear();
    _phoneController.clear();
    _locationController.clear();
  }
}

class _StaffForm extends StatefulWidget {
  final VoidCallback onBack;
  final ValueChanged<String> onMessage;

  const _StaffForm({required this.onBack, required this.onMessage});

  @override
  State<_StaffForm> createState() => _StaffFormState();
}

class _StaffFormState extends State<_StaffForm> with _ResponsiveTextStyles {
  static const _roles = [
    'Select a role',
    'Sales Manager',
    'Cashier',
    'Inventory Manager',
    'Administrator',
  ];

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedRole = _roles.first;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;
        final pagePadding = compact ? 16.0 : 28.0;
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(pagePadding, 22, pagePadding, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Staff',
                    style: _responsiveTextStyle(
                      context,
                      size: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Add a staff member and assign their access role.',
                    style: _responsiveTextStyle(
                      context,
                      size: 11,
                      color: const Color(0xFF777777),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFD0D0D0)),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x10000000),
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Staff details',
                          style: _responsiveTextStyle(
                            context,
                            size: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 16,
                          runSpacing: 12,
                          children: [
                            _staffField(
                              'First name',
                              _firstNameController,
                              width: compact ? 290 : 390,
                            ),
                            _staffField(
                              'Last name',
                              _lastNameController,
                              width: compact ? 290 : 390,
                            ),
                            _staffField(
                              'Email',
                              _emailController,
                              width: compact ? 290 : 390,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            _staffField(
                              'Phone',
                              _phoneController,
                              width: compact ? 290 : 390,
                              keyboardType: TextInputType.phone,
                            ),
                            _staffField(
                              'Address',
                              _addressController,
                              width: compact ? 290 : 796,
                              maxLines: 2,
                            ),
                            SizedBox(
                              width: compact ? 290 : 390,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Role',
                                    style: _responsiveTextStyle(
                                      context,
                                      size: 10,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  DropdownButtonFormField<String>(
                                    initialValue: _selectedRole,
                                    isDense: true,
                                    decoration: _billInputDecoration(),
                                    items: _roles
                                        .map(
                                          (role) => DropdownMenuItem(
                                            value: role,
                                            child: Text(
                                              role,
                                              style: const TextStyle(
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (role) {
                                      if (role != null) {
                                        setState(() => _selectedRole = role);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: widget.onBack,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Color(0xFFBDBDBD)),
                          minimumSize: const Size(76, 36),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: _save,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(84, 36),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: _clear,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Color(0xFFBDBDBD)),
                          minimumSize: const Size(84, 36),
                        ),
                        child: const Text(
                          'Clear',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _staffField(
    String label,
    TextEditingController controller, {
    required double width,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _responsiveTextStyle(context, size: 10)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: _billInputDecoration(),
            style: _responsiveTextStyle(context, size: 11),
          ),
        ],
      ),
    );
  }

  void _save() {
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _selectedRole == _roles.first) {
      widget.onMessage('Enter first name, last name, email, and role to save.');
      return;
    }
    widget.onMessage('Staff details saved');
  }

  void _clear() {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _addressController.clear();
    setState(() => _selectedRole = _roles.first);
  }
}

class _AllUsersView extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onAddStaff;

  const _AllUsersView({required this.onBack, required this.onAddStaff});

  static const _users = [
    _StaffUser(
      'Alex Morgan',
      'alex.morgan@example.com',
      '+1 555 010 1001',
      'Sales Manager',
    ),
    _StaffUser(
      'Jordan Lee',
      'jordan.lee@example.com',
      '+1 555 010 1002',
      'Cashier',
    ),
    _StaffUser(
      'Taylor Brooks',
      'taylor.brooks@example.com',
      '+1 555 010 1003',
      'Inventory Manager',
    ),
    _StaffUser(
      'Casey Rivera',
      'casey.rivera@example.com',
      '+1 555 010 1004',
      'Cashier',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 760;
    return SingleChildScrollView(
      padding: EdgeInsets.all(compact ? 16 : 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1050),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'View All Users',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Staff accounts and assigned roles',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF777777),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: onAddStaff,
                    icon: const Icon(Icons.person_add_alt_1, size: 15),
                    label: const Text(
                      'Add Staff',
                      style: TextStyle(fontSize: 10),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD0D0D0)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    const _UsersTableHeader(),
                    for (var index = 0; index < _users.length; index++)
                      _UsersTableRow(user: _users[index], shaded: index.isOdd),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton(
                  onPressed: onBack,
                  child: const Text('Back', style: TextStyle(fontSize: 10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StaffUser {
  final String name;
  final String email;
  final String phone;
  final String role;

  const _StaffUser(this.name, this.email, this.phone, this.role);
}

class _UsersTableHeader extends StatelessWidget {
  const _UsersTableHeader();

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.w600,
    );
    return Container(
      height: 36,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text('Name', style: headerStyle)),
          Expanded(flex: 3, child: Text('Email', style: headerStyle)),
          Expanded(flex: 2, child: Text('Phone', style: headerStyle)),
          Expanded(flex: 2, child: Text('Role', style: headerStyle)),
        ],
      ),
    );
  }
}

class _UsersTableRow extends StatelessWidget {
  final _StaffUser user;
  final bool shaded;

  const _UsersTableRow({required this.user, required this.shaded});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 10);
    return Container(
      constraints: const BoxConstraints(minHeight: 40),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: shaded ? const Color(0xFFF1F1F1) : Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(user.name, style: textStyle)),
          Expanded(
            flex: 3,
            child: Text(
              user.email,
              style: textStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(flex: 2, child: Text(user.phone, style: textStyle)),
          Expanded(flex: 2, child: Text(user.role, style: textStyle)),
        ],
      ),
    );
  }
}

class _RefundForm extends StatefulWidget {
  final VoidCallback onBack;
  final ValueChanged<String> onMessage;

  const _RefundForm({required this.onBack, required this.onMessage});

  @override
  State<_RefundForm> createState() => _RefundFormState();
}

class _RefundFormState extends State<_RefundForm> {
  static const _customers = ['Mr. Mbab', 'Lorem 1', 'Ipsum 1', 'Lorem 2'];

  final _creditController = TextEditingController();
  final _dateController = TextEditingController(text: '14/06/2026');
  final _amountControllers = List.generate(5, (_) => TextEditingController());
  final _quantities = List<double>.filled(5, 0);
  final _rates = List<double>.filled(5, 0);
  String? _customer;

  double get _total => List.generate(
    _amountControllers.length,
    (index) => _quantities[index] * _rates[index],
  ).fold(0, (total, amount) => total + amount);

  @override
  void dispose() {
    _creditController.dispose();
    _dateController.dispose();
    for (final controller in _amountControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;
        final padding = compact ? 14.0 : 24.0;
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(padding, 18, padding, 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Refund',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  _buildRefundDetails(),
                  const SizedBox(height: 10),
                  _buildRefundTable(),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _total.toStringAsGrouped(),
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: widget.onBack,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Color(0xFFBDBDBD)),
                          minimumSize: const Size(70, 32),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      const Spacer(),
                      _refundAction(
                        'Save',
                        () => widget.onMessage('Refund saved'),
                      ),
                      const SizedBox(width: 8),
                      _refundAction('Save & New', _clearForm),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: widget.onBack,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Color(0xFFBDBDBD)),
                          minimumSize: const Size(70, 32),
                        ),
                        child: const Text(
                          'Close',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRefundDetails() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD0D0D0)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 8,
        alignment: WrapAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 310,
            child: Column(
              children: [
                _labelledControl(
                  'Customer',
                  DropdownButtonFormField<String>(
                    initialValue: _customer,
                    isDense: true,
                    decoration: _billInputDecoration(),
                    items: _customers
                        .map(
                          (name) => DropdownMenuItem(
                            value: name,
                            child: Text(
                              name,
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _customer = value),
                  ),
                ),
                const SizedBox(height: 6),
                _labelledControl(
                  'Credit No.',
                  TextField(
                    controller: _creditController,
                    decoration: _billInputDecoration(),
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 250,
            child: _labelledControl(
              'Date',
              TextField(
                controller: _dateController,
                readOnly: true,
                onTap: _chooseDate,
                decoration: _billInputDecoration().copyWith(
                  suffixIcon: const Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                  ),
                ),
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _labelledControl(String label, Widget control) {
    return Row(
      children: [
        SizedBox(
          width: 68,
          child: Text(label, style: const TextStyle(fontSize: 9)),
        ),
        Expanded(child: SizedBox(height: 28, child: control)),
      ],
    );
  }

  Widget _buildRefundTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFBDBDBD)),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              _RefundHeaderCell('Item', flex: 2),
              _RefundHeaderCell('Description', flex: 2),
              _RefundHeaderCell('Quantity'),
              _RefundHeaderCell('Rate'),
              _RefundHeaderCell('Cost'),
            ],
          ),
          for (var index = 0; index < _amountControllers.length; index++)
            _RefundEntryRow(
              key: ValueKey(index),
              descriptionController: _amountControllers[index],
              onValuesChanged: (quantity, rate) => setState(() {
                _quantities[index] = quantity;
                _rates[index] = rate;
              }),
            ),
        ],
      ),
    );
  }

  Widget _refundAction(String label, VoidCallback onPressed) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        minimumSize: const Size(70, 32),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        textStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
      ),
      child: Text(label),
    );
  }

  Future<void> _chooseDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime(2026, 6, 14),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (selected != null) {
      _dateController.text =
          '${selected.day}/${selected.month}/${selected.year}';
    }
  }

  void _clearForm() {
    setState(() {
      _customer = null;
      _creditController.clear();
      _dateController.text = '14/06/2026';
      for (final controller in _amountControllers) {
        controller.clear();
      }
      for (var index = 0; index < _quantities.length; index++) {
        _quantities[index] = 0;
        _rates[index] = 0;
      }
    });
    widget.onMessage('Ready for a new refund');
  }
}

class _RefundHeaderCell extends StatelessWidget {
  final String label;
  final int flex;

  const _RefundHeaderCell(this.label, {this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 24,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        alignment: Alignment.centerLeft,
        color: Colors.black,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _RefundEntryRow extends StatefulWidget {
  final TextEditingController descriptionController;
  final void Function(double quantity, double rate) onValuesChanged;

  const _RefundEntryRow({
    super.key,
    required this.descriptionController,
    required this.onValuesChanged,
  });

  @override
  State<_RefundEntryRow> createState() => _RefundEntryRowState();
}

class _RefundEntryRowState extends State<_RefundEntryRow> {
  final _itemController = TextEditingController();
  final _quantityController = TextEditingController();
  final _rateController = TextEditingController();

  void _notifyChanged() {
    setState(() {});
    widget.onValuesChanged(
      double.tryParse(_quantityController.text) ?? 0,
      double.tryParse(_rateController.text) ?? 0,
    );
  }

  @override
  void dispose() {
    _itemController.dispose();
    _quantityController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFDDDDDD))),
      ),
      child: Row(
        children: [
          _cell(flex: 2, controller: _itemController),
          _cell(flex: 2, controller: widget.descriptionController),
          _cell(
            controller: _quantityController,
            onChanged: (_) => _notifyChanged(),
          ),
          _cell(
            controller: _rateController,
            onChanged: (_) => _notifyChanged(),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: Color(0xFFBBBBBB))),
                color: Colors.white,
              ),
              child: Text(
                ((double.tryParse(_quantityController.text) ?? 0) *
                        (double.tryParse(_rateController.text) ?? 0))
                    .toStringAsGrouped(),
                style: const TextStyle(fontSize: 9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell({
    int flex = 1,
    required TextEditingController controller,
    ValueChanged<String>? onChanged,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(left: BorderSide(color: Color(0xFFBBBBBB))),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: onChanged == null
              ? TextInputType.text
              : const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 7),
          ),
          style: const TextStyle(fontSize: 9),
        ),
      ),
    );
  }
}

class _InventoryCentreView extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onDeposit;

  const _InventoryCentreView({required this.onBack, required this.onDeposit});

  @override
  State<_InventoryCentreView> createState() => _InventoryCentreViewState();
}

class _InventoryCentreViewState extends State<_InventoryCentreView>
    with _ResponsiveTextStyles {
  static const _items = [
    _InventoryProduct('Lorem Ipsum', 30000, 30000),
    _InventoryProduct('Premium White A4', 84, 1250),
    _InventoryProduct('Blue Pen', 145, 250),
    _InventoryProduct('Exercise Book', 62, 900),
    _InventoryProduct('Stapler', 18, 3200),
  ];
  static const _locations = ['Main Store', 'Warehouse', 'Branch 2'];

  String _location = _locations.first;
  _InventoryProduct _selected = _items.first;
  String _transactionFilter = 'All';
  DateTime _transactionDate = DateTime(2026, 6, 14);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;
        final horizontalPadding = compact ? 14.0 : 24.0;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            14,
            horizontalPadding,
            18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Inventory Centre',
                style: _responsiveTextStyle(
                  context,
                  size: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Location',
                    style: _responsiveTextStyle(context, size: 10),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 180,
                    height: 30,
                    child: DropdownButtonFormField<String>(
                      initialValue: _location,
                      isDense: true,
                      decoration: _billInputDecoration(),
                      items: _locations
                          .map(
                            (location) => DropdownMenuItem(
                              value: location,
                              child: Text(
                                location,
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _location = value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (compact)
                Column(
                  children: [
                    SizedBox(height: 230, child: _buildProductList()),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 320,
                      child: _buildProductAndTransactions(),
                    ),
                  ],
                )
              else
                SizedBox(
                  height: 430,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(width: 280, child: _buildProductList()),
                      const SizedBox(width: 12),
                      Expanded(child: _buildProductAndTransactions()),
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: widget.onBack,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Color(0xFFBDBDBD)),
                      minimumSize: const Size(76, 34),
                    ),
                    child: Text(
                      'Back',
                      style: _responsiveTextStyle(context, size: 10),
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: widget.onDeposit,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(80, 34),
                    ),
                    child: Text(
                      'Deposit',
                      style: _responsiveTextStyle(context, size: 10),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductList() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFBDBDBD)),
      ),
      child: Column(
        children: [
          Container(
            height: 26,
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: const Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Item Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Qty',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Price',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ..._items.map((product) {
            final selected = product == _selected;
            return Material(
              color: selected ? const Color(0xFFE3E3E3) : Colors.white,
              child: InkWell(
                onTap: () => setState(() => _selected = product),
                child: Container(
                  height: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE3E3E3)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          product.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 9),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${product.quantity}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 9),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          product.price.toStringAsGrouped(),
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const Expanded(
            child: DecoratedBox(decoration: BoxDecoration(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildProductAndTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFBDBDBD)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selected.name,
                style: _responsiveTextStyle(
                  context,
                  size: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Quantity In Stock',
                style: _responsiveTextStyle(context, size: 10),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${_selected.quantity}',
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              Text('Price', style: _responsiveTextStyle(context, size: 10)),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  _selected.price.toStringAsGrouped(),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Transaction Details',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
            DropdownButton<String>(
              value: _transactionFilter,
              isDense: true,
              underline: const SizedBox.shrink(),
              style: const TextStyle(color: Colors.black, fontSize: 9),
              items: const ['All', 'Sales', 'Restock', 'Adjustment']
                  .map(
                    (value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _transactionFilter = value);
              },
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: _chooseTransactionDate,
              icon: const Icon(Icons.calendar_today_outlined, size: 11),
              label: Text(
                '${_transactionDate.day}/${_transactionDate.month}/${_transactionDate.year}',
                style: const TextStyle(fontSize: 9),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
            ),
          ],
        ),
        Expanded(child: _buildTransactionsTable()),
      ],
    );
  }

  Widget _buildTransactionsTable() {
    const headerStyle = TextStyle(
      color: Colors.white,
      fontSize: 8,
      fontWeight: FontWeight.w600,
    );
    const columns = [
      Expanded(flex: 2, child: Text('Type', style: headerStyle)),
      Expanded(flex: 2, child: Text('Date', style: headerStyle)),
      Expanded(flex: 2, child: Text('Quantity', style: headerStyle)),
      Expanded(flex: 2, child: Text('Amount', style: headerStyle)),
      Expanded(flex: 2, child: Text('Balance', style: headerStyle)),
      Expanded(flex: 2, child: Text('Customer', style: headerStyle)),
      Expanded(flex: 2, child: Text('Track ID', style: headerStyle)),
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFBDBDBD)),
      ),
      child: Column(
        children: [
          Container(
            height: 24,
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: const Row(children: columns),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 12,
              itemBuilder: (context, index) => Container(
                height: 20,
                color: index.isEven ? Colors.white : const Color(0xFFECECEC),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text('', style: TextStyle(fontSize: 8)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('', style: TextStyle(fontSize: 8)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('', style: TextStyle(fontSize: 8)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('', style: TextStyle(fontSize: 8)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('', style: TextStyle(fontSize: 8)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('', style: TextStyle(fontSize: 8)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('', style: TextStyle(fontSize: 8)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _chooseTransactionDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _transactionDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (date != null) setState(() => _transactionDate = date);
  }
}

class _InventoryProduct {
  final String name;
  final int quantity;
  final int price;

  const _InventoryProduct(this.name, this.quantity, this.price);
}

class _InvoiceHistoryView extends StatefulWidget {
  final VoidCallback onBack;
  final ValueChanged<String> onMessage;

  const _InvoiceHistoryView({required this.onBack, required this.onMessage});

  @override
  State<_InvoiceHistoryView> createState() => _InvoiceHistoryViewState();
}

class _InvoiceHistoryViewState extends State<_InvoiceHistoryView>
    with _ResponsiveTextStyles {
  static const _statuses = ['Fulfilled', 'Voided', 'On hold'];
  static const _statusColors = {
    'Fulfilled': Color(0xFF00D653),
    'Voided': Color(0xFFF51D35),
    'On hold': Color(0xFFFFE900),
  };

  final List<_InvoiceRecord> _invoices = List.generate(
    8,
    (index) => _InvoiceRecord(
      number: 'INV-${(index + 1).toString().padLeft(4, '0')}',
      total: 10000,
      date: '6th Jun 2026',
      time: '12 : 56 pm',
      status: index == 0
          ? 'On hold'
          : index == 1
          ? 'Voided'
          : 'Fulfilled',
    ),
  );

  String _filter = 'All';
  String? _dateFilter;
  int? _expandedIndex;

  List<_InvoiceRecord> get _visibleInvoices => _invoices
      .where((invoice) => _filter == 'All' || invoice.status == _filter)
      .toList();

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.sizeOf(context).width < 900
        ? 16.0
        : 28.0;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        22,
        horizontalPadding,
        22,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Invoice History',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  for (final status in _statuses) ...[
                    _filterButton(status),
                    const SizedBox(width: 8),
                  ],
                  _filterButton('Date', icon: Icons.calendar_today_outlined),
                ],
              ),
              if (_dateFilter != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Date: $_dateFilter',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              _buildInvoiceTable(),
              const SizedBox(height: 18),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: widget.onBack,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Color(0xFFBDBDBD)),
                      minimumSize: const Size(76, 36),
                    ),
                    child: Text(
                      'Back',
                      style: _responsiveTextStyle(context, size: 11),
                    ),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () => widget.onMessage('History exported'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(100, 36),
                    ),
                    child: Text(
                      'Export',
                      style: _responsiveTextStyle(context, size: 11),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterButton(String label, {IconData? icon}) {
    final selected = _filter == label;
    return OutlinedButton.icon(
      onPressed: () {
        if (label == 'Date') {
          _chooseDate();
        } else {
          setState(() {
            _filter = selected ? 'All' : label;
            _expandedIndex = null;
          });
        }
      },
      icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 12),
      label: Text(label, style: _responsiveTextStyle(context, size: 10)),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: selected ? const Color(0xFFE9E9E9) : Colors.white,
        side: BorderSide(
          color: selected ? const Color(0xFFBDBDBD) : const Color(0xFFE0E0E0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        minimumSize: const Size(0, 30),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Future<void> _chooseDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2026, 6, 6),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (date != null) {
      setState(() => _dateFilter = '${date.day}/${date.month}/${date.year}');
    }
  }

  Widget _buildInvoiceTable() {
    final invoices = _visibleInvoices;
    return Column(
      children: [
        const _InvoiceTableHeader(),
        if (invoices.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'No invoices match this filter.',
              style: TextStyle(fontSize: 12, color: Color(0xFF777777)),
            ),
          ),
        for (var index = 0; index < invoices.length; index++) ...[
          _InvoiceHistoryRow(
            invoice: invoices[index],
            statusColor: _statusColors[invoices[index].status]!,
            expanded: _expandedIndex == index,
            onTap: () => setState(
              () => _expandedIndex = _expandedIndex == index ? null : index,
            ),
          ),
          if (_expandedIndex == index)
            _InvoiceDetailPanel(
              invoice: invoices[index],
              onVoid: () => setState(() => invoices[index].status = 'Voided'),
              onClear: () =>
                  setState(() => invoices[index].status = 'Fulfilled'),
            ),
        ],
      ],
    );
  }
}

class _InvoiceRecord {
  final String number;
  final int total;
  final String date;
  final String time;
  String status;

  _InvoiceRecord({
    required this.number,
    required this.total,
    required this.date,
    required this.time,
    required this.status,
  });
}

class _InvoiceTableHeader extends StatelessWidget {
  const _InvoiceTableHeader();

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.w600);
    return const Padding(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 7),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('Invoice Number', style: textStyle)),
          Expanded(flex: 1, child: Text('Total', style: textStyle)),
          Expanded(flex: 2, child: Text('Date', style: textStyle)),
          Expanded(flex: 2, child: Text('Time', style: textStyle)),
          Expanded(flex: 2, child: Text('Status', style: textStyle)),
          SizedBox(width: 24),
        ],
      ),
    );
  }
}

class _InvoiceHistoryRow extends StatelessWidget {
  final _InvoiceRecord invoice;
  final Color statusColor;
  final bool expanded;
  final VoidCallback onTap;

  const _InvoiceHistoryRow({
    required this.invoice,
    required this.statusColor,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFCECECE)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  invoice.number,
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  invoice.total.toStringAsGrouped(),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(invoice.date, style: const TextStyle(fontSize: 10)),
              ),
              Expanded(
                flex: 2,
                child: Text(invoice.time, style: const TextStyle(fontSize: 10)),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(invoice.status, style: const TextStyle(fontSize: 10)),
                    const SizedBox(width: 8),
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InvoiceDetailPanel extends StatelessWidget {
  final _InvoiceRecord invoice;
  final VoidCallback onVoid;
  final VoidCallback onClear;

  const _InvoiceDetailPanel({
    required this.invoice,
    required this.onVoid,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF168BFF), width: 1.2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  invoice.number,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                invoice.total.toStringAsGrouped(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Divider(height: 18),
          const Text(
            'Mr. Mbab     090 000 0000',
            style: TextStyle(fontSize: 10),
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Item',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Text(
                  'Location',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Text(
                  'Quantity',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Text(
                  'Rate',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Text(
                  'Amount',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const Divider(height: 12),
          const Row(
            children: [
              Expanded(
                flex: 3,
                child: Text('Premium White A4', style: TextStyle(fontSize: 9)),
              ),
              Expanded(child: Text('Lorem', style: TextStyle(fontSize: 9))),
              Expanded(child: Text('10', style: TextStyle(fontSize: 9))),
              Expanded(child: Text('1,000', style: TextStyle(fontSize: 9))),
              Expanded(
                child: Text(
                  '10,000',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Payment Breakdown',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ),
          const Divider(height: 12),
          Row(
            children: [
              const Expanded(
                child: Text('Cash       10,000', style: TextStyle(fontSize: 9)),
              ),
              const Expanded(
                child: Text(
                  'Total Paid: 10,000',
                  style: TextStyle(fontSize: 9),
                ),
              ),
              const Expanded(
                child: Text(
                  'Total Owing: 0.00',
                  style: TextStyle(fontSize: 9, color: Colors.red),
                ),
              ),
              const Expanded(
                child: Text(
                  'Total Cleared: 10,000',
                  style: TextStyle(fontSize: 9),
                ),
              ),
              TextButton(
                onPressed: onVoid,
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFFF173D),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(42, 26),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: const Text('Void', style: TextStyle(fontSize: 9)),
              ),
              const SizedBox(width: 6),
              FilledButton(
                onPressed: onClear,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(82, 26),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: const Text(
                  'Clear Payment',
                  style: TextStyle(fontSize: 9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

extension on int {
  String toStringAsGrouped() {
    final digits = toString();
    final buffer = StringBuffer();
    for (var index = 0; index < digits.length; index++) {
      if (index > 0 && (digits.length - index) % 3 == 0) buffer.write(',');
      buffer.write(digits[index]);
    }
    return buffer.toString();
  }
}

extension on double {
  String toStringAsGrouped() {
    final parts = toStringAsFixed(2).split('.');
    final whole = parts.first;
    final buffer = StringBuffer();
    for (var index = 0; index < whole.length; index++) {
      if (index > 0 && (whole.length - index) % 3 == 0) buffer.write(',');
      buffer.write(whole[index]);
    }
    return '${buffer.toString()}.${parts.last}';
  }
}

class _QuickActionsBar extends StatelessWidget {
  final String selected;
  final List<_QuickAction> actions;
  final bool isEditing;
  final VoidCallback onEditToggle;
  final void Function(int oldIndex, int newIndex) onReorder;
  final VoidCallback onAdd;
  final ValueChanged<_QuickAction> onRemove;
  final ValueChanged<String> onAction;

  const _QuickActionsBar({
    required this.selected,
    required this.actions,
    required this.isEditing,
    required this.onEditToggle,
    required this.onReorder,
    required this.onAdd,
    required this.onRemove,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFBDBDBD))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth / actions.length;
                final tileWidth = width < 112 ? 112.0 : width;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var index = 0; index < actions.length; index++)
                        SizedBox(
                          width: tileWidth,
                          child: _QuickActionButton(
                            action: actions[index],
                            index: index,
                            isSelected: actions[index].destination == selected,
                            isEditing: isEditing,
                            onTap: () => onAction(actions[index].destination),
                            onMoveLeft: () => onReorder(index, index - 1),
                            onMoveRight: () => onReorder(index, index + 1),
                            onRemove: () => onRemove(actions[index]),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 94,
                height: 34,
                child: TextButton.icon(
                  onPressed: onAdd,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF1D1D1D),
                    backgroundColor: const Color(0xFFF4F4F4),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                      side: const BorderSide(color: Color(0xFFE2E2E2)),
                    ),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text(
                    'Add',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 94,
                height: 34,
                child: TextButton.icon(
                  onPressed: onEditToggle,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF1D1D1D),
                    backgroundColor: isEditing
                        ? const Color(0xFFE4F2ED)
                        : const Color(0xFFF4F4F4),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                      side: const BorderSide(color: Color(0xFFE2E2E2)),
                    ),
                  ),
                  icon: Icon(
                    isEditing ? Icons.check_rounded : Icons.edit_outlined,
                    size: 17,
                  ),
                  label: Text(
                    isEditing ? 'Done' : 'Edit',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAction {
  final String label;
  final IconData icon;
  final String destination;

  const _QuickAction(this.label, this.icon, this.destination);
}

class _InventoryRow {
  final String sku;
  final String name;
  final String quantity;
  final String value;

  const _InventoryRow(this.sku, this.name, this.quantity, this.value);
}

const _defaultQuickActions = [
  _QuickAction('Home', Icons.menu_rounded, 'Dashboard'),
  _QuickAction('Bill', Icons.receipt_long_outlined, 'Create Bill'),
  _QuickAction('Process Payment', Icons.cached_rounded, 'Process Payment'),
  _QuickAction('Inventory', Icons.inventory_2_outlined, 'Inventory Centre'),
  _QuickAction('Customers', Icons.people_alt_outlined, 'New Customer'),
  _QuickAction('Banking', Icons.credit_card_outlined, 'Payment'),
  _QuickAction('Staff', Icons.badge_outlined, 'Add Staff'),
  _QuickAction('Print', Icons.print_outlined, 'Print'),
];

const _allQuickActions = [
  ..._defaultQuickActions,
  _QuickAction('Invoice History', Icons.receipt_outlined, 'Invoice History'),
  _QuickAction('Item List', Icons.list_alt_outlined, 'Item List'),
  _QuickAction(
    'Inventory Sites',
    Icons.store_mall_directory_outlined,
    'Inventory Site List',
  ),
  _QuickAction(
    'Adjust Stock',
    Icons.tune_rounded,
    'Adjust Quantity/Value on Hand',
  ),
  _QuickAction(
    'Transfer Stock',
    Icons.swap_horiz_rounded,
    'Transfer Inventory',
  ),
  _QuickAction('Receive Item', Icons.move_to_inbox_outlined, 'Receive Item'),
  _QuickAction('Refund', Icons.currency_exchange_rounded, 'Refund'),
  _QuickAction('View Users', Icons.group_outlined, 'View All Users'),
];

const _inventoryPages = {
  'Item List',
  'Inventory Site List',
  'Adjust Quantity/Value on Hand',
  'Transfer Inventory',
  'Receive Item',
};

class _QuickActionButton extends StatelessWidget {
  final _QuickAction action;
  final int index;
  final bool isSelected;
  final bool isEditing;
  final VoidCallback onTap;
  final VoidCallback onMoveLeft;
  final VoidCallback onMoveRight;
  final VoidCallback onRemove;

  const _QuickActionButton({
    required this.action,
    required this.index,
    required this.isSelected,
    required this.isEditing,
    required this.onTap,
    required this.onMoveLeft,
    required this.onMoveRight,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEditing ? null : onTap,
      child: Container(
        height: 76,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F0F0) : Colors.white,
          border: isSelected
              ? Border.all(color: const Color(0xFF777777), width: 1)
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(action.icon, color: Colors.black, size: 22),
                  const SizedBox(height: 3),
                  Text(
                    action.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            if (isEditing)
              Positioned(
                top: 2,
                right: 2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: const Color(0xFFBDBDBD)),
                        ),
                        child: const Icon(Icons.close_rounded, size: 12),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: onMoveLeft,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: const Color(0xFFBDBDBD)),
                        ),
                        child: const Icon(Icons.chevron_left_rounded, size: 14),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: onMoveRight,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: const Color(0xFFBDBDBD)),
                        ),
                        child: const Icon(
                          Icons.chevron_right_rounded,
                          size: 14,
                        ),
                      ),
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

class _CreateBillForm extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onPrint;
  final VoidCallback onSend;

  const _CreateBillForm({
    required this.onBack,
    required this.onPrint,
    required this.onSend,
  });

  @override
  State<_CreateBillForm> createState() => _CreateBillFormState();
}

class _CreateBillFormState extends State<_CreateBillForm>
    with _ResponsiveTextStyles {
  static const _customers = [
    'Mr. Mbab',
    'Lorem 1',
    'Ipsum 1',
    'Lorem 2',
    'Ipsum 2',
  ];

  final List<double> _amounts = [0];
  String? _customer;

  double get _total => _amounts.fold(0, (total, amount) => total + amount);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth < 700 ? 16.0 : 28.0;
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            22,
            horizontalPadding,
            20,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1050),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Create Bill',
                    style: _responsiveTextStyle(
                      context,
                      size: 19,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildCustomerInvoiceFields(),
                  const SizedBox(height: 24),
                  _buildItemsTable(),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Total', style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 14),
                        Text(
                          _total.toStringAsFixed(2),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: widget.onBack,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Color(0xFFBBBBBB)),
                          minimumSize: const Size(76, 36),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      const Spacer(),
                      _blackButton('Print', widget.onPrint),
                      const SizedBox(width: 12),
                      _blackButton('Send', widget.onSend),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomerInvoiceFields() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x15000000),
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 12,
        alignment: WrapAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 340,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Customer's Name",
                  style: _responsiveTextStyle(context, size: 10),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _customer,
                  isDense: true,
                  decoration: _billInputDecoration(),
                  hint: const Text(
                    'Select customer',
                    style: TextStyle(fontSize: 11),
                  ),
                  items: _customers
                      .map(
                        (name) =>
                            DropdownMenuItem(value: name, child: Text(name)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _customer = value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsTable() {
    return Column(
      children: [
        const _BillTableHeader(),
        for (var index = 0; index < _amounts.length; index++)
          _BillEntryRow(
            key: ValueKey(index),
            rowIndex: index,
            onAmountChanged: (amount) =>
                setState(() => _amounts[index] = amount),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            tooltip: 'Add item row',
            onPressed: () => setState(() => _amounts.add(0)),
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints.tightFor(width: 30, height: 30),
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _blackButton(String label, VoidCallback onPressed) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        minimumSize: const Size(64, 36),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      ),
      child: Text(label),
    );
  }
}

class _BillTableHeader extends StatelessWidget {
  const _BillTableHeader();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 10, fontWeight: FontWeight.w600);
    return const Padding(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 7),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('Item', style: style)),
          Expanded(flex: 2, child: Text('Location', style: style)),
          Expanded(flex: 1, child: Text('Quantity', style: style)),
          Expanded(flex: 1, child: Text('Rate', style: style)),
          Expanded(flex: 1, child: Text('Amount', style: style)),
        ],
      ),
    );
  }
}

class _BillEntryRow extends StatefulWidget {
  final int rowIndex;
  final ValueChanged<double> onAmountChanged;

  const _BillEntryRow({
    super.key,
    required this.rowIndex,
    required this.onAmountChanged,
  });

  @override
  State<_BillEntryRow> createState() => _BillEntryRowState();
}

class _BillEntryRowState extends State<_BillEntryRow> {
  static const _productRates = <String, double>{
    'Product 1': 100,
    'Product 2': 250,
    'Product 3': 500,
  };
  static const _products = ['Product 1', 'Product 2', 'Product 3'];
  static const _locations = ['Select location', 'Main Store', 'Warehouse'];
  final _quantityController = TextEditingController();
  final _rateController = TextEditingController();
  String? _product;
  String? _location;
  double _amount = 0;

  @override
  void dispose() {
    _quantityController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  void _updateAmount() {
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    final rate = double.tryParse(_rateController.text) ?? 0;
    final amount = quantity * rate;
    if (amount != _amount) {
      setState(() => _amount = amount);
      widget.onAmountChanged(amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFD8D8D8)),
          left: BorderSide(color: Color(0xFFD8D8D8)),
          right: BorderSide(color: Color(0xFFD8D8D8)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _tableDropdown(
              key: ValueKey('bill-product-dropdown-${widget.rowIndex}'),
              value: _product,
              values: _products,
              onChanged: (value) {
                setState(() {
                  _product = value;
                  _rateController.text =
                      _productRates[value]?.toStringAsFixed(2) ?? '';
                });
                _updateAmount();
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: _tableDropdown(
              key: ValueKey('bill-location-dropdown-${widget.rowIndex}'),
              value: _location,
              values: _locations,
              onChanged: (value) => setState(() => _location = value),
            ),
          ),
          Expanded(
            child: _tableTextField(
              _quantityController,
              onChanged: _updateAmount,
            ),
          ),
          Expanded(
            child: _tableTextField(_rateController, onChanged: _updateAmount),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: Color(0xFFD8D8D8))),
              ),
              child: Text(
                _amount == 0 ? '' : _amount.toStringAsFixed(2),
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableDropdown({
    Key? key,
    required String? value,
    required List<String> values,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Color(0xFFD8D8D8))),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          key: key,
          value: value,
          isExpanded: true,
          isDense: true,
          hint: const SizedBox.shrink(),
          icon: const Icon(
            Icons.arrow_drop_down,
            size: 16,
            color: Colors.black,
          ),
          items: values
              .map(
                (entry) => DropdownMenuItem(
                  value: entry,
                  child: Text(
                    entry,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _tableTextField(
    TextEditingController controller, {
    required VoidCallback onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: Color(0xFFD8D8D8))),
      ),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (_) => onChanged(),
        textAlign: TextAlign.right,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
        style: const TextStyle(fontSize: 11),
      ),
    );
  }
}

InputDecoration _billInputDecoration({String? hint}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 10, color: Color(0xFF9A9A9A)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    isDense: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(color: Color(0xFF777777)),
    ),
  );
}

class _MenuItem {
  final String label;
  final IconData icon;
  final List<String> children;

  const _MenuItem(this.label, this.icon, [this.children = const []]);
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF4F0),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, size: 20, color: const Color(0xFF167D68)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFF858C89),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Color(0xFF858C89),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color tint;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEBEEEC)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 19, color: const Color(0xFF4F685F)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Color(0xFF858C89), fontSize: 10),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
