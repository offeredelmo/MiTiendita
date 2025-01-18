
import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/expenses/domain/expense_repository.dart';

import '../../../core/error/failures.dart';
import '../expense_entity.dart';

class GetTotalExpenseByMonthUsecase {
  final ExpenseRepository repository;

  GetTotalExpenseByMonthUsecase({required this.repository});
  
  Future<Either<Failure, double>> call(DateTime date) async {
    return await repository.getTotalExpenseByMonth(date);
  }
}