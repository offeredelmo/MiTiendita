import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_tiendita/Products/presentation/bloc/get_product_by_barcode_bloc.dart';
import 'package:mi_tiendita/Sales/domain/sales.entity.dart';
import 'package:mi_tiendita/Sales/presentation/Widget/buttonPay.widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import '../../../Products/presentation/bloc/get_total_products_in_saleitem_bloc_bloc.dart';
import '../bloc/sales/sales_bloc_bloc.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  @override
  void initState() {
    super.initState();
    setState(() {
      context
          .read<GetTotalProductsInSaleitemBlocBloc>()
          .add(GetTotalProductsInSaleitemBlocEvent());
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  String? _lastBarcode;
  DateTime? _lastScaneedTime;
  //FUNCION PARA ABRIR LA CAMARA Y ESCANEAR BARCODES
  Future<void> startBarcodeScanStream() async {
    //Buscar el elemento por el barcode
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) {
      if (!mounted) return;

      final now = DateTime.now();

      //VALIDAR SI EL BARCODE FUE ESCANEADO RECIENTEMENTE
      if (_lastBarcode == barcode &&
          _lastScaneedTime != null &&
          now.difference(_lastScaneedTime!).inSeconds < 3) {
        //nadota que ya leyo el codigo mil veces paaaaa
        return;
      }

      _lastBarcode = barcode;
      _lastScaneedTime = now;

      if (barcode == '-1') {
        setState(() {});
      } else {
        context.read<GetProductByBarcodeBloc>().add(
              GetProductByBarcodeEvent(barcode: barcode),
            );
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi tiendita"),
        actions: [
          IconButton(
              onPressed: () async {
                await startBarcodeScanStream();
              },
              icon: const Icon(Icons.document_scanner_outlined))
        ],
      ),
      body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: BodySell()),
    );
  }
}

class BodySell extends StatefulWidget {
  BodySell({super.key});

  @override
  State<BodySell> createState() => _BodySellState();
}

class _BodySellState extends State<BodySell> {
  double totalSell = 0;
  final TextEditingController _searchController = TextEditingController();

  List<SaleItem> filteredProducts = [];
  List<SaleItem> allProducts = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

//FUNCION PARA OBTENER EL TOTAL DE LA VENTA
  void _totalSell() {
    setState(() {
      totalSell = allProducts.fold(
          0, (total, item) => total + (item.product.price * item.quantity));
    });
  }

  void _onOrderChanged() {
    _totalSell();
  }

  void restart() {
    allProducts = [];
    filteredProducts = [];
  }

  //FUNCION PARA FILTRAR LOS PRODUCTOS POR EL BUSCADOR
  void _onSearchChanged() {
    setState(() {
      filteredProducts = allProducts
          .where((product) => product.product.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SalesBlocBloc, SalesBlocState>(
        listener: (context, state) {
          if (state is SalesAddSucces) {
            // Redirigir a la página de éxito
            context
                .read<SalesBlocBloc>()
                .add(GetTotalSales(day: DateTime.now()));

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Venta exitosa, sigue asi")),
            );
          } else if (state is SalesBlocFailure) {
            // Mostrar un SnackBar de error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error al procesar la venta")),
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ButtonPay(
                totalSell: totalSell,
                listItem: allProducts,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFieldSearchProduct(context),
              BlocConsumer<GetTotalProductsInSaleitemBlocBloc,
                      GetTotalProductsInSaleitemBlocState>(
                  builder: (context, state) {
                if (state is GetTotalProductsInSaleitemBlocLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetTotalProductsInSaleitemBlocSuccess) {
                  if (state.listSaleItem.isEmpty) {
                    return const Expanded(
                        child: Center(
                            child: Text(
                      "No hay productos para mostrar regrese al inicio y agregue un producto",
                      style: TextStyle(fontSize: 18),
                    )));
                  }
                  allProducts = state.listSaleItem;
                  filteredProducts = filteredProducts.isEmpty ? allProducts : filteredProducts;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final order = filteredProducts[index];
                        return CustomCardSell(
                          index: index,
                          product: order,
                          order: allProducts,
                          onOrderChanged: _onOrderChanged,
                        );
                      },
                    ),
                  );
                } else if (state is GetTotalProductsInSaleitemBloFailure) {
                  return const Center(
                    child: Text("Ha ocurrido un error al cargar los productos"),
                  );
                } else {
                  return const Center(
                    child: Text("No hay productos disponibles"),
                  );
                }
              }, listener: (context, state) {
                return null;
              }),
            ],
          ),
        ));
  }

//BUSCADOR DE PRODUCTOS
  SizedBox TextFieldSearchProduct(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
            hintText: 'Buscar...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: EdgeInsets.zero,
            suffixIcon: IconButton(
                onPressed: () {
                  _searchController.clear();
                  _onSearchChanged();
                },
                icon: const Icon(Icons.clear))),
      ),
    );
  }
}

class SalesBlocFailure {}

//WIDGET DE LA CARD DE PRODUCTOS PARA LA VENTA
class CustomCardSell extends StatefulWidget {
  final int index;
  final SaleItem product;
  final List<SaleItem> order;
  final VoidCallback onOrderChanged; // Nuevo parámetro

  const CustomCardSell({
    super.key,
    required this.index,
    required this.product,
    required this.order,
    required this.onOrderChanged,
  });

  @override
  State<CustomCardSell> createState() => _CustomCardSellState();
}

class _CustomCardSellState extends State<CustomCardSell> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: "0");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateQuantity(String value) {
    final newQuantity = int.tryParse(value) ?? 0;
    widget.order[widget.index].quantity = newQuantity;
    setState(() {
      _controller.text = widget.order[widget.index].quantity.toString();
    });

    widget.onOrderChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 2.5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: _imageWidget(widget.product.product.img_url),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("Precio: \$${widget.product.product.price}"),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 45,
                  child: TextFormField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Cantidad",
                      contentPadding: EdgeInsets.only(left: 5),
                    ),
                    onChanged: _updateQuantity,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            )),
            Column(
              children: [
                TextButton(
                  child: const Text('Agregar'),
                  onPressed: () {
                    widget.order[widget.index].quantity += 1;
                    setState(() {
                      _controller.text =
                          widget.order[widget.index].quantity.toString();
                    });
                    widget.onOrderChanged(); // Llamada al callback
                  },
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('Eliminar'),
                  onPressed: () {
                    if (widget.order[widget.index].quantity > 0) {
                      widget.order[widget.index].quantity -= 1;
                      setState(() {
                        _controller.text =
                            widget.order[widget.index].quantity.toString();
                      });
                      widget.onOrderChanged(); // Llamada al callback
                    }
                  },
                ),
                BlocListener<GetProductByBarcodeBloc, GetProductByBarcodeState>(
                  listener: (context, state) {
                    if (state is GetProductByBarcodeSucces) {
                      setState(() {
                        if (state.product.id == widget.product.product.id) {
                          widget.order[widget.index].quantity += 1;
                          FlutterBeep.beep();
                          widget.onOrderChanged(); // Actualizar la vista
                          setState(() {
                              _controller.text =
                          widget.order[widget.index].quantity.toString();
                          });
                        }
                      });
                    } else if (state is GetProductByBarcodeFailure) {
                      FlutterBeep.beep(false);
                      
                    }
                  },
                  child: const SizedBox
                      .shrink(), // Widget vacío para cumplir con la API
                ),
              ],
            )
          ]),
        ));
  }

  // Función para obtener el widget de imagen o el fallback
  Widget _imageWidget(String? imagePath) {
    if (imagePath != null && imagePath.isNotEmpty) {
      File imageFile = File(imagePath);
      if (imageFile.existsSync()) {
        return Image.file(
          imageFile,
          width: 90,
          height: 90,
          fit: BoxFit.cover,
        );
      } else {
        // Si el archivo no existe, muestra el fallback
        return _fallbackImage();
      }
    } else {
      // Si no hay imagen proporcionada, muestra el fallback
      return _fallbackImage();
    }
  }

  // Widget de fallback (imagen por defecto)
  Widget _fallbackImage() {
    return Container(
      width: 90,
      height: 90,
      color: Colors.grey,
      child: const Icon(
        Icons.image,
        size: 50,
        color: Colors.white,
      ),
    );
  }
}
