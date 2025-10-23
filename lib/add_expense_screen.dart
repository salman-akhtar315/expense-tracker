// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart'; // Add uuid package for unique IDs (optional, but good practice)
import 'models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  final Function(Expense) addExpense;

  const AddExpenseScreen({super.key, required this.addExpense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  // Cleanup controllers when the widget is disposed
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // --- Date Picker Logic ---
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  // --- Submission Logic ---
  void _submitExpenseData() {
    // Basic validation
    final enteredAmount = int.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Please ensure a valid title, amount, and date were entered.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    // Create a new expense and call the callback function (addExpense)
    final newExpense = Expense(
      id: const Uuid().v4(), // Generate a unique ID
      title: _titleController.text,
      amount: enteredAmount,
      date: _selectedDate!,
    );

    widget.addExpense(newExpense);

    // Close the screen after submission
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          color: Colors.white,
            onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios)
        ),
        title: const Text('Add New Expense', style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 40,),
            // Title Input
            TextField(
              controller: _titleController,
              maxLength: 50,
              decoration: const InputDecoration(
                labelText: 'Title',
                icon: Icon(Icons.description),
              ),
            ),

            // Amount and Date Picker Row
            Row(
              children: [
                // Amount Input
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount (Rs.)',
                      icon: Icon(Icons.money),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Date Picker
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'No Date Chosen'
                            : DateFormat('d MMM yyyy').format(_selectedDate!),
                      ),
                      IconButton(
                        onPressed: _presentDatePicker,
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 100),

            // Submit Button
            InkWell(
              onTap: () => _submitExpenseData(),
              child: Container(
                // color: Theme.of(context).colorScheme.primary,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 50,
                width: 300,
                child: Center(child: Text("Save Expense", style: TextStyle(color: Colors.white),)),
              ),
            ),
            // ElevatedButton(
            //   onPressed: _submitExpenseData,
            //   child: const Text('Save Expense'),
            // ),
          ],
        ),
      ),
    );
  }
}