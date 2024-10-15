import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/Sales/domain/sales.entity.dart';
import 'package:mi_tiendita/Sales/domain/sales.repository.dart';
import 'package:mi_tiendita/core/error/failures.dart';

class GetSaleUseCase {
  final SalesRepository repository;

  GetSaleUseCase({required this.repository});

  Future<Either<Failure, List<SalesEntity>>> call() {
    return repository.getSales();
  }
}
