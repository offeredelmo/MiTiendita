import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mi_tiendita/expenses/domain/expense_entity.dart';
import 'package:mi_tiendita/expenses/domain/use_case/create_expense_use_case.dart';

class CreateExpenseBloc extends Bloc<CreateExpenseEvent, CreateExpenseState> {
  final CreateExpenseUseCase createExpenseUseCase;
  
  CreateExpenseBloc(this.createExpenseUseCase) : super(CreateExpenseInitial()) {
    on<CreateExpenseEvent>((event, emit) async{
      emit(CreateExpenseLoading());
      final result = await createExpenseUseCase.call(event.expense);
      result.fold((l) => emit(CreateExpenseFailure()), (r) => emit(CreateExpenseSuccess(success: r)));
    });
  }
}

class CreateExpenseEvent {
  final ExpenseEntity expense;

  CreateExpenseEvent({required this.expense});
}

@immutable
sealed class CreateExpenseState {}

final class CreateExpenseInitial extends CreateExpenseState {}

final class CreateExpenseLoading extends CreateExpenseState {}

final class CreateExpenseSuccess extends CreateExpenseState {
  final bool success;

  CreateExpenseSuccess({required this.success});
}

final class CreateExpenseFailure extends CreateExpenseState {}
