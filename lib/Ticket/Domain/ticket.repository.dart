

import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/Ticket/Domain/ticket.entity.dart';
import 'package:mi_tiendita/core/error/failures.dart';

abstract class TicketRepository {
   Future<Either<Failure, TicketEntity>> getInfoCompany();
   Future<Either<Failure, TicketEntity>> updateInfoTicket(TicketEntity ticketEntity);
}