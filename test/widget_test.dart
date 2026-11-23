// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retail_shop/main.dart';

void main() {
  testWidgets('sign in opens the store menu', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Lorem Ipsum'), findsOneWidget);
    expect(find.text('Sign In'), findsNWidgets(2));

    await tester.enterText(find.byType(TextFormField).at(0), 'manager');
    await tester.enterText(find.byType(TextFormField).at(1), 'password');
    await tester.tap(find.text('Sign In').last);
    await tester.pumpAndSettle();

    expect(find.text('Menu'), findsOneWidget);
    expect(find.text('Good morning, Administrator 👋'), findsOneWidget);
    expect(
      tester.getCenter(find.text('Home')).dx,
      lessThan(tester.getCenter(find.text('Bill')).dx),
    );

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.chevron_left_rounded).at(1));
    await tester.pumpAndSettle();
    expect(
      tester.getCenter(find.text('Bill')).dx,
      lessThan(tester.getCenter(find.text('Home')).dx),
    );
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Bill').first);
    await tester.pumpAndSettle();
    expect(find.text('Create Bill'), findsOneWidget);
    expect(find.text('Invoice Number'), findsNothing);
    expect(
      find.byKey(const ValueKey('bill-product-dropdown-0')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('bill-product-dropdown-1')), findsNothing);
    final productDropdown = tester.widget<DropdownButton<String>>(
      find.byKey(const ValueKey('bill-product-dropdown-0')),
    );
    productDropdown.onChanged!.call('Product 1');
    await tester.pumpAndSettle();
    expect(find.text('100.00'), findsOneWidget);
    await tester.tap(find.byTooltip('Add item row'));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('bill-product-dropdown-0')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('bill-product-dropdown-1')),
      findsOneWidget,
    );
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Inventory').first);
    await tester.pumpAndSettle();
    expect(find.text('Inventory Centre'), findsNWidgets(2));
    expect(find.text('Transaction Details'), findsOneWidget);
    expect(find.text('Deposit'), findsOneWidget);

    await tester.drag(find.byType(ListView).first, const Offset(0, -400));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(ListView).first,
        matching: find.text('Banking'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Payment').last);
    await tester.pumpAndSettle();
    expect(find.text('Invoice number'), findsOneWidget);

    await tester.tap(find.text('Refund').last);
    await tester.pumpAndSettle();
    expect(find.text('Credit No.'), findsOneWidget);
    expect(find.text('Save & New'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(ListView).first,
        matching: find.text('Banking'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).first, const Offset(0, -400));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(ListView).first,
        matching: find.text('Staff'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('First name'), findsOneWidget);
    expect(find.text('Last name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Phone'), findsOneWidget);
    expect(find.text('Address'), findsOneWidget);
    expect(find.text('Role'), findsOneWidget);

    await tester.tap(find.text('View All Users'));
    await tester.pumpAndSettle();
    expect(find.text('View All Users'), findsNWidgets(2));
    expect(find.text('Sales Manager'), findsOneWidget);
    expect(find.text('Cashier'), findsNWidgets(2));
    expect(find.text('Add Staff'), findsNWidgets(2));

    await tester.tap(find.text('Customers').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('New Customer'));
    await tester.pumpAndSettle();
    expect(find.text('Create New Customer'), findsOneWidget);
    expect(find.text("Customer's Name"), findsOneWidget);
    expect(find.text('Phone Number'), findsOneWidget);
    expect(find.text('Location (Optional)'), findsOneWidget);

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Item List').first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Item List').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Item List').first);
    await tester.pumpAndSettle();
    expect(find.text('Add Item'), findsOneWidget);
    expect(find.text('SKU-1001'), findsOneWidget);

    await tester.ensureVisible(find.text('Inventory Site List'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Inventory Site List'));
    await tester.pumpAndSettle();
    expect(find.text('Inventory locations'), findsOneWidget);
    expect(find.text('Add Site'), findsOneWidget);

    await tester.ensureVisible(find.text('Adjust Quantity/Value on Hand'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adjust Quantity/Value on Hand'));
    await tester.pumpAndSettle();
    expect(find.text('Adjustment details'), findsOneWidget);
    expect(find.text('Save Adjustment'), findsOneWidget);

    await tester.ensureVisible(find.text('Transfer Inventory'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Transfer Inventory'));
    await tester.pumpAndSettle();
    expect(find.text('Items to transfer'), findsOneWidget);
    expect(find.text('Transfer Inventory'), findsNWidgets(3));

    await tester.ensureVisible(find.text('Receive Item'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Receive Item'));
    await tester.pumpAndSettle();
    expect(find.text('Received items'), findsOneWidget);
    expect(find.text('Save Receipt'), findsOneWidget);
  });
}
