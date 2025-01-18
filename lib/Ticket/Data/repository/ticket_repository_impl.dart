import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/Ticket/Data/dataSource/ticket_local_data_source.dart';
import 'package:mi_tiendita/Ticket/Domain/ticket.entity.dart';
import 'package:mi_tiendita/Ticket/Domain/ticket.repository.dart';
import 'package:mi_tiendita/core/error/failures.dart';

class TicketRepositoryImpl implements TicketRepository {
  final TicketLocalDataSource ticketLocalDataSource;

  TicketRepositoryImpl({required this.ticketLocalDataSource});

  @override
  Future<Either<Failure, TicketEntity>> getInfoCompany() async {
    try {
      final TicketEntity resp = await ticketLocalDataSource.getInfoCompany();
      return Right(resp);
    } on LocalFailure {
      throw Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, TicketEntity>> updateInfoTicket(
      TicketEntity ticketEntity) async {
    try {
      final TicketEntity resp =
          await ticketLocalDataSource.updateInfoTicket(ticketEntity);
      return right(resp);
    } on LocalFailure {
      throw Left(LocalFailure());
    }
  }
}
