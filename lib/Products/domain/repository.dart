
import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/Products/domain/entities.dart';
import 'package:mi_tiendita/core/error/failures.dart';

abstract class ProductsRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, bool>> addProduct(Product product);
  Future<Either<Failure, bool>> deleteProduct(String id);
  Future<Either<Failure, bool>> updateProduct(Product product);
}