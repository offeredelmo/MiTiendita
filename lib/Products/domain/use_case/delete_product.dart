

import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/Products/domain/repository.dart';
import 'package:mi_tiendita/core/error/failures.dart';

class DeleteProductUseCase {
  final ProductsRepository repository;

  DeleteProductUseCase({required this.repository});


  Future<Either<LocalFailure, bool>> call(String id) {
    return repository.deleteProduct(id);
  }
}