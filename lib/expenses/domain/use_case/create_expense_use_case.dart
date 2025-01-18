import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/core/error/failures.dart';
import 'package:mi_tiendita/expenses/domain/expense_entity.dart';
import 'package:mi_tiendita/expenses/domain/expense_repository.dart';

class CreateExpenseUseCase {
  final ExpenseRepository repository;

  CreateExpenseUseCase({
    required this.repository
  });

  Future<Either<Failure, bool>> call(ExpenseEntity expense) async {
    return await repository.createExpense(expense);
  }
  
}