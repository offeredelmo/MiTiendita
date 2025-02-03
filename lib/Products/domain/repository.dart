
import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/Products/domain/entities.dart';
import 'package:mi_tiendita/core/error/failures.dart';

import '../../Sales/domain/sales.entity.dart';

abstract class ProductsRepository {
  Future<Either<LocalFailure, List<Product>>> getProducts();
  Future<Either<LocalFailure, bool>> addProduct(Product product);
  Future<Either<LocalFailure, bool>> deleteProduct(String id);
  Future<Either<LocalFailure, bool>> updateProduct(Product product);
  Future<Either<LocalFailure, Product>> getProductByBarcode(String barcode);
  Future<Either<LocalFailure,List<SaleItem>>> getTotalProductInSaleItem();

}