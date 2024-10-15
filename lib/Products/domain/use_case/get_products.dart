

import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/Products/domain/entities.dart';

import '../../../core/error/failures.dart';
import '../repository.dart';

class GetProductsUseCase {
  final ProductsRepository repository;

  GetProductsUseCase({required this.repository});

  Future<Either<Failure, List<Product>>> call() {
    return repository.getProducts();
  }
}