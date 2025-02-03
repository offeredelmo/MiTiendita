
import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/Products/domain/entities.dart';
import 'package:mi_tiendita/Products/domain/repository.dart';
import 'package:mi_tiendita/core/error/failures.dart';

class UpdateProductUseCase {
  final ProductsRepository repository;
  UpdateProductUseCase({required this.repository});

  Future<Either<LocalFailure,bool>> call(Product product){
    return repository.updateProduct(product);
  }
}