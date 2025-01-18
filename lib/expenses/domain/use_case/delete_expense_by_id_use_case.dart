

import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/expenses/domain/expense_repository.dart';

import '../../../core/error/failures.dart';

class DeleteExpenseByIdUseCase {
  final ExpenseRepository repository;

  DeleteExpenseByIdUseCase({required this.repository});
  
  Future<Either<Failure, bool>> call(int id) async {
    return await repository.deleteExpense(id);
  }
}