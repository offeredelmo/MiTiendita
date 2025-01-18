import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mi_tiendita/expenses/domain/expense_entity.dart';

import '../../domain/use_case/get_expenses_use_case.dart';



class GetExpensesBloc extends Bloc<GetExpensesEvent, GetExpensesState> {
  final GetExpensesUseCase getExpensesUseCase;
  
  GetExpensesBloc(this.getExpensesUseCase) : super(GetExpensesInitial()) {

    on<GetExpensesEvent>((event, emit) async{
      emit(GetExpensesLoading());
      final  response = await this.getExpensesUseCase.execute(event.day);
      response.fold(
        (failure) => emit(GetExpensesFailure()),
        (expenses) => emit(GetExpensesSucces(expenses: expenses))
      );
    });
  }

}

class GetExpensesEvent {
  final DateTime day;

  GetExpensesEvent({required this.day});
  
}


@immutable
sealed class GetExpensesState {}

final class GetExpensesInitial extends GetExpensesState {}
final class GetExpensesLoading extends GetExpensesState {}
final class GetExpensesSucces extends GetExpensesState {
  final List<ExpenseEntity> expenses;
  GetExpensesSucces({required this.expenses});
}
final class GetExpensesFailure extends GetExpensesState {}

