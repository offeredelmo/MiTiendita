
import 'package:dartz/dartz.dart';
import 'package:mi_tiendita/Products/data/dataSorce/product_local_data_source.dart';
import 'package:mi_tiendita/Products/domain/entities.dart';
import 'package:mi_tiendita/Products/domain/repository.dart';
import 'package:mi_tiendita/core/error/failures.dart';

class ProductsRepositoryImpl implements ProductsRepository {

  final ProductsLocalDataSource productsLocalDataSource;

  ProductsRepositoryImpl({required this.productsLocalDataSource});



  @override
  Future<Either<Failure, bool>> addProduct(Product product) async{
    try {
      final bool resp = await productsLocalDataSource.addProduct(product);
      return Right(resp);
    } on LocalFailure {
      throw LocalFailure();
    }
  }

  @override
  Future<Either<Failure, bool>> deleteProduct(String id) async{
    try {
      final bool resp = await productsLocalDataSource.deleteProduct(id);
      return Right(resp);
    } on LocalFailure{
      throw LocalFailure();
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProducts() async{
    try {
      final List<Product> resp = await productsLocalDataSource.getProducts();
      return Right(resp);
    } on LocalFailure{
      throw LocalFailure();
    }
  }

  @override
  Future<Either<Failure, bool>> updateProduct(Product product) async{
    try {
      final bool resp = await productsLocalDataSource.updateProduct(product);
      return Right(resp);
    } catch (e) {
       throw LocalFailure();
    }
  }
  
}