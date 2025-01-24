import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mi_tiendita/Products/domain/use_case/get_total_products_in_saleItem_usecase.dart';
import 'package:mi_tiendita/Sales/domain/sales.entity.dart';

class GetTotalProductsInSaleitemBlocBloc extends Bloc<
    GetTotalProductsInSaleitemBlocEvent, GetTotalProductsInSaleitemBlocState> {
  final GetTotalProductsInSaleitemUsecase getTotalProductsInSaleitemUsecase;

  GetTotalProductsInSaleitemBlocBloc(this.getTotalProductsInSaleitemUsecase)
      : super(GetTotalProductsInSaleitemBlocInitial()) {
    on<GetTotalProductsInSaleitemBlocEvent>((event, emit) async {
      emit(GetTotalProductsInSaleitemBlocLoading());
      final response = await getTotalProductsInSaleitemUsecase();
      response.fold((l) => emit(GetTotalProductsInSaleitemBloFailure()), (r) => emit(GetTotalProductsInSaleitemBlocSuccess(listSaleItem: r)));
    });
  }
}

class GetTotalProductsInSaleitemBlocEvent {}

@immutable
sealed class GetTotalProductsInSaleitemBlocState {}

final class GetTotalProductsInSaleitemBlocInitial
    extends GetTotalProductsInSaleitemBlocState {}

final class GetTotalProductsInSaleitemBlocLoading
    extends GetTotalProductsInSaleitemBlocState {}

final class GetTotalProductsInSaleitemBlocSuccess
    extends GetTotalProductsInSaleitemBlocState {
  final List<SaleItem> listSaleItem;

  GetTotalProductsInSaleitemBlocSuccess({required this.listSaleItem});
}

final class GetTotalProductsInSaleitemBloFailure
    extends GetTotalProductsInSaleitemBlocState {}
