part of 'products_bloc.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}
final class ProductsLoading extends ProductsState {}
final class ProductsSucces extends ProductsState {

}


final class ProductGetListLoading extends ProductsState {}

final class ProductAddLoading extends ProductsState {}


final class ProductDeleteLoading extends ProductsState {}


final class ProductUpdateLoading extends ProductsState {}





final class ProductsSuccesProductList extends ProductsState {
  final List<Product> products;

  ProductsSuccesProductList({required this.products});
}


final class AddProductsSucces extends ProductsState {
  final Product product;

  AddProductsSucces({required this.product});
}

final class AddProductFailureNameExist extends ProductsState {
 
  
}


final class ProductDeleteSucces extends ProductsState {
  
}

final class UpdateProductSucces extends ProductsState {
  
}

final class ProductsFailure extends ProductsState {
  final String? message;
  ProductsFailure({this.message});
}


final class ProductsUpdateFailure extends ProductsState {
  final String? message;
  ProductsUpdateFailure({this.message});
}

final class ProductsAddFailure extends ProductsState {
  final String? message;
  ProductsAddFailure({this.message});
}