


import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/Sales/domain/sales.entity.dart';
import 'package:mi_tiendita/core/error/failures.dart';

abstract class SalesRepository {
  Future<Either<Failure, List<SalesEntity>>> getSales();
  Future<Either<Failure, List<SalesEntity>>> getSalesByDay(DateTime day);
  Future<Either<Failure, List<double>>> getSalesByMonth(DateTime month);
  Future<Either<Failure, bool>> addSell(SalesEntity salesEntity);
  Future<Either<Failure, double>> getTotalSaleByDay(DateTime day);

}