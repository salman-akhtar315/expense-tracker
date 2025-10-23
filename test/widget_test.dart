// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// 1. You must import your main file here to access ExpenseTrackerApp
import 'package:daily_expense_tracker/main.dart';
// NOTE: Replace 'daily_expense_tracker' with your actual project name if different.

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // 👇 CHANGE THIS LINE
    await tester.pumpWidget(const ExpenseTrackerApp()); // Use the correct class name!

    // Verify that our app starts with the title 'Daily Expense Tracker'
    expect(find.text('Daily Expense Tracker'), findsOneWidget);

    // You can add more specific tests here for the HomeScreen, like finding the FAB
    // expect(find.byIcon(Icons.add), findsOneWidget);
  });
}




// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// import 'package:daily_expense_tracker/main.dart';
//
// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget( MyApp());
//
//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);
//
//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();
//
//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }
