import 'package:flutter/material.dart';
import 'package:mi_tiendita/Products/data/models/product_model.dart';
import 'package:mi_tiendita/Sales/data/models/sele_model.dart';
import 'package:mi_tiendita/Sales/presentation/Screens/Sell.dart';
import 'package:mi_tiendita/Sales/presentation/Screens/metrics.dart';
import 'package:mi_tiendita/Sales/presentation/Screens/sales.dart';
import 'package:mi_tiendita/Sales/presentation/bloc/sales/sales_bloc_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mi_tiendita/Products/di.dart';
import 'package:mi_tiendita/Products/presentation/bloc/products_bloc.dart';

import 'Products/presentation/screens/Home.dart';
import 'Products/presentation/screens/Products.dart';
import 'Sales/presentation/bloc/bloc_get_orders/get_sales_by_day_bloc.dart';


import 'Sales/presentation/bloc/metrics/metrics_bloc.dart';

void main() async {
  await init();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductDtoAdapter());
  Hive.registerAdapter(SaleItemDtoAdapter());
  Hive.registerAdapter(SaleDtoAdapter());
  MobileAds.instance.initialize(); // Inicializa AdMob
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetIt.instance.get<ProductsBloc>()),
        BlocProvider(create: (_) => GetIt.instance.get<SalesBlocBloc>()),
        BlocProvider(create: (_) => GetIt.instance.get<GetSalesByDayBloc>()),
        BlocProvider(create: (_) => GetIt.instance.get<MetricsBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          "/": (context) => const MyHomePage(),
          "/products": (context) => const Products(),
          "/sell": (context) => const SellScreen(),
          "/sales": (context) => const SalesScreen(),
          "/metrics": (context) => const Metrics()
        },
      ),
    );
  }
}
