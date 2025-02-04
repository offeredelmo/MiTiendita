import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mi_tiendita/Products/presentation/bloc/products_bloc.dart';

import '../../domain/entities.dart';

class ModalAddProduct extends StatefulWidget {
  const ModalAddProduct({super.key});

  @override
  State<ModalAddProduct> createState() => _ModalAddProductState();
}

class _ModalAddProductState extends State<ModalAddProduct> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                _modalAddProduct(context);
              },
              child: const Text("Agregar un Producto"))
        ],
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
              context.read<ProductsBloc>().add(GetProducts());

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
