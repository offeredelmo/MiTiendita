part of 'metrics_bloc.dart';

@immutable
sealed class MetricsState {}

final class MetricsInitial extends MetricsState {}



final class SalesGetMonthSalesLoading extends MetricsState {}

final class SalesGetMonthSalesSucces extends MetricsState {
  final List<double> totalSales;

  SalesGetMonthSalesSucces(this.totalSales);
}

final class SalesGetMonthSalesFailure extends MetricsState {}