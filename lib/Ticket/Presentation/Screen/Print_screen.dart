import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer_library.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tiendita/Ticket/Domain/ticket.entity.dart';
import 'package:mi_tiendita/core/utils/bluethoot_service.dart';

import '../Bloc/ticket_info/add_info_ticket_bloc.dart';

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
  @override
  void initState() {
    super.initState();
    context.read<AddInfoTicketBloc>().add(GetInfoTicket());
  }

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
        const SizedBox(
          height: 10,
        ),
        BlocConsumer<AddInfoTicketBloc, AddInfoTicketState>(
            listener: (context, state) => {},
            builder: (context, state) {
              if (state is GetInfoTicketLoading) {
                return const Text("Cargando configuracion");
              } else if (state is GetInfoTicketSuccess) {
                print(state.ticketEntity.companyName);
                 _controllerCompanyName.text = state.ticketEntity.companyName;
                return Form(
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
                                  label: Text("nombre de la compañia"),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(2))),
                                  helper: Text(
                                      "Agrega el nombre de tu empresa para que salga en el ticket")),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                context.read<AddInfoTicketBloc>().add(UpdateInfoTicket(ticketEntity: TicketEntity(companyName: _controllerCompanyName.text)));
                              },
                              child: const Text("Guardar Datos"))
                        ],
                      ),
                    ));
              } else {
                return const Text(
                    "A ocurrido un error mandanos correo a @ explicandonos tu problema para intentar solucionarlo");
              }
            }),
        ElevatedButton(
          child: const Text('Seleccionar e una impresora'),
          onPressed: () async {
            final device = await FlutterBluetoothPrinter.selectDevice(context);
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
    );
  }
}
