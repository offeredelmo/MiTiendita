import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer_library.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tiendita/core/utils/bluethoot_service.dart';

class PrintScreen extends StatelessWidget {
  const PrintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuracion de la impresora"),
      ),
      body: BodyPrintScreen(),
    );
  }
}

class BodyPrintScreen extends StatefulWidget {
  BodyPrintScreen({
    super.key,
  });

  @override
  State<BodyPrintScreen> createState() => _BodyPrintScreenState();
}

class _BodyPrintScreenState extends State<BodyPrintScreen> {
  final _printconfig = GlobalKey<FormState>();

  final TextEditingController _controllerCompanyName = TextEditingController();

  final focusNode = FocusNode();

  final BluetoothService bluetoothService = GetIt.instance<BluetoothService>();


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: const Text(
                "En este apartado podras conectarte a tu impresora y agregar el nombre de tu empresa para que aparesca en el ticket. Recuerda tus ticket se imprimiran automaticamente al realizar la venta, o puedes imprimirlos desde el historial de ventas",
                textAlign: TextAlign.center),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Form(
            key: _printconfig,
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      controller: _controllerCompanyName,
                      onTapOutside: (event) {
                        focusNode.unfocus();
                      },
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                          label: Text("Nombre de la empresa"),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2))),
                          helper: Text(
                              "Agrega el nombre de tu empresa para que salga en el ticket")),
                    ),
                  ),
                  ElevatedButton(
                child: const Text('Seleccionar e una impresora'),
                onPressed: () async {
                  final device =
                      await FlutterBluetoothPrinter.selectDevice(context);
                  if (device != null) {
                    setState(() {
                      bluetoothService.setDevice(device);
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              Text(
                "Impresora conectada: ${bluetoothService.device?.name ?? 'Ninguna'}",
              ),
                ],
              ),
            )),
      ],
    );
  }
}
