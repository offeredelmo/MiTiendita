import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tiendita/Sales/domain/sales.entity.dart';
import 'package:mi_tiendita/Sales/presentation/bloc/sales/sales_bloc_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_tiendita/core/utils/bluethoot_service.dart';

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
          listItem: widget.listItem,
        );
      },
    );
  }
}

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
  ReceiptController? controller;
  final BluetoothService bluetoothService = GetIt.instance<BluetoothService>();

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
                      // 1. Verificar si el valor es nulo o está vacío
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

                      BlocProvider.of<SalesBlocBloc>(context)
                          .add(AddSales(salesEntity: newOrder));

                      if (bluetoothService.device?.address == null) {
                        print(
                            'La dirección del dispositivo es nula. No se puede imprimir.');
                      } else {
                        print(bluetoothService.device!.address);
                        controller?.print(
                            address: bluetoothService.device!.address);
                      }

                      Navigator.pop(context); // Cerrar el modal

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Venta realizada con éxito. Cambio: \$${(quantityUserPay - widget.totalSell).toStringAsFixed(2)}'),
                          backgroundColor: Colors.green,
                        ),
                      );
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

Widget build(BuildContext context, SalesEntity sale) {
  ReceiptController? controller;
  double printerWidth = 58 * 2.83465; // configuracion de la impresora 
   
  return Receipt(
    builder: (context) => Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Nombre de la empresa")],
        ),
        const SizedBox(height: 10),
        const Text('Direccion: Primera oriente numero 12'),
        Text('Fecha: ${DateTime.now()}'),
        const Text('--------------------------'),
        Text("Cantidad -- Producto      -- PRE.UNIT --  Total "),
        for (final item in sale.items)
          Row(
            children: [
              SizedBox(child: Text("${item.quantity}")),
              Text("${item.product.name}"),
              Text("${item.product.price}" ),
            ],
          )
      ],
    ),
    onInitialized: (ctrl) {
      controller = ctrl;
    },
  );
}
