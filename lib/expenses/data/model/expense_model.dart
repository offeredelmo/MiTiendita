
import 'package:hive_flutter/adapters.dart';
import 'package:mi_tiendita/expenses/domain/expense_entity.dart';
  part 'expense_model.g.dart';
class ExpenseModel {
  final int id;
  final double amount;
  final String description;
  final DateTime date;
  final String? category;

  ExpenseModel({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    this.category
  });

  factory ExpenseModel.fromEntity(ExpenseEntity expenseEntity) {
    return ExpenseModel(
      id: expenseEntity.id,
      amount: expenseEntity.amount,
      description: expenseEntity.description,
      date: expenseEntity.date,
      category: expenseEntity.category
    );
  }

  ExpenseEntity toEntity() {
    return ExpenseEntity(
      id: id,
      amount: amount,
      description: description,
      date: date,
      category: category
    );
  }
}

@HiveType(typeId: 6)
class ExpenseModelHive extends HiveObject{

  @HiveField(0)
  int id;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String? category;

  ExpenseModelHive({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    this.category
  });

  factory ExpenseModelHive.fromModel(ExpenseModel expenseModel){
    return ExpenseModelHive(
      id: expenseModel.id,
      amount: expenseModel.amount,
      description: expenseModel.description,
      date: expenseModel.date,
      category: expenseModel.category
    );
  }

  static fromEntity(ExpenseEntity expenseEntity){
    return ExpenseModelHive(
      id: expenseEntity.id,
      amount: expenseEntity.amount,
      description: expenseEntity.description,
      date: expenseEntity.date,
      category: expenseEntity.category
    );
  }
  ExpenseEntity toEntity() {
    return ExpenseEntity(
      id: id,
      amount: amount,
      description: description,
      date: date,
      category: category
    );
  }
  
}
