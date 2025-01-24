import 'package:mi_tiendita/Products/data/models/product_model.dart';
import 'package:mi_tiendita/Sales/domain/sales.entity.dart';
import 'package:hive_flutter/adapters.dart';

part 'sele_model.g.dart';

class SaleItemModel {
  final ProductModel product;
  final int quantity;

  SaleItemModel({required this.product, required this.quantity});

  factory SaleItemModel.fromEntity(SaleItem entity) {
    return SaleItemModel(
      product: ProductModel.fromEntity(entity.product),
      quantity: entity.quantity,
    );
  }

  SaleItem toEntity() {
    return SaleItem(
      product: product.toEntity(),
      quantity: quantity,
    );
  }
}

class SaleModel {
  final String id;
  final DateTime saleDate;
  final List<SaleItemModel> items;
  final double? totalsale;

  SaleModel({required this.id,required this.saleDate, required this.items, this.totalsale});

  factory SaleModel.fromEntity(SalesEntity entity, {required double totalsale}) {
    return SaleModel(
      id: entity.id,
      saleDate: entity.saleDate,
      items:entity.items.map((item) => SaleItemModel.fromEntity(item)).toList(),
      totalsale: entity.totalsale
    );
  }

  SalesEntity toEntity() {
    return SalesEntity(
      id: id,
      saleDate: saleDate,
      items: items.map((item) => item.toEntity()).toList(),
      totalsale: totalsale
    );
  }
}

@HiveType(typeId: 3)
class SaleItemDto {
  @HiveField(0)
  final ProductDto product;

  @HiveField(1)
  final int quantity;

  SaleItemDto({required this.product, required this.quantity});

  factory SaleItemDto.fromModel(SaleItemModel model) {
    return SaleItemDto(
      product: ProductDto.fromModel(model.product),
      quantity: model.quantity,
    );
  }

  SaleItemModel toModel() {
    return SaleItemModel(
      product: product.toModel(),
      quantity: quantity,
    );
  }
}

@HiveType(typeId: 2)
class SaleDto extends HiveObject {
  @HiveField(1)
  String id;

  @HiveField(2)
  DateTime saleDate;

  @HiveField(3)
  List<SaleItemDto> items;

  @HiveField(4)
  double totalsale;

  SaleDto(
      {required this.id, required this.saleDate, required this.items, required this.totalsale});

  factory SaleDto.fromModel(SaleModel model) {
    return SaleDto(
      id: model.id,
      saleDate: model.saleDate,
      items: model.items.map((item) => SaleItemDto.fromModel(item)).toList(),
      totalsale: model.items.fold(
          0, (total, item) => total + (item.product.price * item.quantity)),
    );
  }

  SaleModel toModel() {
    return SaleModel(
      id: id,
      saleDate: saleDate,
      items: items.map((item) => item.toModel()).toList(), 
      totalsale: totalsale
    );
  }

  
  

  // SalesEntity toEntity() {
  //   return SalesEntity(
  //     id: id, 
  //     saleDate: saleDate, 
  //     items: items.map((item) => item.),
  //     totalsale: totalsale
  //     );
  // }
}
