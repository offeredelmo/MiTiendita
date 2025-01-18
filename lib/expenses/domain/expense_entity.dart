class ExpenseEntity {
  final int id;
  final double amount;
  final String description;
  final DateTime date;
  final String? category;

  const ExpenseEntity({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    this.category
  });

}
