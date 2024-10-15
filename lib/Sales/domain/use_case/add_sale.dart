
import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/Sales/domain/sales.entity.dart';
import 'package:mi_tiendita/Sales/domain/sales.repository.dart';
import 'package:mi_tiendita/core/error/failures.dart';

class AddSaleUseCase {
  final SalesRepository repository;

  AddSaleUseCase({required this.repository});


  Future<Either<Failure, bool>> call(SalesEntity saleEntity) {
    return repository.addSell(saleEntity);
  }

  
}