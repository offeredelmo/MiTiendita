part of 'add_info_ticket_bloc.dart';

@immutable
sealed class AddInfoTicketState {}

final class AddInfoTicketInitial extends AddInfoTicketState {}

// actualizacion de la configuracion del ticket

final class UpdateInfoTicketLoading extends AddInfoTicketState {}

final class UpdateInfoTicketSuccess extends AddInfoTicketState {
  final TicketEntity ticketEntity;

  UpdateInfoTicketSuccess({required this.ticketEntity});
}

final class UpdateInfoTicketFailure extends AddInfoTicketState {}

// obtener la configuracion del ticket

final class GetInfoTicketLoading extends AddInfoTicketState {}

final class GetInfoTicketSuccess extends AddInfoTicketState {
final TicketEntity ticketEntity;

  GetInfoTicketSuccess({required this.ticketEntity});  
}

final class GetInfoTicketFailure extends AddInfoTicketState {}





