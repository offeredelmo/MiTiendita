import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mi_tiendita/Products/domain/entities.dart';
import 'package:mi_tiendita/Products/presentation/bloc/products_bloc.dart';
import 'package:image_picker/image_picker.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsBloc>().add(GetProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mis productos")),
      resizeToAvoidBottomInset: true,
      body: const ProductList(),
    );
  }
}

// ignore: camel_case_types
class ProductList extends StatelessWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state is ProductDeleteSucces) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("El producto se ha eliminado correctamente.")),
          );
          context.read<ProductsBloc>().add(GetProducts());
        } else if (state is ProductsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "Ha ocurrido un error al eliminar el producto. Por favor, intenta de nuevo.")),
          );
        } else if (state is UpdateProductSucces) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("El producto se ha actualizado correctamente.")),
          );
          context.read<ProductsBloc>().add(GetProducts());
        }
      },
      builder: (context, state) {
        if (state is ProductGetListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductsSuccesProductList) {
          if (state.products.isEmpty) {
            return const Center(
              child: Text(
                  "Aun no hay producto regresa al inicio y agrega un nuevo producto",
                  style: TextStyle(fontSize: 18)),
            );
          }
          return ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return ProductCard(product: product);
            },
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
      },
    );
  }
}

// ignore: camel_case_types
class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  File? _selectedImage;
  String? _productName;
  String? _barCode;
  double? _price;
  int? _stock;
  final FocusNode productNameFocus = FocusNode();
  final FocusNode productPriceFocus = FocusNode();
  final FocusNode productBarcodeFocus = FocusNode();
  final FocusNode productStockFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2.5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: _imageWidget(widget.product.img_url),
            ),
            const SizedBox(width: 16),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("Stock: ${widget.product.stock}"),
                Text("Precio: \$${widget.product.price}"),
                Text("codigo: ${widget.product.barCode}"),
              ],
            )),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _modalAddProduct(context);
                  },
                  child: const Text("Editar"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<ProductsBloc>()
                        .add(DeleteProducts(id: widget.product.id));
                  },
                  child: const Text("Eliminar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

  Future<dynamic> _modalAddProduct(BuildContext context) {
    _productName = widget.product.name;
    _price = widget.product.price;
    _stock = widget.product.stock;
    _selectedImage;
    _barCode = widget.product.barCode;

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
        isScrollControlled: true, // Esto permite controlar la altura del mod
        context: context,
        builder: (BuildContext context) {
          return BlocListener<ProductsBloc, ProductsState>(
              listener: (context, state) {
                if (state is ProductUpdateLoading) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Se está actualizando  el producto..."),
                      duration: Duration(milliseconds: 900),
                    ),
                  );
                } else if (state is UpdateProductSucces) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text("El producto se ha actualizado exitosamente."),
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
              child: Padding(
                padding: MediaQuery.of(context)
                    .viewInsets, // Ajusta el padding al teclado
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                          child: TextFormField(
                            initialValue: _productName,
                            focusNode: productNameFocus,
                            onTapOutside: (event) => productNameFocus,
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
                              width: MediaQuery.of(context).size.width * 0.425,
                              child: TextFormField(
                                initialValue: _price?.toString(),
                                focusNode: productPriceFocus,
                                onTapOutside: (event) => productPriceFocus,
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
                              width: MediaQuery.of(context).size.width * 0.425,
                              child: TextFormField(
                                initialValue: _stock?.toString(),
                                focusNode: productStockFocus,
                                onTapOutside: (event) => productStockFocus,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Cantidad",
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _stock = int.tryParse(value) ?? 0;
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
                            initialValue: _barCode?.toString(),
                            focusNode: productBarcodeFocus,
                            onTapOutside: (event) => productBarcodeFocus,
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
                            final newProduct = Product(
                                id: widget.product.id,
                                name: _productName ?? widget.product.name,
                                price: _price ?? widget.product.price,
                                stock: _stock ?? widget.product.stock,
                                img_url: _selectedImage?.path ??
                                    widget.product.img_url,
                                barCode: _barCode ?? widget.product.barCode);
                            context
                                .read<ProductsBloc>()
                                .add(UpdateProduct(product: newProduct));
                          },
                          child: const Text('Guardar Producto'),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }
}
