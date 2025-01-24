import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mi_tiendita/Products/domain/entities.dart';
import 'package:mi_tiendita/Products/domain/use_case/get_product_by_barcode_usecase.dart';

class GetProductByBarcodeBloc
    extends Bloc<GetProductByBarcodeEvent, GetProductByBarcodeState> {
  final GetProductByBarcodeUsecase getProductByBarcodeUsecase;

  GetProductByBarcodeBloc(this.getProductByBarcodeUsecase)
      : super(GetProductByBarcodeInitial()) {
    on<GetProductByBarcodeEvent>((event, emit) async{
      print(
        "soy el bloc y me estoy ejecutando como loco why ?"
      );
      emit(GetProductByBarcodeLoading());
      final resp = await getProductByBarcodeUsecase(event.barcode);
      resp.fold((l) => emit(GetProductByBarcodeFailure()), ((r) => emit(GetProductByBarcodeSucces(product: r))));
    });
  }
}

class GetProductByBarcodeEvent {
  final String barcode;

  GetProductByBarcodeEvent({required this.barcode});
}

@immutable
sealed class GetProductByBarcodeState {}

final class GetProductByBarcodeInitial extends GetProductByBarcodeState {}

final class GetProductByBarcodeLoading extends GetProductByBarcodeState {}

final class GetProductByBarcodeFailure extends GetProductByBarcodeState {}

final class GetProductByBarcodeSucces extends GetProductByBarcodeState {
  final Product product;

  GetProductByBarcodeSucces({required this.product});
}
