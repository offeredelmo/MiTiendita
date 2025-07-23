import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer_library.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tiendita/Ticket/Domain/ticket.entity.dart';
import 'package:mi_tiendita/Ticket/Presentation/Bloc/update_ticket_info_bloc_bloc.dart';
import 'package:mi_tiendita/core/utils/bluethoot_service.dart';

import '../Bloc/add_info_ticket_bloc.dart';

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
  final TextEditingController _controllerAddress = TextEditingController();

  final focusNodecompanyName = FocusNode();
  final focusNodecompanyAddress = FocusNode();

  final BluetoothService bluetoothService = GetIt.instance<BluetoothService>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            "Instrucciones para conecta la impresora",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                    "1. Dirígete a Configuraciones en tu teléfono e ingresa a Bluetooth."),
                SizedBox(
                  height: 5,
                ),
                Text("2.Busca tu impresora POS y conéctala."),
                SizedBox(
                  height: 5,
                ),
                Text(
                    "3. Recuerda agregar el nombre de tu negocio para que se muestre en el ticket."),
                SizedBox(
                  height: 5,
                ),
                Text(
                    "4.Agrega la dirección del negocio   para que aparezca en el ticket."),
                SizedBox(
                  height: 5,
                ),
                Text(
                    '5. Por último, da clic en "Seleccionar una impresora" y conecta tu impresora.'),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          BlocConsumer<AddInfoTicketBloc, AddInfoTicketState>(
              listener: (context, state) => {},
              builder: (context, state) {
                print("STATE: $state");
                if (state is GetInfoTicketLoading) {
                  return const Text("Cargando configuracion");
                } else if (state is GetInfoTicketSuccess) {
                  _controllerCompanyName.text = state.ticketEntity.companyName;
                  _controllerAddress.text = state.ticketEntity.companyAddress;
                  return Form(
                      key: _printconfig,
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Column(
                                  children: [
                                    //INPUT PARA EL NOMBRE DE LA EMPRESA
                                    TextFormField(
                                      controller: _controllerCompanyName,
                                      onTapOutside: (event) {
                                        focusNodecompanyName.unfocus();
                                      },
                                      focusNode: focusNodecompanyName,
                                      decoration: const InputDecoration(
                                          label: Text("Nombre del negocio"),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2))),
                                          helper: Text(
                                              "Agrega el nombre de tu negocio")),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),

                                    //INPUT PARA LA DIRECCION DE LA EMPRESA
                                    TextFormField(
                                      controller: _controllerAddress,
                                      onTapOutside: (event) {
                                        focusNodecompanyAddress.unfocus();
                                      },
                                      focusNode: focusNodecompanyAddress,
                                      decoration: const InputDecoration(
                                          label: Text("Direccion del negocio"),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2))),
                                          helper: Text(
                                              "Agrega la direccion del negocio")),
                                    ),
                                  ],
                                )),
                            const SizedBox(height: 10),
                            //BOTON PARA GUARDAR LOS DATOS
                            ElevatedButton(
                                onPressed: () {
                                  final infoTicket = TicketEntity(
                                      companyName: _controllerCompanyName.text,
                                      companyAddress: _controllerAddress.text);
                                  BlocProvider.of<UpdateTicketInfoBlocBloc>(
                                          context)
                                      .add(UpdateTicketInfoBlocEvent(
                                          ticketEntity: infoTicket));
                                },
                                child: const Text(
                                    "Guardar Informacion del negocio"))
                          ],
                        ),
                      ));
                } else {
                  return const Text(
                      "A ocurrido un error mandanos correo a @ explicandonos tu problema para intentar solucionarlo");
                }
              }),
          BlocListener<UpdateTicketInfoBlocBloc, UpdateTicketInfoBlocState>(
              listener: (context, state) {
                print("holaaaa soy el estado de actualizaciopn ${state}");
            if (state is UpdateTicketInfoBlocLoading) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Actualizando la informacion...."), duration: Duration(milliseconds: 950),));
            }
            if (state is UpdateTicketInfoBlocSucces) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("La informacion se a actualizado exitosamente"),
                  backgroundColor: Colors.green,
                ),
              );
            }
            if (state is UpdateTicketInfoBlocFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(    
                      "A ocurrido un error, no se pudo actualizar la informacion, intenta de nuevo, si no contactanos"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const Text(""),),
          const SizedBox(height: 15),

          //BOTON PARA CONECTAR LA IMPRESORA
          ElevatedButton(
            child: const Text('Seleccionar una impresora'),
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
