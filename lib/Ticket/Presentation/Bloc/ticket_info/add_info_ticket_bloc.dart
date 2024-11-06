import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mi_tiendita/Ticket/Domain/ticket.entity.dart';
import 'package:mi_tiendita/Ticket/Domain/use_case/get_info_ticket.dart';
import 'package:mi_tiendita/Ticket/Domain/use_case/update_info_ticket.dart';
import 'package:mi_tiendita/core/error/failures.dart';

part 'add_info_ticket_event.dart';
part 'add_info_ticket_state.dart';

class AddInfoTicketBloc extends Bloc<AddInfoTicketEvent, AddInfoTicketState> {
  final UpdateInfoTicketUseCase updateInfoTicketUseCase;
  final GetInfoTicketUseCase getInfoTicketUseCase;

  AddInfoTicketBloc(this.updateInfoTicketUseCase, this.getInfoTicketUseCase)
      : super(AddInfoTicketInitial()) {
    on<UpdateInfoTicket>((event, emit) async {
      emit(UpdateInfoTicketLoading());
      final resp = await updateInfoTicketUseCase(event.ticketEntity);
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
