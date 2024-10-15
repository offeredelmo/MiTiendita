import 'package:bloc/bloc.dart';
import 'package:mi_tiendita/Products/domain/use_case/update_product.dart';
import 'package:meta/meta.dart';
import 'package:mi_tiendita/Products/domain/entities.dart';
import 'package:mi_tiendita/Products/domain/use_case/add_product.dart';
import 'package:mi_tiendita/Products/domain/use_case/delete_product.dart';
import 'package:mi_tiendita/Products/domain/use_case/get_products.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {

  final GetProductsUseCase _getProductsUseCase;
  final AddProductUseCase _addProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;



  ProductsBloc(this._getProductsUseCase, this._addProductUseCase, this._deleteProductUseCase, this._updateProductUseCase) : super(ProductsInitial()) {

    on<GetProducts>((event, emit) async{
      emit(ProductGetListLoading());
      final resp = await _getProductsUseCase();
      resp.fold((l) => emit(ProductsFailure()), (r) => emit(ProductsSuccesProductList(products: r)));
    });

    on<AddProducts>((event, emit) async{
      emit(ProductAddLoading());
      final resp = await _addProductUseCase(event.product);
      resp.fold((l) => emit(ProductsFailure()) , (r) => emit(ProductsSucces()));
    });

    on<DeleteProducts>((event, emit) async{
      emit(ProductDeleteLoading());
      final resp = await _deleteProductUseCase(event.id);
      resp.fold((l) =>emit(ProductsFailure()) , (r) =>emit(ProductDeleteSucces()));
    });

    on<UpdateProduct>((event, emit) async{
      emit(ProductUpdateLoading());
      final resp = await _updateProductUseCase(event.product);
      resp.fold((l) => emit(ProductsFailure()) , (r) => emit(UpdateProductSucces()));
    });


  }
}
