import 'package:hive_flutter/adapters.dart';
import 'package:mi_tiendita/core/error/failures.dart';

import '../../domain/expense_entity.dart';
import '../model/expense_model.dart';

abstract class ExpenseLocalDatasorce {
  Future<List<ExpenseEntity>> getExpenses(DateTime day);
  Future<bool> createExpense(ExpenseEntity expenseEntity);
  Future<bool> deleteExpense(int id);
  Future<double> getTotalExpenseByMonth(DateTime date);
}

class ExpenseLocalDatasorceImplement implements ExpenseLocalDatasorce {
  final String boxname = "expenses";

  @override
  Future<bool> createExpense(ExpenseEntity expenseEntity) async {
    try {
      final box = await Hive.openBox<ExpenseModelHive>(boxname);

      // Crear un nuevo gasto desde la entidad
      final newExpense = ExpenseModelHive.fromEntity(expenseEntity);

      // Guardar el nuevo gasto y obtener el ID generado
      final id = await box.add(newExpense);

      // Asociar el ID generado al objeto
      newExpense.id = id;

      // Volver a guardar el objeto actualizado
      await box.put(id, newExpense);

      // Confirmar que se guardó correctamente
      print("Nuevo gasto guardado con ID: $id");
      return true;
    } catch (e) {
      print("error: $e");
      throw LocalFailure();
    }
  }

  @override
  Future<List<ExpenseEntity>> getExpenses(DateTime day) async {
    try {
      // Open box with await
      final box = await Hive.openBox<ExpenseModelHive>(boxname);

      final expenses = box.values
          .where((element) =>
              element.date.year == day.year &&
              element.date.month == day.month &&
              element.date.day == day.day)
          .map((e) => e.toEntity())
          .toList();

      return expenses;
    } catch (e) {
      throw LocalFailure();
    }
  }

  @override
  Future<bool> deleteExpense(int id) async {
    try {
      final box = Hive.box<ExpenseModelHive>(boxname);
      await box.delete(id);
      return true;
    } catch (e) {
      throw LocalFailure();
    }
  }

  @override
  Future<double> getTotalExpenseByMonth(DateTime date) async {
    try {
      final box = await Hive.openBox<ExpenseModelHive>(boxname);

      final expenses = box.values
          .where((element) =>
              element.date.year == date.year &&
              element.date.month == date.month)
          .map((e) => e.toEntity())
          .toList();
      final totalExpense = expenses.fold<double>(
          0, (previousValue, element) => previousValue + element.amount);
      return totalExpense;
    } catch (e) {
      throw LocalFailure();
    }
  }
}
