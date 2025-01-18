import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mi_tiendita/expenses/domain/use_case/delete_expense_by_id_use_case.dart';

class DeleteExpenseByIdBloc
    extends Bloc<DeleteExpenseByIdEvent, DeleteExpenseByIdState> {
  final DeleteExpenseByIdUseCase deleteExpenseByIdUseCase;
  DeleteExpenseByIdBloc(this.deleteExpenseByIdUseCase)
      : super(DeleteExpenseByIdInitial()) {
    on<DeleteExpenseByIdEvent>((event, emit) async {
      emit(DeleteExpenseByIdLoading());
      final response = await deleteExpenseByIdUseCase(event.id);
      response.fold(
          (l) => emit(DeleteExpenseByIdFailure()), (r) => emit(DeleteExpenseByIdSucces()));
    });
  }
}

class DeleteExpenseByIdEvent {
  final int id;

  DeleteExpenseByIdEvent({required this.id});
}

@immutable
sealed class DeleteExpenseByIdState {}

final class DeleteExpenseByIdInitial extends DeleteExpenseByIdState {}

final class DeleteExpenseByIdLoading extends DeleteExpenseByIdState {}

final class DeleteExpenseByIdFailure extends DeleteExpenseByIdState {}

final class DeleteExpenseByIdSucces extends DeleteExpenseByIdState {

}
