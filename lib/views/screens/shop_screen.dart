import 'package:cubit_bloc/cubits/shop/cart_cubit.dart';
import 'package:cubit_bloc/cubits/shop/shop_cubit.dart';
import 'package:cubit_bloc/data/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/shop/shop_state.dart';
import '../../cubits/shop/theme_cubit.dart';
import '../../data/models/shop.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<ShopCubit>().getProducts();
    });
  }

  void _showAddEditDialog({Shop? product}) {
    final isEditing = product != null;
    final titleController = TextEditingController(text: product?.title ?? '');
    final priceController = TextEditingController(text: product?.price ?? '');
    final imageController = TextEditingController(text: product?.image ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Product' : 'Add Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final title = titleController.text;
                final price = priceController.text;
                final image = imageController.text;

                if (isEditing) {
                  context.read<ShopCubit>().editProduct(
                        Shop(
                          id: product.id,
                          title: title,
                          price: price,
                          image: image,
                        ),
                      );
                } else {
                  context.read<ShopCubit>().addProduct(
                        Shop(
                          id: UniqueKey().toString(),
                          title: title,
                          price: price,
                          image: image,
                        ),
                      );
                }

                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void delete(id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Bu productni o'chirishga aminmisiz?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            content: Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<ShopCubit>().deleteProduct(id);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Ok",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Shop",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showAddEditDialog();
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
            icon: Icon(
              Icons.brightness_6,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
          ),
        ],
      ),
      body: BlocBuilder<ShopCubit, ShopState>(
        builder: (BuildContext context, ShopState state) {
          if (state is InitialState) {
            return const Center(
              child: Text("Ma'lumot hali yuklanmadi"),
            );
          }

          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ErrorState) {
            return Center(
              child: Text(state.message),
            );
          }

          final products = (state as LoadedState).products;
          return GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: 2,
                  mainAxisExtent: 265),
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 170,
                        width: double.infinity,
                        child: Image.network(
                          product.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              product.price,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              _showAddEditDialog(product: product);
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              delete(product.id);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                context.read<CartCubit>().addCart(
                                    id: product.image,
                                    title: product.title,
                                    price: product.price,
                                    image: product.image);
                                ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(
                                        content: Text(
                                            "${product.title} savatchaga qo'shildi!!!")));
                              },
                              icon: const Icon(Icons.shopping_cart)),
                        ],
                      ),
                    ],
                  ),
                );
              });
        },
      ),

    );
  }
}
