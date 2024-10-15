import 'package:flutter/material.dart';
import 'package:mi_tiendita/Sales/domain/sales.entity.dart';
import 'package:mi_tiendita/Sales/presentation/bloc/sales/sales_bloc_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc_get_orders/get_sales_by_day_bloc.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis ventas'),
      ),
      body: SaleScreenBody(),
    );
  }
}

class SaleScreenBody extends StatefulWidget {
  const SaleScreenBody({
    super.key,
  });

  @override
  State<SaleScreenBody> createState() => _SaleScreenBodyState();
}

class _SaleScreenBodyState extends State<SaleScreenBody> {
  @override
  void initState() {
    super.initState();
    context.read<GetSalesByDayBloc>().add(GetSalesByDay(day: DateTime.now()));
  }

  DateTime? _selectedDate;

  // Función para mostrar el DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Fecha inicial (actual)
      firstDate: DateTime(2024), // Fecha mínima
      lastDate: DateTime(2030), // Fecha máxima
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate; // Almacenar la fecha seleccionada
        context.read<GetSalesByDayBloc>().add(GetSalesByDay(day: pickedDate));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime lastDay = DateTime.now().subtract(Duration(days: 1));

    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  child: const Text("HOY"),
                  onPressed: () {
                    setState(() {
                      _selectedDate = null;
                      context
                          .read<GetSalesByDayBloc>()
                          .add(GetSalesByDay(day: DateTime.now()));
                    });
                  }),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  child: const Text("AYER"),
                  onPressed: () {
                    setState(() {
                      _selectedDate = null;
                      context
                          .read<GetSalesByDayBloc>()
                          .add(GetSalesByDay(day: lastDay));
                    });
                  }),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: () => _selectDate(
                      context), // Llamar a la función para seleccionar la fecha
                  child: _selectedDate != null
                      ? Text(
                          "${_selectedDate?.month} / ${_selectedDate?.day} / ${_selectedDate?.year}")
                      : Icon(Icons.date_range_rounded)),
            ],
          ),
          BlocConsumer<GetSalesByDayBloc, GetSalesByDayState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is SalesGetSalesByDayLoading) {
                  return const Text("Cargando");
                } else if (state is SalesGetSalesByDaySucces) {
                  return CustomCardOrder(ejemploVenta: state.sales);
                } else {
                  return const Text("A ocurrido un error intenta de nuevo");
                }
              }),
        ],
      ),
    );
  }
}

class CustomCardOrder extends StatelessWidget {
  const CustomCardOrder({
    super.key,
    required this.ejemploVenta,
  });

  final List<SalesEntity> ejemploVenta;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
      itemCount: ejemploVenta.length,
      itemBuilder: (context, index) {
        final SalesEntity order = ejemploVenta[index];
        return Card(
          child: ExpansionTile(
              title: Text("Venta total de ${order.totalsale}"),
              subtitle: Text(
                  'Realizada a las ${order.saleDate.hour} : ${order.saleDate.minute}'),
              leading: const Icon(Icons.sell),
              children: [
                ListView.builder(
                  shrinkWrap: true, // Ajusta el tamaño de la lista al contenido
                  physics:
                      NeverScrollableScrollPhysics(), // Deshabilita el desplazamiento independiente
                  itemCount: order.items.length,
                  itemBuilder: (context, itemIndex) {
                    final SaleItem item = order.items[itemIndex];
                    return ListTile(
                      leading: Icon(Icons.shopping_cart),
                      title: Text("${item.product.name}"),
                      subtitle: Text(
                          "Cantidad: ${item.quantity} × \$${item.product.price.toStringAsFixed(2)}"),
                      trailing: Text(
                          "\$${(item.product.price * item.quantity).toStringAsFixed(2)}"),
                    );
                  },
                ),
              ]),
        );
      },
    ));
  }
}
