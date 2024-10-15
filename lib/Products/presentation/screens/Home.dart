import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mi_tiendita/Sales/presentation/bloc/sales/sales_bloc_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mi_tiendita/Products/domain/entities.dart';
import 'package:mi_tiendita/Products/presentation/bloc/products_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    context.read<SalesBlocBloc>().add(GetTotalSales(day: DateTime.now()));

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Tu Ad Unit ID aquí
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Error al cargar el BannerAd: $error');
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => context.read<ProductsBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mi tiendita"),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                child: ElevatedButton(
                    child: const Text("Relaizar venta"),
                    onPressed: () {
                      Navigator.pushNamed(context, '/sell');
                    }),
              ),
              const SizedBox(height: 10),
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
              BlocBuilder<SalesBlocBloc, SalesBlocState>(
                  builder: (context, state) {
                print(state);
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
              }),
              const SizedBox(height: 10),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                child: ElevatedButton(
                    child: const Text("Metricas"),
                    onPressed: () {
                      Navigator.pushNamed(context, '/metrics');
                    }),
              ),

              Spacer(),
              if (_isBannerAdReady)
                SizedBox(
                  width: _bannerAd.size.width.toDouble(),
                  height: _bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _modalAddProduct(BuildContext context) {
    File? _selectedImage;
    String _productName = '';
    double _price = 0.0;
    int _quantity = 0;

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
                } else if (state is ProductsSucces) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("El producto se ha agregado exitosamente."),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(
                      context); // Cierra el modal después de agregar exitosamente
                } else if (state is ProductsFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            "Ha ocurrido un error. Si persiste, contáctenos por correo electrónico.")),
                  );
                }
              },
              child: DraggableScrollableSheet(
                expand: false,
                initialChildSize:
                    0.7, // Define el porcentaje inicial de la pantalla (85%)
                maxChildSize: 0.7, // Tamaño máximo al expandir (95%)
                minChildSize: 0.6, // Tamaño mínimo
                builder: (context, scrollController) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 50,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Nombre del producto",
                              ),
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
                                width:
                                    MediaQuery.of(context).size.width * 0.425,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Precio",
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _price = double.tryParse(value) ?? 0.0;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.425,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Cantidad",
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
                                    ? Image.file(_selectedImage!,
                                        fit: BoxFit.cover)
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
                              if (_productName.isNotEmpty &&
                                  _price > 0 &&
                                  _quantity > 0) {
                                final newProduct = Product(
                                  id: "tripalosqui",
                                  name: _productName,
                                  price: _price,
                                  stock: _quantity,
                                  img_url:
                                      _selectedImage?.path.toString() ?? "",
                                );

                                BlocProvider.of<ProductsBloc>(context)
                                    .add(AddProducts(product: newProduct));
                              } else {
                                // Show an error message to the user
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Por favor, complete todos los campos requeridos.")),
                                );
                              }
                            },
                            child: const Text('Guardar Producto'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ));
        });
  }
}
