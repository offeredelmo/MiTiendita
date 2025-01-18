import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mi_tiendita/Ticket/Domain/ticket.entity.dart';
import 'package:mi_tiendita/Ticket/Domain/use_case/get_info_ticket.dart';
import 'package:mi_tiendita/Ticket/Domain/use_case/update_info_ticket.dart';


//BLOC
class AddInfoTicketBloc extends Bloc<AddInfoTicketEvent, AddInfoTicketState> {
  final UpdateInfoTicketUseCase updateInfoTicketUseCase;
  final GetInfoTicketUseCase getInfoTicketUseCase;

  AddInfoTicketBloc(this.updateInfoTicketUseCase, this.getInfoTicketUseCase)
      : super(AddInfoTicketInitial()) {

    on<UpdateInfoTicket>((event, emit) async {
      emit(UpdateInfoTicketLoading());
      final resp = await updateInfoTicketUseCase(event.ticketEntity);
      print("Respuesta de la actualizacion de la configuracion del ticket: $resp");
      resp.fold(
        (l) => emit(UpdateInfoTicketFailure()), 
        (r) => emit(GetInfoTicketSuccess(ticketEntity: r)));
    });

    on<GetInfoTicket>((event, emit) async{
      emit(GetInfoTicketLoading());
      final resp = await getInfoTicketUseCase();
      resp.fold((l) => emit(GetInfoTicketFailure()), (r) => emit(GetInfoTicketSuccess(ticketEntity: r)));
    });

  }

}

//EVENTS
@immutable
sealed class AddInfoTicketEvent {}


class UpdateInfoTicket extends AddInfoTicketEvent {
  final TicketEntity ticketEntity;

  UpdateInfoTicket({required this.ticketEntity});
  
}

class GetInfoTicket extends AddInfoTicketEvent {
  
}

//STATES
@immutable
sealed class AddInfoTicketState {}
class AddInfoTicketInitial extends AddInfoTicketState {}


// ESTADOS DE LA ACTUALIZACION DE LA CONFIGURACION DEL TICKET

final class UpdateInfoTicketLoading extends AddInfoTicketState {}

final class UpdateInfoTicketSuccess extends AddInfoTicketState {
  final TicketEntity ticketEntity;

  UpdateInfoTicketSuccess({required this.ticketEntity});
}

final class UpdateInfoTicketFailure extends AddInfoTicketState {}

// ESTADOS DE LA OBTENCION DE LA CONFIGURACION DEL TICKET

final class GetInfoTicketLoading extends AddInfoTicketState {}

final class GetInfoTicketSuccess extends AddInfoTicketState {
final TicketEntity ticketEntity;

  GetInfoTicketSuccess({required this.ticketEntity});  
}

final class GetInfoTicketFailure extends AddInfoTicketState {}


