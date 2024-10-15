part of 'products_bloc.dart';

@immutable
sealed class ProductsEvent {}


class GetProducts extends ProductsEvent{}

class AddProducts extends ProductsEvent{
  final Product product;

  AddProducts({required this.product});
}



class DeleteProducts extends ProductsEvent{
  final String id;

  DeleteProducts({required this.id});
}

class UpdateProduct extends ProductsEvent{
  final Product product;
  UpdateProduct({required this.product});
}