import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/Products/domain/entities.dart';
import 'package:mi_tiendita/core/error/failures.dart';

import '../repository.dart';

class GetProductByBarcodeUsecase {
  final ProductsRepository repository;

  GetProductByBarcodeUsecase({required this.repository});

  Future<Either<LocalFailure, Product>> call(String barcode) {
    return  repository.getProductByBarcode(barcode);
  }
  
}
