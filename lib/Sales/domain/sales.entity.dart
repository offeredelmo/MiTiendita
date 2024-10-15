import 'package:mi_tiendita/Products/domain/entities.dart';

class SaleItem {
  final Product product;
   int quantity;
  
  SaleItem({required this.product, required this.quantity});
}


class SalesEntity {
  final String id;
  final DateTime saleDate;
  final List<SaleItem> items;
  final double? totalsale;

  SalesEntity({ required this.id,required this.saleDate, required this.items, this.totalsale});


}
