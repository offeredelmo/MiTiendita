
import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/Ticket/Domain/ticket.entity.dart';
import 'package:mi_tiendita/Ticket/Domain/ticket.repository.dart';
import 'package:mi_tiendita/core/error/failures.dart';

class UpdateInfoTicketUseCase {
  final TicketRepository repository;

  UpdateInfoTicketUseCase({required this.repository});

  Future<Either<Failure, TicketEntity>> call(TicketEntity ticketEntity) {
    return repository.updateInfoTicket(ticketEntity);
  }
}