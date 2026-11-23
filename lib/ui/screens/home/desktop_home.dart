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
    if (_selected == 'Dashboard') return _buildDashboard();
    return _buildSectionPlaceholder();
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
