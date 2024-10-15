import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/Sales/data/dataDorce/sales_local_data_source.dart';
import 'package:mi_tiendita/Sales/domain/sales.entity.dart';
import 'package:mi_tiendita/Sales/domain/sales.repository.dart';
import 'package:mi_tiendita/core/error/failures.dart';

class SaleRepositoryImpl implements SalesRepository {
  final SaleLocalDataSource saleLocalDataSource;

  SaleRepositoryImpl({required this.saleLocalDataSource});

  @override
  Future<Either<Failure, bool>> addSell(SalesEntity salesEntity) async {
    try {
      final bool resp = await saleLocalDataSource.addSell(salesEntity);
      return Right(resp);
    } on LocalFailure {
      throw LocalFailure();
    }
  }

  @override
  Future<Either<Failure, List<SalesEntity>>> getSales() async {
    try {
      final List<SalesEntity> resp = await saleLocalDataSource.getSales();
      return Right(resp);
    } on LocalFailure {
      throw LocalFailure();
    }
  }

  @override
  Future<Either<Failure, List<SalesEntity>>> getSalesByDay(DateTime day) async {
    try {
      final List<SalesEntity> resp =
          await saleLocalDataSource.getSalesByDay(day);
      return Right(resp);
    } on LocalFailure {
      throw LocalFailure();
    }
  }

  @override
  Future<Either<Failure, List<double>>> getSalesByMonth(DateTime month) async {
    try {
      final List<double> resp =
          await saleLocalDataSource.getSalesByMonth(month);
      return Right(resp);
    } on LocalFailure {
      throw LocalFailure();
    }
  }

  @override
  Future<Either<Failure, double>> getTotalSaleByDay(DateTime day) async {
    try {
      final double resp = await saleLocalDataSource.getTotalSaleByDay(day);
      return Right(resp);
    } on LocalFailure {
      throw LocalFailure();
    }
  }
}
