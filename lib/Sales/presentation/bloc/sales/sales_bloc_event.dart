part of 'sales_bloc_bloc.dart';

@immutable
sealed class SalesBlocEvent {}

class AddSales extends SalesBlocEvent {
  final SalesEntity salesEntity;

  AddSales({required this.salesEntity});
  
}

class GetSales extends SalesBlocEvent {
  
}



class GetTotalSales extends SalesBlocEvent {
  final DateTime day;

  GetTotalSales({required this.day});
}


