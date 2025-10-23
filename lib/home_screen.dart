import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/expense.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> _expenses = [];
  final String _expensesKey = 'dailyExpenses';

  @override
  void initState() {
    super.initState();
    _loadExpenses(); // Load data on startup
  }

  // --- Data Storage (SharedPreferences) ---

  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? expensesString = prefs.getString(_expensesKey);

    if (expensesString != null) {
      setState(() {
        _expenses = Expense.decode(expensesString);
        // Sort by date descending (latest first)
        _expenses.sort((a, b) => b.date.compareTo(a.date));
      });
    }
  }

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String expensesString = Expense.encode(_expenses);
    await prefs.setString(_expensesKey, expensesString);
  }

  // --- CRUD Operations & State Update ---

  void _addExpense(Expense expense) {
    setState(() {
      _expenses.add(expense);
      _expenses.sort((a, b) => b.date.compareTo(a.date)); // Re-sort
    });
    _saveExpenses();
  }

  // ⭐ UPDATED: Delete Functionality with Confirmation Dialog
  void _deleteExpense(Expense expense) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete the expense: "${expense.title}"?'),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          // OK Button (Performs the deletion)
          TextButton(
            onPressed: () {
              // 1. Close the dialog
              Navigator.of(ctx).pop();

              // 2. Perform the actual deletion and state update
              setState(() {
                _expenses.removeWhere((e) => e.id == expense.id);
              });
              _saveExpenses();

              // 3. Show a brief confirmation snackbar
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Expense deleted successfully.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  // --- Navigation & UI ---

  void _openAddExpenseScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => AddExpenseScreen(addExpense: _addExpense),
      ),
    );
  }

  // Bonus: Calculate total expenses
  int get _totalExpense {
    return _expenses.fold(0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Expense Tracker'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Expenses:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      // 'Rs. ${_totalExpense.toStringAsFixed(2)}',
                      'Rs. $_totalExpense',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 20,),

          // Expense List
          Expanded(
            child: _expenses.isEmpty
                ? const Center(
              child: Text(
                'No expenses yet! Tap "+" to start tracking.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final expense = _expenses[index];

                return Card(
                  key: ValueKey(expense.id),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  elevation: 1,
                  child: ListTile(
                    // ⭐ Long-press Listener calls the function with the confirmation dialog
                    onLongPress: () => _deleteExpense(expense),

                    // Visual indicator for delete capability
                    // leading: const Icon(Icons.receipt_long, color: Colors.blueGrey),
                    leading: const Icon(Icons.delete_forever_rounded, color: Colors.blueGrey),
                    // Expense Title
                    title: Text(expense.title),

                    // Expense Date
                    subtitle: Text(DateFormat('dd MMM yyyy').format(expense.date)),

                    // Expense Amount
                    trailing: Text(
                        'Rs. ${expense.amount}',
                        // 'Rs. ${expense.amount.toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: _openAddExpenseScreen,
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}
