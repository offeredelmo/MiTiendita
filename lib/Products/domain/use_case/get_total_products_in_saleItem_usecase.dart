import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/Products/domain/repository.dart';
import 'package:mi_tiendita/Sales/domain/sales.entity.dart';
import 'package:mi_tiendita/core/error/failures.dart';

class GetTotalProductsInSaleitemUsecase {
  final ProductsRepository repository;

  GetTotalProductsInSaleitemUsecase({required this.repository});
  
  Future<Either<Failure, List<SaleItem>>> call() {
    return repository.getTotalProductInSaleItem();
  }
}