import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/Sales/domain/sales.repository.dart';
import 'package:mi_tiendita/core/error/failures.dart';

class GetSaleByMonthUseCase {
  final SalesRepository repository;

  GetSaleByMonthUseCase({required this.repository});

  Future<Either<Failure, List<double>>> call(DateTime month) {
    return repository.getSalesByMonth(month);
  }
}
