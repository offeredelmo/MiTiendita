import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mi_tiendita/Products/data/models/product_model.dart';
import 'package:mi_tiendita/Products/domain/entities.dart';
import 'package:mi_tiendita/core/error/failures.dart';
import 'package:objectid/objectid.dart';

// Data Source
abstract class ProductsLocalDataSource {
  Future<List<Product>> getProducts();
  Future<bool> addProduct(Product product);
  Future<bool> deleteProduct(String id);
  Future<bool> updateProduct(Product product);
}

class ProductsLocalDataSourceImpl implements ProductsLocalDataSource {
  static const String _boxName = 'products';

  @override
  Future<List<Product>> getProducts() async {
    final box = await Hive.openBox<ProductDto>(_boxName);
    return box.values.map((p) => p.toProduct()).toList();
  }

  @override
  Future<bool> addProduct(Product product) async {
    try {
      final box = await Hive.openBox<ProductDto>(_boxName);

      final id = ObjectId().toString(); // Genera un nuevo ID

      // Crea un nuevo Product con el ID generado
      final productWithId = Product(
        id: id,
        name: product.name,
        img_url: product.img_url,
        price: product.price,
        stock: product.stock,
        barCode: product.barCode
      );
      await box.put(id, ProductDto.fromModel(productWithId));
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw LocalFailure();
    }
  }

  @override
  Future<bool> deleteProduct(String id) async {
    try {
      final box = await Hive.openBox<ProductDto>(_boxName);
      await box.delete(id);
      return true;
    } catch (e) {
      throw LocalFailure();
    }
  }

  @override
  Future<bool> updateProduct(Product productToUpdate) async {
    try {
      final box = await Hive.openBox<ProductDto>(_boxName);
      final existingProductDto = await box.get(productToUpdate.id);
      if (existingProductDto != null) {
        // Actualizar los campos del ProductDto existente
        existingProductDto.name = productToUpdate.name;
        existingProductDto.price = productToUpdate.price;
        existingProductDto.stock = productToUpdate.stock;
        existingProductDto.img_url = productToUpdate.img_url;

        // Guardar los cambios
        await existingProductDto.save();
        return true;
      } else {
        // El producto no existe en la base de datos
        return false;
      }
    } catch (e) {
      debugPrint('Error al actualizar el producto: ${e.toString()}');
      throw LocalFailure();
    }
  }
}
