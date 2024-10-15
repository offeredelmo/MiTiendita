import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/Products/domain/entities.dart';
import 'package:mi_tiendita/core/error/failures.dart';

import '../repository.dart';

class AddProductUseCase {
  final ProductsRepository repository;

  AddProductUseCase({required this.repository});

  Future<Either<Failure, bool>> call(Product product) {
    return repository.addProduct(product);
  }
}