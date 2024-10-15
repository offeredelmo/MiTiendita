part of 'get_sales_by_day_bloc.dart';

@immutable
sealed class GetSalesByDayState {}

final class GetSalesByDayInitial extends GetSalesByDayState {}




final class SalesGetSalesByDayLoading extends GetSalesByDayState {}

final class SalesGetSalesByDaySucces extends GetSalesByDayState {
  final List<SalesEntity> sales;

  SalesGetSalesByDaySucces(this.sales);
}

final class SalesGetSalesByDayFailure extends GetSalesByDayState {}

