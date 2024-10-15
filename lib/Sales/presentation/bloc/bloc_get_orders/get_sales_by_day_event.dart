part of 'get_sales_by_day_bloc.dart';

@immutable
sealed class GetSalesByDayEvent {}

class GetSalesByDay extends GetSalesByDayEvent {
 final DateTime day;

  GetSalesByDay({required this.day});
}

class GetSaleByMonth extends GetSalesByDayEvent {

}