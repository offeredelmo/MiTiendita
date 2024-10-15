import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/sales.entity.dart';
import '../../../domain/use_case/get_sale_by_day.dart';

part 'get_sales_by_day_event.dart';
part 'get_sales_by_day_state.dart';

class GetSalesByDayBloc extends Bloc<GetSalesByDayEvent, GetSalesByDayState> {
  final GetSaleByDayUseCase getSaleByDayUseCase;

  GetSalesByDayBloc(this.getSaleByDayUseCase) : super(GetSalesByDayInitial()) {
    on<GetSalesByDay>((event, emit) async {
      emit(SalesGetSalesByDayLoading());
      final resp = await getSaleByDayUseCase(event.day);
      resp.fold(
        (l) => emit(SalesGetSalesByDayFailure()),
        (r) => emit(SalesGetSalesByDaySucces(r)),
      );
    });
  }
}
