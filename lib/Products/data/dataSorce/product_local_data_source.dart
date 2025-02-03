import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mi_tiendita/Products/data/models/product_model.dart';
import 'package:mi_tiendita/Products/domain/entities.dart';
import 'package:mi_tiendita/Sales/domain/sales.entity.dart';
import 'package:mi_tiendita/core/error/failures.dart';
import 'package:objectid/objectid.dart';

// Data Source
abstract class ProductsLocalDataSource {
  Future<List<Product>> getProducts();
  Future<bool> addProduct(Product product);
  Future<bool> deleteProduct(String id);
  Future<bool> updateProduct(Product product);
  Future<Product> getProductByBarcode(String barcode);
  Future<List<SaleItem>> getTotalProductInSaleItem();
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

      //Primero se busca si hay un producto con el mismo nombre, para evitar duplicidad
      final existProduct = box.values
          .any((p) => p.name.toLowerCase() == product.name.toLowerCase());
      if (existProduct) {
        throw Exception("Ya existe un producto registrado con ese nombre");
      }

      final productWithId = Product(
          id: id,
          name: product.name,
          img_url: product.img_url,
          price: product.price,
          stock: product.stock,
          barCode: product.barCode);
      await box.put(id, ProductDto.fromModel(productWithId));
      return true;
    } catch (e) {
      debugPrint("Error en DataSource: $e");
      throw Exception(
          e.toString()); // Lanza la excepción con el mensaje correcto
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

      //Primero se busca si hay un producto con el mismo nombre, para evitar duplicidad
      final existProduct = box.values.any(
          (p) => p.name.toLowerCase() == productToUpdate.name.toLowerCase());
      if (existProduct) {
        throw Exception("Ya existe un producto registrado con ese nombre");
      }

      if (existingProductDto != null) {
        // Actualizar los campos del ProductDto existente
        existingProductDto.name = productToUpdate.name;
        existingProductDto.price = productToUpdate.price;
        existingProductDto.stock = productToUpdate.stock;
        existingProductDto.img_url = productToUpdate.img_url;
        existingProductDto.barCode = productToUpdate.barCode;
        // Guardar los cambios
        await existingProductDto.save();
        return true;
      } else {
        // El producto no existe en la base de datos
        return false;
      }
    } catch (e) {
      debugPrint("Error en DataSource: $e");
      throw Exception(e.toString()); // Lanza la excepción con el mensaje correcto
    }
  }

  @override
  Future<Product> getProductByBarcode(String barcode) async {
    try {
      print("hola desde el datasorce: el barcode pa : ${barcode}");
      final box = await Hive.openBox<ProductDto>(_boxName);
      final products = box.values;
      final productFind =
          products.where((item) => item.barCode == barcode).toList();
      print("encontre el producto: ${products}");
      if (productFind.isNotEmpty) {
        return productFind.first.toProduct();
      } else {
        throw LocalFailure();
      }
    } catch (e) {
      throw LocalFailure();
    }
  }

  @override
  Future<List<SaleItem>> getTotalProductInSaleItem() async {
    try {
      final box = await Hive.openBox<ProductDto>(_boxName);
      final List<SaleItem> listSaleItem =
          box.values.map((product) => product.toSaleItem()).toList();
      return listSaleItem;
    } catch (e) {
      throw LocalFailure();
    }
  }
}
