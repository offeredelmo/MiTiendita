import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';
import 'package:get_it/get_it.dart';
import 'package:mi_tiendita/Sales/presentation/bloc/sales/sales_bloc_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mi_tiendita/Products/domain/entities.dart';
import 'package:mi_tiendita/Products/presentation/bloc/products_bloc.dart';
import 'package:mi_tiendita/core/utils/bluethoot_service.dart';
import 'package:mi_tiendita/expenses/presentation/block/get_expenses_by_month_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  BluetoothDevice? actualDevice;
  final BluetoothService bluetoothService = GetIt.instance<BluetoothService>();

  @override
  void initState() {
    super.initState();
    context.read<SalesBlocBloc>().add(GetTotalSales(day: DateTime.now()));
    context.read<GetTotalExpensesByMonthBloc>().add(GetExpensesByMonthEvent(
        date: DateTime.now())); // Inicia la petición de gastos

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-2901258575619881/7507827726', // Tu Ad Unit ID aquí
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  //Metodos para obtener el gasto total del mes
  DateTime actuallyMonth = DateTime.now();
  decrementMoth(DateTime date) {
    actuallyMonth = actuallyMonth.month - 1 == 0
        ? DateTime(actuallyMonth.year - 1, 12)
        : DateTime(actuallyMonth.year, actuallyMonth.month - 1);
    context
        .read<GetTotalExpensesByMonthBloc>()
        .add(GetExpensesByMonthEvent(date: actuallyMonth));
    setState(() {});
  }

  incrementMoth(DateTime date) {
    actuallyMonth = actuallyMonth.month + 1 == 13
        ? DateTime(actuallyMonth.year + 1, 1)
        : DateTime(actuallyMonth.year, actuallyMonth.month + 1);
    context
        .read<GetTotalExpensesByMonthBloc>()
        .add(GetExpensesByMonthEvent(date: actuallyMonth));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => context.read<ProductsBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mi tiendita"),
          actions: [
            ValueListenableBuilder<bool>(
              valueListenable: bluetoothService.isConnectedNotifier,
              builder: (context, isConnected, child) {
                return IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/print');
                    },
                    icon: bluetoothService.device != null
                        ? Icon(
                            Icons.print,
                            color: Colors.green,
                          )
                        : Icon(
                            Icons.print_disabled,
                            color: Colors.red,
                          ));
              },
            )
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: _bannerAd.size.height.toDouble()),
                child: Column(
                  children: [
                    //BOTTON PARA REALIZAR UNA VENTA
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 50,
                      child: ElevatedButton(
                          child: const Text("Realizar una venta"),
                          onPressed: () {
                            Navigator.pushNamed(context, '/sell');
                          }),
                    ),
                    const SizedBox(height: 10),
                    //BOTTON PARA VER LAS VENTAS
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 50,
                      child: ElevatedButton(
                          child: const Text("Ver mis ventas"),
                          onPressed: () {
                            Navigator.pushNamed(context, '/sales');
                          }),
                    ),
                    const SizedBox(height: 10),
                    //BOTTON PARA VER LAS VENTAS MENSUALES
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 50,
                      child: ElevatedButton(
                          child: const Text("Venta mensual"),
                          onPressed: () {
                            Navigator.pushNamed(context, '/metrics');
                          }),
                    ),
                    const SizedBox(height: 20),
                    //WIDGET PARA VER LA VENTA TOTAL DEL DIA
                    CardViewTotalSellToDay(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 50,
                      child: ElevatedButton(
                          child: const Text("Agregar un nuevo producto"),
                          onPressed: () {
                            _modalAddProduct(context);
                          }),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 50,
                      child: ElevatedButton(
                          child: const Text("Ver mis productos"),
                          onPressed: () {
                            Navigator.pushNamed(context, '/products');
                          }),
                    ),
                    const SizedBox(height: 10),
                    Text("Gastos"),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 50,
                      child: ElevatedButton(
                          child: const Text("Ver mis gastos"),
                          onPressed: () {
                            Navigator.pushNamed(context, '/expenses');
                          }),
                    ),
                    const SizedBox(height: 10),

                    //WIDGET PARA VER EL GASTO TOTAL DEL MES
                    CardViewTotalExpensByMonth(
                      decrementMoth: decrementMoth,
                      incrementMoth: incrementMoth,
                      actuallyMonth: actuallyMonth,
                    ),
                    //Final
                    // const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
            // Banner publicitario superpuesto
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white,
                width: _bannerAd.size.width.toDouble(),
                height: _bannerAd.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _modalAddProduct(BuildContext context) {
    File? _selectedImage;
    String _productName = '';
    double _price = 0.0;
    int _quantity = 0;
    String _barCode = "";

    final _addProduct = GlobalKey<FormState>();
    Future<void> _pickImage() async {
      final imagePicker = ImagePicker();
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    }

    return showModalBottomSheet(
      isScrollControlled: true, // Esto permite controlar la altura del modal
      context: context,
      builder: (BuildContext context) {
        return BlocListener<ProductsBloc, ProductsState>(
          listener: (context, state) {
            if (state is ProductAddLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Se está agregando el producto..."),
                  duration: Duration(milliseconds: 900),
                ),
              );
            }
            if (state is ProductsSucces) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("El producto se ha agregado exitosamente."),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(
                  context); // Cierra el modal después de agregar exitosamente
            }
            if (state is ProductsAddFailure) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Ha ocurrido un error. ${state.message}"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Padding(
            padding: MediaQuery.of(context)
                .viewInsets, // Ajusta el padding al teclado
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _addProduct,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 30),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            helperText: "necesario",
                            labelText: "Nombre del producto",
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "por favor ingresa un nombre";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _productName = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.425,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                helperText: "necesario",
                                labelText: "Precio",
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Ingresa el precio";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _price = double.tryParse(value) ?? 0.0;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.425,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Cantidad",
                                helperText: "Opccional",
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _quantity = int.tryParse(value) ?? 0;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Codigo de barras",
                              helperText: "Opcional"),
                          onChanged: (value) {
                            setState(() {
                              _barCode = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 50,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: _selectedImage != null
                                ? Image.file(_selectedImage!, fit: BoxFit.cover)
                                : const Center(
                                    child: Icon(Icons.add_a_photo,
                                        size: 50, color: Colors.grey),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
                          if (_addProduct.currentState!.validate()) {
                            final newProduct = Product(
                                id: "",
                                name: _productName,
                                price: _price,
                                stock: _quantity,
                                img_url: _selectedImage?.path.toString() ?? "",
                                barCode: _barCode ?? "");

                            BlocProvider.of<ProductsBloc>(context)
                                .add(AddProducts(product: newProduct));
                          } else {}
                        },
                        child: const Text('Guardar Producto'),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancelar"))
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CardViewTotalExpensByMonth extends StatelessWidget {
  CardViewTotalExpensByMonth({
    super.key,
    required this.decrementMoth,
    required this.incrementMoth,
    required this.actuallyMonth,
  });
  final Function(DateTime) decrementMoth;
  final Function(DateTime) incrementMoth;
  final DateTime actuallyMonth;
  final List<String> months = [
    "Enero",
    "Febrero",
    "Marzo",
    "Abril",
    "Mayo",
    "Junio",
    "Julio",
    "Agosto",
    "Septiembre",
    "Octubre",
    "Noviembre",
    "Diciembre"
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetTotalExpensesByMonthBloc, GetExpensesByMonthState>(
      builder: (context, state) {
        String? response;

        if (state is GetTotalExpensesByMonthLoading) {
          response = "Calculando gastos...";
        }
        if (state is GetTotalExpensesByMonthSuccess) {
          response = state.expenses.toString();
        }
        if (state is GetTotalExpensesByMonthError) {
          response = "Error al obtener gastos.";
        }
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 100,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          decrementMoth(actuallyMonth);
                        },
                        icon: Icon(Icons.arrow_back_rounded)),
                    Text(
                        "${months[actuallyMonth.month - 1]} - ${actuallyMonth.year}"),
                    IconButton(
                        onPressed: () {
                          incrementMoth(actuallyMonth);
                        },
                        icon: Icon(Icons.arrow_forward_rounded)),
                  ],
                ),
                Text("Total gastado : ${response}"),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CardViewTotalSellToDay extends StatelessWidget {
  const CardViewTotalSellToDay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesBlocBloc, SalesBlocState>(
        builder: (context, state) {
      String totalSalesText = "Cargando...";
      if (state is SalesGetTotalSalesSucces) {
        totalSalesText = "Venta total: ${state.totalSales}";
      } else if (state is SalesGetTotalSalesFailure) {
        totalSalesText = "Error al obtener ventas totales.";
      }
      return Center(
        child: Column(
          children: [
            // ... (Otros widgets como botones)
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 80,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "Fecha: ${DateTime.now().month} / ${DateTime.now().day} / ${DateTime.now().year}"),
                    Text(totalSalesText),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
