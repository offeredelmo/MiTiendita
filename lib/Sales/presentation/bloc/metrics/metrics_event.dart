part of 'metrics_bloc.dart';

@immutable
sealed class MetricsEvent {}


class GetMonthSales extends MetricsEvent {
  final DateTime month;

  GetMonthSales({required this.month});
}