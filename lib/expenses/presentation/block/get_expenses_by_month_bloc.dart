import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mi_tiendita/expenses/domain/expense_entity.dart';

import '../../domain/use_case/get_total_expense_by_month_usecase.dart';

class GetTotalExpensesByMonthBloc
    extends Bloc<GetExpensesByMonthEvent, GetExpensesByMonthState> {
  final GetTotalExpenseByMonthUsecase getExpensesByMonthUseCase;

  GetTotalExpensesByMonthBloc(this.getExpensesByMonthUseCase)
      : super(GetTotalExpensesByMonthInitial()) {
    on<GetExpensesByMonthEvent>((event, emit) async {
      emit(GetTotalExpensesByMonthLoading());
      final response = await getExpensesByMonthUseCase(event.date);
      response.fold((l) => emit(GetTotalExpensesByMonthError()),
          (r) => emit(GetTotalExpensesByMonthSuccess(expenses: r)));
    });
  }
}

class GetExpensesByMonthEvent {
  final DateTime date;

  GetExpensesByMonthEvent({required this.date});
}

@immutable
sealed class GetExpensesByMonthState {}

final class GetTotalExpensesByMonthInitial extends GetExpensesByMonthState {}

final class GetTotalExpensesByMonthLoading extends GetExpensesByMonthState {}

final class GetTotalExpensesByMonthError extends GetExpensesByMonthState {}

final class GetTotalExpensesByMonthSuccess extends GetExpensesByMonthState {
  final double expenses;

  GetTotalExpensesByMonthSuccess({required this.expenses});
}
