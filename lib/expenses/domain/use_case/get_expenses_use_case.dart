
import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/core/error/failures.dart';
import 'package:mi_tiendita/expenses/domain/expense_entity.dart';
import 'package:mi_tiendita/expenses/domain/expense_repository.dart';

class GetExpensesUseCase {
  final ExpenseRepository repository;

  GetExpensesUseCase({required this.repository});

  Future<Either<Failure, List<ExpenseEntity>>> execute(DateTime day) async{
    return await repository.getExpenses(day);
  }
  
}