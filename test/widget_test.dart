// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodbuseng/foodbuseng_home.dart';

void main() {
  testWidgets('adding a dish updates the order', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const FoodbusengApp());

    expect(find.text('foodbuseng'), findsOneWidget);
    final addButton = find.byTooltip('Add Double smash burger');
    await tester.ensureVisible(addButton);
    await tester.tap(addButton);
    await tester.pump();
    await tester.tap(find.text('View order'));
    await tester.pump();

    expect(find.text('Double smash burger'), findsWidgets);
    expect(find.text('Checkout  ·  \$15.00'), findsOneWidget);
  });

  testWidgets('wide layout shows menu and order side by side', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const FoodbusengApp());

    expect(find.text('What sounds good?'), findsOneWidget);
    expect(find.text('Your order'), findsOneWidget);
  });
}
