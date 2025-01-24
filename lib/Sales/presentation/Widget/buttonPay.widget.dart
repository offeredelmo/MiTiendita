import 'dart:async';

import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tiendita/Sales/domain/sales.entity.dart';
import 'package:mi_tiendita/Sales/presentation/bloc/sales/sales_bloc_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_tiendita/core/utils/bluethoot_service.dart';

import '../../../Ticket/Presentation/Bloc/add_info_ticket_bloc.dart';

class ButtonPay extends StatefulWidget {
  final double totalSell;
  final List<SaleItem> listItem;

  const ButtonPay({
    super.key,
    required this.totalSell,
    required this.listItem,
  });

  @override
  State<ButtonPay> createState() => _ButtonPayState();
}

class _ButtonPayState extends State<ButtonPay> {
  List<SaleItem> filteredItems = [];
  
  void selectItems() {
    filteredItems = widget.listItem.where((item) => item.quantity > 0).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: ElevatedButton(
        onPressed: () {
          if (widget.listItem.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    "Selecciona al menos un producto para realizar la venta"),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            selectItems();
            confirmPay(context);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Pagar',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\$${widget.totalSell.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> confirmPay(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Para ajustar el modal al teclado
      builder: (BuildContext context) {
        return ConfirmPayModal(
          totalSell: widget.totalSell,
          listItem: filteredItems,
        );
      },
    );
  }
}

ReceiptController? controller;

class ConfirmPayModal extends StatefulWidget {
  final double totalSell;
  final List<SaleItem> listItem;

  const ConfirmPayModal({
    Key? key,
    required this.totalSell,
    required this.listItem,
  }) : super(key: key);

  @override
  _ConfirmPayModalState createState() => _ConfirmPayModalState();
}

class _ConfirmPayModalState extends State<ConfirmPayModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController controllerUserPay;
  double quantityUserPay = 0.0;

  @override
  void initState() {
    super.initState();
    controllerUserPay = TextEditingController();
  }

  @override
  void dispose() {
    controllerUserPay.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          MediaQuery.of(context).viewInsets, // Ajusta el padding al teclado
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Asigna la clave al Form
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Ajusta el tamaño según el contenido
              children: [
                const SizedBox(height: 20),
                Text(
                  "El total a pagar es de \$${widget.totalSell.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.99,
                  child: TextFormField(
                    controller: controllerUserPay,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Cantidad a pagar',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      // 1. Verificar si el valor es nulo o está vacíoFF
                      if (value == null || value.trim().isEmpty) {
                        return 'Este campo no puede estar vacío';
                      }

                      // 2. Intentar convertir el valor a double
                      final userPay = double.tryParse(value);
                      if (userPay == null) {
                        return 'Introduce un número válido';
                      }

                      // 3. Comparar el valor ingresado con el total a pagar
                      if (userPay < widget.totalSell) {
                        return 'Falta dinero para realizar la venta';
                      }

                      // 4. Si todo está bien, retornar null
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        quantityUserPay = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Cambio",
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 10),
                Text(
                  "\$${(quantityUserPay - widget.totalSell).toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: (quantityUserPay - widget.totalSell) >= 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final newOrder = SalesEntity(
                        id: "", // Asigna un ID único según tu lógica
                        saleDate: DateTime.now(),
                        items: widget.listItem,
                        totalsale: widget.totalSell,
                      );
                      final BluetoothService bluetoothService =
                          GetIt.instance<BluetoothService>();
                      print(bluetoothService.device);
                      if (bluetoothService.device != null) {
                        _dialogBuilder(
                            context,
                            widget.listItem,
                            widget.totalSell,
                            double.tryParse(controllerUserPay.text) ?? 0.0);
                        BlocProvider.of<SalesBlocBloc>(context)
                            .add(AddSales(salesEntity: newOrder));
                      } else {
                        BlocProvider.of<SalesBlocBloc>(context)
                            .add(AddSales(salesEntity: newOrder));
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Text('Confirmar Pago'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget ticket(BuildContext context, List<SaleItem> sale, double total,
    double pay, String companyName, String address) {
  final dateNow = DateTime.now();
  return Receipt(
    builder: (context) =>
        Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(companyName, style: const TextStyle(fontSize: 24))],
      ),
      const SizedBox(height: 10),
      Text(
        address,
        style: TextStyle(fontSize: 24),
      ),
      Text('Fecha: ${dateNow.year}/${dateNow.month}/${dateNow.day}',
          style: const TextStyle(fontSize: 24)),
      const Text('------------------------', style: TextStyle(fontSize: 24)),
      const Text("Lista de productos", style: TextStyle(fontSize: 24)),
      for (final item in sale)
        Row(
          children: [
            Text(
                "${item.product.name}:\n${item.quantity} x ${item.product.price} = ${item.product.price * item.quantity}",
                style: const TextStyle(fontSize: 24)),
          ],
        ),
      const SizedBox(
        height: 10,
      ),
      Text("Total: $total", style: const TextStyle(fontSize: 24)),
      Text("Recibo: $pay", style: const TextStyle(fontSize: 24)),
      Text("Cambio: ${pay - total}", style: const TextStyle(fontSize: 24))
    ]),
    onInitialized: (ReceiptController controllerr) {
      controller = controllerr;
    },
  );
}

Future<void> _dialogBuilder(
    BuildContext context, List<SaleItem> sale, double totalSale, double pay) {
  final BluetoothService bluetoothService = GetIt.instance<BluetoothService>();
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Deseas Imprimir el ticket'),
        content: BlocBuilder<AddInfoTicketBloc, AddInfoTicketState>(
            builder: (context, state) {
          if (state is GetInfoTicketLoading) {
            return const Text("Elaborando Ticket....");
          } else if (state is GetInfoTicketSuccess) {
            return SizedBox(
              height: 200,
              child: Column(
                children: [
                  const Text(
                      'Si quieres imprimir el ticket dale click a IMPRIMIR\n'
                      '\n'
                      'Si no deseas imprimir el ticket dale click a NO IMPRIMIR\n'),
                  SizedBox(
                    height: 1,
                    child: ticket(
                        context,
                        sale,
                        totalSale,
                        pay,
                        state.ticketEntity.companyName,
                        state.ticketEntity.companyAddress),
                  )
                ],
              ),
            );
          } else {
            return const Text("Lo siento no fue posible imprimir el ticket");
          }
        }),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('No imprimir'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Imprimir'),
            onPressed: () async {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              if (controller != null) {
                try {
                  await controller!
                      .print(address: bluetoothService.device!.address);
                } catch (e) {}
              } else {}
            },
          ),
        ],
      );
    },
  );
}
