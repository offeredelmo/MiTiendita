

import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/Sales/domain/sales.repository.dart';
import 'package:mi_tiendita/core/error/failures.dart';

class GetTotalSaleUseCase {
  final SalesRepository repository;

  GetTotalSaleUseCase({required this.repository});

  Future<Either<Failure, double>> call(DateTime day) {
    return repository.getTotalSaleByDay(day);
  }
}
