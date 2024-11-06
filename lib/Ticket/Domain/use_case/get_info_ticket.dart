

import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/Ticket/Domain/ticket.entity.dart';
import 'package:mi_tiendita/Ticket/Domain/ticket.repository.dart';
import 'package:mi_tiendita/core/error/failures.dart';

class GetInfoTicketUseCase {
  final TicketRepository repository;

  GetInfoTicketUseCase({required this.repository}); 

  Future<Either<Failure, TicketEntity>> call() {
    return repository.getInfoCompany();
  }
}