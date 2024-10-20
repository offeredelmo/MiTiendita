import 'package:bloc/bloc.dart';
import 'package:mi_tiendita/Sales/domain/sales.entity.dart';
import 'package:mi_tiendita/Sales/domain/use_case/add_sale.dart';
import 'package:mi_tiendita/Sales/domain/use_case/get_total_sale_by_day.dart';
import 'package:meta/meta.dart';


part 'sales_bloc_event.dart';
part 'sales_bloc_state.dart';

class SalesBlocBloc extends Bloc<SalesBlocEvent, SalesBlocState> {
  final AddSaleUseCase addSaleUseCase;

  final GetTotalSaleUseCase getTotalSaleUseCase;

  SalesBlocBloc(this.addSaleUseCase, this.getTotalSaleUseCase)
      : super(SalesBlocInitial()) {
    on<AddSales>((event, emit) async {
      emit(SalesAddLoading());
      final resp = await addSaleUseCase(event.salesEntity);
      resp.fold((l) => emit(SalesAddFailure()), (r) => emit(SalesAddSucces()));
    });

    on<GetTotalSales>((event, emit) async {
      emit(SalesGetTotalSalesLoading());
      final resp = await getTotalSaleUseCase(event.day);
      resp.fold(
        (l) => emit(SalesGetTotalSalesFailure()),
        (r) => emit(SalesGetTotalSalesSucces(r)),
      );
    });
  }
}
