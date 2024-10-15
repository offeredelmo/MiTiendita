import 'package:hive_flutter/adapters.dart';
import 'package:mi_tiendita/Products/domain/entities.dart';

part 'product_model.g.dart';

class ProductModel extends Product {
  ProductModel({
    required String id,
    String? img_url,
    required String name,
    required double price,
    required int stock,
  }) : super(
          id: id,
          img_url: img_url,
          name: name,
          price: price,
          stock: stock,
        );

  // Implementación correcta de fromEntity como constructor factory
  factory ProductModel.fromEntity(Product product) {

    // Validar campos esenciales, excepto img_url
    if (product.id.isEmpty || product.name.isEmpty) {
    }

    // No validar img_url ya que puede ser null

    return ProductModel(
      id: product.id,
      img_url: product.img_url, // Permitir que sea null
      name: product.name,
      price: product.price,
      stock: product.stock,
    );
  }

  // Implementación de fromJson
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["_id"],
      img_url: json["img_url"],
      name: json["name"],
      price: (json["price"] as num).toDouble(),
      stock: json["stock"],
    );
  }

  // Método toJson
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "img_url": img_url,
      "name": name,
      "price": price,
      "stock": stock,
    };
  }

  // Implementación de toEntity
  Product toEntity() {
    return Product(
      id: id,
      img_url: img_url,
      name: name,
      price: price,
      stock: stock,
    );
  }
}

@HiveType(typeId: 1)
class ProductDto extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  late String? img_url;

  @HiveField(2)
  String name;

  @HiveField(3)
  double price;

  @HiveField(4)
  int stock;

  ProductDto({
    required this.id,
    this.img_url,
    required this.name,
    required this.price,
    required this.stock,
  });

  factory ProductDto.fromModel(Product product) {
    return ProductDto(
      id: product.id,
      img_url: product.img_url,
      name: product.name,
      price: product.price,
      stock: product.stock,
    );
  }
  // Convertir de ProductDto a Product
  Product toProduct() {
    return ProductModel(
        id: id, img_url: img_url, name: name, price: price, stock: stock);
  }

  ProductModel toModel() {
    return ProductModel(
      id: id,
      img_url: img_url,
      name: name,
      price: price,
      stock: stock,
    );
  }
}
