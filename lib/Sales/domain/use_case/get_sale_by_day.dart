import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/Sales/domain/sales.entity.dart';
import 'package:mi_tiendita/Sales/domain/sales.repository.dart';
import 'package:mi_tiendita/core/error/failures.dart';

class GetSaleByDayUseCase {
  final SalesRepository repository;

  GetSaleByDayUseCase({required this.repository});

  Future<Either<Failure, List<SalesEntity>>> call(DateTime day) {
    return repository.getSalesByDay(day);
  }
}
