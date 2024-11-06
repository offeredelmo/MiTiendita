part of 'add_info_ticket_bloc.dart';

@immutable
sealed class AddInfoTicketEvent {}


class UpdateInfoTicket extends AddInfoTicketEvent {
  final TicketEntity ticketEntity;

  UpdateInfoTicket({required this.ticketEntity});
  
}

class GetInfoTicket extends AddInfoTicketEvent {
  
}