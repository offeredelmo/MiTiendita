
class Product {
  final String id;
  final String? img_url;
  final String? img_base;
  final String name;
  final double price;
  final int stock;
  final String? barCode;

  Product(
      {required this.id,
      this.img_url,
      this.img_base,
      required this.name,
      required this.price,
      required this.stock,
      this.barCode
      });
}
