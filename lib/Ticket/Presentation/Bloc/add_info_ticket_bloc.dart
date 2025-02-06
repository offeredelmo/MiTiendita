import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mi_tiendita/Ticket/Domain/ticket.entity.dart';
import 'package:mi_tiendita/Ticket/Domain/use_case/get_info_ticket.dart';
import 'package:mi_tiendita/Ticket/Domain/use_case/update_info_ticket.dart';

//BLOC
class AddInfoTicketBloc extends Bloc<AddInfoTicketEvent, AddInfoTicketState> {
  final GetInfoTicketUseCase getInfoTicketUseCase;

  AddInfoTicketBloc(this.getInfoTicketUseCase) : super(AddInfoTicketInitial()) {
    
    on<GetInfoTicket>((event, emit) async {
      emit(GetInfoTicketLoading());
      final resp = await getInfoTicketUseCase();
      resp.fold((l) => emit(GetInfoTicketFailure()),
          (r) => emit(GetInfoTicketSuccess(ticketEntity: r)));
    }
    
    );
  }
}

//EVENTS
@immutable
sealed class AddInfoTicketEvent {}
class GetInfoTicket extends AddInfoTicketEvent {}

//STATES
@immutable
sealed class AddInfoTicketState {}

class AddInfoTicketInitial extends AddInfoTicketState {}

final class GetInfoTicketLoading extends AddInfoTicketState {}

final class GetInfoTicketSuccess extends AddInfoTicketState {
  final TicketEntity ticketEntity;

  GetInfoTicketSuccess({required this.ticketEntity});
}

final class GetInfoTicketFailure extends AddInfoTicketState {}
