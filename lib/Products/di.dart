import 'package:mi_tiendita/Products/domain/use_case/get_product_by_barcode_usecase.dart';
import 'package:mi_tiendita/Products/domain/use_case/get_total_products_in_saleItem_usecase.dart';
import 'package:mi_tiendita/Products/presentation/bloc/get_product_by_barcode_bloc.dart';
import 'package:mi_tiendita/Products/presentation/bloc/get_total_products_in_saleitem_bloc_bloc.dart';
import 'package:mi_tiendita/Sales/domain/use_case/get_total_sale_by_day.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tiendita/Products/data/dataSorce/product_local_data_source.dart';
import 'package:mi_tiendita/Products/data/repository/products_repository_impl.dart';
import 'package:mi_tiendita/Products/domain/repository.dart';
import 'package:mi_tiendita/Products/domain/use_case/add_product.dart';
import 'package:mi_tiendita/Products/domain/use_case/delete_product.dart';
import 'package:mi_tiendita/Products/domain/use_case/get_products.dart';
import 'package:mi_tiendita/Products/domain/use_case/update_product.dart';
import 'package:mi_tiendita/Products/presentation/bloc/products_bloc.dart';

import 'package:mi_tiendita/Sales/data/dataDorce/sales_local_data_source.dart';
import 'package:mi_tiendita/Sales/domain/sales.repository.dart';
import 'package:mi_tiendita/Sales/domain/use_case/add_sale.dart';
import 'package:mi_tiendita/Sales/domain/use_case/get_sales.dart';
import 'package:mi_tiendita/Sales/presentation/bloc/sales/sales_bloc_bloc.dart';
import 'package:mi_tiendita/Ticket/Data/dataSource/ticket_local_data_source.dart';
import 'package:mi_tiendita/Ticket/Data/repository/ticket_repository_impl.dart';
import 'package:mi_tiendita/Ticket/Domain/ticket.repository.dart';
import 'package:mi_tiendita/Ticket/Presentation/Bloc/update_ticket_info_bloc_bloc.dart';
import 'package:mi_tiendita/core/utils/bluethoot_service.dart';
import 'package:mi_tiendita/expenses/data/dataSource/expense_local_datasorce.dart';
import 'package:mi_tiendita/expenses/domain/expense_repository.dart';

import '../Sales/data/repository/sales_repository_impl.dart';
import '../Sales/domain/use_case/get_sale_by_day.dart';
import '../Sales/domain/use_case/get_sale_by_month.dart';
import '../Sales/presentation/bloc/bloc_get_orders/get_sales_by_day_bloc.dart';
import '../Sales/presentation/bloc/metrics/metrics_bloc.dart';
import '../Ticket/Domain/use_case/get_info_ticket.dart';
import '../Ticket/Domain/use_case/update_info_ticket.dart';
import '../Ticket/Presentation/Bloc/add_info_ticket_bloc.dart';
import '../expenses/data/repository/expense_repository_implement.dart';
import '../expenses/domain/use_case/create_expense_use_case.dart';
import '../expenses/domain/use_case/delete_expense_by_id_use_case.dart';
import '../expenses/domain/use_case/get_expenses_use_case.dart';
import '../expenses/domain/use_case/get_total_expense_by_month_usecase.dart';
import '../expenses/presentation/block/delete_expense_by_id_bloc.dart';
import '../expenses/presentation/block/create_expense_bloc.dart';
import '../expenses/presentation/block/get_expense.dart';
import '../expenses/presentation/block/get_expenses_by_month_bloc.dart';

final di = GetIt.instance;

Future<void> init() async {
  di.registerSingleton<BluetoothService>(BluetoothService());

  //bloc   PRODUCTS
  di.registerFactory(() => ProductsBloc(di(), di(), di(), di()));
  di.registerFactory(() => GetProductByBarcodeBloc(di()));
  di.registerFactory(() => GetTotalProductsInSaleitemBlocBloc(di()));

  //useCase
  di.registerLazySingleton(() => GetProductsUseCase(repository: di()));
  di.registerLazySingleton(() => AddProductUseCase(repository: di()));
  di.registerLazySingleton(() => DeleteProductUseCase(repository: di()));
  di.registerLazySingleton(() => UpdateProductUseCase(repository: di()));
  di.registerLazySingleton(() => GetProductByBarcodeUsecase(repository: di()));
  di.registerLazySingleton(() => GetTotalProductsInSaleitemUsecase(repository: di()));

  //repository
  di.registerLazySingleton<ProductsRepository>(
      () => ProductsRepositoryImpl(productsLocalDataSource: di()));

  //data source
  di.registerLazySingleton<ProductsLocalDataSource>(
      () => ProductsLocalDataSourceImpl());

  //bloc SELLLS
  di.registerFactory(() => SalesBlocBloc(di(), di()));
  di.registerFactory(() => GetSalesByDayBloc(di()));
  di.registerFactory(() => MetricsBloc(di()));

  //useCase
  di.registerLazySingleton(() => AddSaleUseCase(repository: di()));
  di.registerLazySingleton(() => GetSaleUseCase(repository: di()));
  di.registerLazySingleton(() => GetSaleByDayUseCase(repository: di()));
  di.registerLazySingleton(() => GetSaleByMonthUseCase(repository: di()));
  di.registerLazySingleton(() => GetTotalSaleUseCase(repository: di()));

  //repository
  di.registerFactory<SalesRepository>(
      () => SaleRepositoryImpl(saleLocalDataSource: di()));

  //data source
  di.registerLazySingleton<SaleLocalDataSource>(
      () => SaleLocalDatasourceImpl());

  // block Ticket
  di.registerLazySingleton(() => AddInfoTicketBloc(di()));//este es el que obtiene la informacion osea el get 
  di.registerLazySingleton(() => UpdateTicketInfoBlocBloc(di()));//este es el que agrega o actualiza la informacion


  //useCase
  di.registerLazySingleton(() => UpdateInfoTicketUseCase(repository: di()));
  di.registerLazySingleton(() => GetInfoTicketUseCase(repository: di()));

  //repository
  di.registerLazySingleton<TicketRepository>(
      () => TicketRepositoryImpl(ticketLocalDataSource: di()));

  //data source
  di.registerLazySingleton<TicketLocalDataSource>(
      () => TicketLocalDataSourceImpl());

  //EXPENSES
  //bloc
  di.registerLazySingleton(() => GetExpensesBloc(di()));
  di.registerLazySingleton(() => CreateExpenseBloc(di()));
  di.registerLazySingleton(() => DeleteExpenseByIdBloc(di()));
  di.registerLazySingleton(() => GetTotalExpensesByMonthBloc(di()));

  //useCase
  di.registerLazySingleton(() => GetExpensesUseCase(repository: di()));
  di.registerLazySingleton(() => CreateExpenseUseCase(repository: di()));
  di.registerLazySingleton(() => DeleteExpenseByIdUseCase(repository: di()));
  di.registerLazySingleton(
      () => GetTotalExpenseByMonthUsecase(repository: di()));

  //repository
  di.registerLazySingleton<ExpenseRepository>(
      () => ExpenseRepositoryImplement(expenseLocalDatasorce: di()));

  //data source
  di.registerLazySingleton<ExpenseLocalDatasorce>(
      () => ExpenseLocalDatasorceImplement());
}
