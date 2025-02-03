import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/Products/data/dataSorce/product_local_data_source.dart';
import 'package:mi_tiendita/Products/domain/entities.dart';
import 'package:mi_tiendita/Products/domain/repository.dart';
import 'package:mi_tiendita/Sales/domain/sales.entity.dart';
import 'package:mi_tiendita/core/error/failures.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsLocalDataSource productsLocalDataSource;

  ProductsRepositoryImpl({required this.productsLocalDataSource});

  @override
  Future<Either<LocalFailure, bool>> addProduct(Product product) async {
    try {
      final bool resp = await productsLocalDataSource.addProduct(product);
      return Right(resp);
    } catch (e) {
      final String error = (e.toString().split(":").length > 1
              ? e.toString().split(":")[2].trim()
              : null) ??
          "Error desconocido";
      return Left(
          LocalFailure(message: error)); // Pasar el mensaje de la excepción
    }
  }

  @override
  Future<Either<LocalFailure, bool>> deleteProduct(String id) async {
    try {
      final bool resp = await productsLocalDataSource.deleteProduct(id);
      return Right(resp);
    } on LocalFailure {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<LocalFailure, List<Product>>> getProducts() async {
    try {
      final List<Product> resp = await productsLocalDataSource.getProducts();
      return Right(resp);
    } on LocalFailure {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<LocalFailure, bool>> updateProduct(Product product) async {
    try {
      final bool resp = await productsLocalDataSource.updateProduct(product);
      return Right(resp);
    } catch (e) {
      final String error = (e.toString().split(":").length > 1
              ? e.toString().split(":")[2].trim()
              : null) ??
          "Error desconocido";
      return Left(
          LocalFailure(message: error)); // Pasar el mensaje de la excepción
    }
  }

  @override
  Future<Either<LocalFailure, Product>> getProductByBarcode(
      String barcode) async {
    try {
      final response =
          await productsLocalDataSource.getProductByBarcode(barcode);
      return Right(response);
    } catch (e) {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<LocalFailure, List<SaleItem>>>
      getTotalProductInSaleItem() async {
    try {
      final response =
          await productsLocalDataSource.getTotalProductInSaleItem();
      return Right(response);
    } catch (e) {
      return Left(LocalFailure());
    }
  }
}
