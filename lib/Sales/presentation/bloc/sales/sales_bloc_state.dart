part of 'sales_bloc_bloc.dart';

@immutable
sealed class SalesBlocState {}

final class SalesBlocInitial extends SalesBlocState {}

final class SalesAddLoading extends SalesBlocState {}

final class SalesAddSucces extends SalesBlocState {}

final class SalesAddFailure extends SalesBlocState {}

// -----

final class SalesGetTotalSalesLoading extends SalesBlocState {}

final class SalesGetTotalSalesSucces extends SalesBlocState {
  final double totalSales;

  SalesGetTotalSalesSucces(this.totalSales);
}

final class SalesGetTotalSalesFailure extends SalesBlocState {}

// -------
