import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_tiendita/Products/domain/entities.dart';
import 'package:mi_tiendita/Products/presentation/bloc/products_bloc.dart';
import 'package:mi_tiendita/Sales/domain/sales.entity.dart';
import 'package:mi_tiendita/Sales/presentation/Widget/buttonPay.widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

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
    context.read<ProductsBloc>().add(GetProducts());
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi tiendita"),
        actions: [
          IconButton(onPressed: (){ startBarcodeScanStream();}, icon: Icon(Icons.document_scanner_outlined))
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
  final List<SaleItem> order = [];
  final TextEditingController _searchController = TextEditingController();

  List<Product> filteredProducts = [];
  List<Product> allProducts = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _totalSell() {
    setState(() {
      totalSell = order.fold(
          0, (total, item) => total + (item.product.price * item.quantity));
    });
  }

  void _onOrderChanged() {
    _totalSell();
  }

  void _onSearchChanged() {
    setState(() {
      filteredProducts = allProducts
          .where((product) => product.name
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
                listItem: order,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFieldSearchProduct(context),
              BlocConsumer<ProductsBloc, ProductsState>(
                  builder: (context, state) {
                if (state is ProductGetListLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductsSuccesProductList) {
                  if (state.products.isEmpty) {
                    return const Expanded(
                        child: Center(
                            child: Text(
                      "No hay productos para mostrar regrese al inicio y agregue un producto",
                      style: TextStyle(fontSize: 18),
                    )));
                  }
                  allProducts = state.products;
                  filteredProducts =
                      filteredProducts.isEmpty ? allProducts : filteredProducts;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return CustomCardSell(
                          product: product,
                          order: order,
                          onOrderChanged: _onOrderChanged,
                        );
                      },
                    ),
                  );
                } else if (state is ProductsFailure) {
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
              })
            ],
          ),
        ));
  }

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

class CustomCardSell extends StatefulWidget {
  final Product product;
  final List<SaleItem> order;
  final VoidCallback onOrderChanged; // Nuevo parámetro

  const CustomCardSell({
    super.key,
    required this.product,
    required this.order,
    required this.onOrderChanged,
  });

  @override
  State<CustomCardSell> createState() => _CustomCardSellState();
}

class _CustomCardSellState extends State<CustomCardSell> {
  int quantity = 0;
  late TextEditingController _controller;
  late SaleItem orderItem;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: quantity.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateQuantity(String value) {
    final newQuantity = int.tryParse(value) ?? 0;

    setState(() {
      final existingItem = widget.order.firstWhere(
        (item) => item.product.id == widget.product.id,
        orElse: () => SaleItem(product: widget.product, quantity: 0),
      );

      if (newQuantity > 0) {
        if (existingItem.quantity > 0) {
          existingItem.quantity = newQuantity;
        } else {
          widget.order
              .add(SaleItem(product: widget.product, quantity: newQuantity));
        }
      } else {
        if (existingItem.quantity > 0) {
          widget.order.remove(existingItem);
        }
      }

      quantity = newQuantity;
      _controller.text = quantity.toString();
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
              child: _imageWidget(widget.product.img_url),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("Precio: \$${widget.product.price}"),
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
                    setState(() {
                      // Buscar si el producto ya existe en la lista
                      final existingItem = widget.order.firstWhere(
                        (item) => item.product.id == widget.product.id,
                        orElse: () =>
                            SaleItem(product: widget.product, quantity: 0),
                      );

                      if (existingItem.quantity > 0) {
                        // Si existe, incrementar la cantidad
                        existingItem.quantity += 1;
                      } else {
                        // Si no existe, agregar un nuevo SaleItem
                        widget.order.add(
                            SaleItem(product: widget.product, quantity: 1));
                      }

                      // Actualizar la cantidad local y el controlador de texto
                      if (quantity >= 0) {
                        quantity++;
                      }
                      _controller.text = quantity.toString();
                    });
                    widget.onOrderChanged(); // Llamada al callback
                  },
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('Eliminar'),
                  onPressed: () {
                    setState(() {
                      // Buscar si el producto ya existe en la lista
                      final existingItem = widget.order.firstWhere(
                        (item) => item.product.id == widget.product.id,
                        orElse: () =>
                            SaleItem(product: widget.product, quantity: 0),
                      );

                      if (existingItem.quantity > 0) {
                        // Decrementar la cantidad
                        existingItem.quantity -= 1;
                        quantity = existingItem.quantity;
                        _controller.text = quantity.toString();
                        if (quantity > 0) {
                          quantity--;
                        }
                        // Si la cantidad llega a 0, eliminar el SaleItem de la lista
                        if (existingItem.quantity == 0) {
                          widget.order.remove(existingItem);
                        }
                      }
                    });
                    widget.onOrderChanged(); // Llamada al callback
                  },
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
