import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Expense Tracker',
      theme: ThemeData(
        // Simple Material 3 theme setup
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 33, 150, 243), // A blue color
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
