import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mi_tiendita/Ticket/Domain/ticket.entity.dart';
import 'package:mi_tiendita/Ticket/Domain/use_case/update_info_ticket.dart';


class UpdateTicketInfoBlocBloc
    extends Bloc<UpdateTicketInfoBlocEvent, UpdateTicketInfoBlocState> {
  final UpdateInfoTicketUseCase updateInfoTicketUseCase;

  UpdateTicketInfoBlocBloc(this.updateInfoTicketUseCase,) : super(UpdateTicketInfoBlocInitial()) {

    on<UpdateTicketInfoBlocEvent>((event, emit) async{
      emit(UpdateTicketInfoBlocLoading());
       final resp = await updateInfoTicketUseCase(event.ticketEntity);
      print("Respuesta de la actualizacion de la configuracion del ticket: $resp");
      resp.fold((l) => emit(UpdateTicketInfoBlocFailure()), (r) => emit(UpdateTicketInfoBlocSucces(ticketEntity: r)));
    }
    
    );
  }
}
@immutable
class UpdateTicketInfoBlocEvent {
  final TicketEntity ticketEntity;

  UpdateTicketInfoBlocEvent({required this.ticketEntity}); 
}

@immutable
sealed class UpdateTicketInfoBlocState {}

final class UpdateTicketInfoBlocInitial extends UpdateTicketInfoBlocState {}
final class UpdateTicketInfoBlocLoading extends UpdateTicketInfoBlocState {}
final class UpdateTicketInfoBlocSucces extends UpdateTicketInfoBlocState {
   final TicketEntity ticketEntity;

  UpdateTicketInfoBlocSucces({required this.ticketEntity});
}
final class UpdateTicketInfoBlocFailure extends UpdateTicketInfoBlocState {}

