import 'dart:convert';
// import 'dart:ffi';

class Expense {
  final String id;
  final String title;
  final int amount;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });

  // Convert an Expense object to a Map (for JSON encoding/SharedPreferences)
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amount': amount,
    'date': date.toIso8601String(), // Store date as a string
  };

  // Create an Expense object from a Map (for JSON decoding/SharedPreferences)
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: json['amount'] as int,
      date: DateTime.parse(json['date'] as String),
    );
  }

  // Helper method to encode a list of Expenses to a JSON string
  static String encode(List<Expense> expenses) => json.encode(
    expenses
        .map<Map<String, dynamic>>((expense) => expense.toJson())
        .toList(),
  );

  // Helper method to decode a JSON string back into a list of Expenses
  static List<Expense> decode(String expensesString) {
    final List<dynamic> jsonList = json.decode(expensesString);
    return jsonList
        .map<Expense>((json) => Expense.fromJson(json))
        .toList();
  }
}