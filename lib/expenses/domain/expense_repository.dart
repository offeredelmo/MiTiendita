
import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/expenses/domain/expense_entity.dart';

import '../../core/error/failures.dart';

abstract class ExpenseRepository {
  
  Future<Either<Failure, List<ExpenseEntity>>> getExpenses(DateTime date);
  Future<Either<Failure, bool>> createExpense(ExpenseEntity expenseEntity);
  Future<Either<Failure, bool>> deleteExpense(int id);
  Future<Either<Failure, double>> getTotalExpenseByMonth(DateTime date);
}