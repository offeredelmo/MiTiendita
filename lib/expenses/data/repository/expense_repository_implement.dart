import 'package:dartz/dartz.dart';

import 'package:mi_tiendita/core/error/failures.dart';

import 'package:mi_tiendita/expenses/domain/expense_entity.dart';

import '../../domain/expense_repository.dart';
import '../dataSource/expense_local_datasorce.dart';

class ExpenseRepositoryImplement implements ExpenseRepository {
  final ExpenseLocalDatasorce expenseLocalDatasorce;

  ExpenseRepositoryImplement({required this.expenseLocalDatasorce});

  @override
  Future<Either<Failure, List<ExpenseEntity>>> getExpenses(DateTime day) async {
    try {
      final response = await expenseLocalDatasorce.getExpenses(day);
      return Right(response);
    } catch (e) {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> createExpense(
      ExpenseEntity expenseEntity) async {
    try {
      final response = await expenseLocalDatasorce.createExpense(expenseEntity);
      return Right(response);
    } catch (e) {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteExpense(int id) async {
    try {
      final response = await expenseLocalDatasorce.deleteExpense(id);
      return Right(response);
    } catch (e) {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, double>> getTotalExpenseByMonth(
      DateTime date) async {
    try {
      final response = await expenseLocalDatasorce.getTotalExpenseByMonth(date);
      return Right(response);
    } catch (e) {
      return Left(LocalFailure());
    }
  }
}
