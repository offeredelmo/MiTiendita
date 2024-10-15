import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/use_case/get_sale_by_month.dart';

part 'metrics_event.dart';
part 'metrics_state.dart';

class MetricsBloc extends Bloc<MetricsEvent, MetricsState> {
  final GetSaleByMonthUseCase getSaleByMonthUseCase;

  MetricsBloc(this.getSaleByMonthUseCase) : super(MetricsInitial()) {
    on<GetMonthSales>((event, emit) async {
      emit(SalesGetMonthSalesLoading());
      final resp = await getSaleByMonthUseCase(event.month);
      resp.fold(
        (l) => emit(SalesGetMonthSalesFailure()),
        (r) => emit(SalesGetMonthSalesSucces(r)),
      );
    });
  }
}
