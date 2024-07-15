import 'package:cubit_bloc/cubits/shop/cart_cubit.dart';
import 'package:cubit_bloc/cubits/shop/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/shop/order_cubit.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<CartCubit>().getCarts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cart",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<CartCubit, CartState>(
          builder: (BuildContext context, CartState state) {
        if (state is InitialCartState) {
          return const Center(
            child: Text("Ma'lumot hali yuklanmadi"),
          );
        }

        if (state is LoadingCartState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ErrorCartState) {
          return Center(
            child: Text(state.message),
          );
        }

        final carts = (state as LoadedCartState).carts;
        return ListView.builder(
            itemCount: carts.length,
            itemBuilder: (context, index) {
              final product = carts[index];
              return Card(
                child: ListTile(
                  leading: Image.network(
                    product.image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    product.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 22),
                  ),
                  subtitle: Text(
                    product.price,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                      "Siz ${product.title} nomli mahsulotni savatchadan o'chirmoqchimisiz?"),
                                  content: Row(
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Yo'q")),
                                      const Spacer(),
                                      FilledButton(
                                          onPressed: () {
                                            context
                                                .read<CartCubit>()
                                                .deleteCart(product.id);
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Ha"))
                                    ],
                                  ),
                                );
                              });
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                      FilledButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                        "Siz ${product.title} nomli mahsulotni sotib olmoqchimisiz?"),
                                    content: Row(
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Yo'q")),
                                        const Spacer(),
                                        FilledButton(
                                            onPressed: () {
                                              context
                                                  .read<OrderCubit>()
                                                  .addOrder(
                                                      id: product.id,
                                                      title: product.title,
                                                      price: product.price,
                                                      image: product.image);
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "Siz ${product.title} nomli mahsulotni sotib oldingiz!"),
                                                ),
                                              );
                                              context.read<CartCubit>().deleteCart(product.id);
                                            },
                                            child: const Text("Ha"))
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: const Text("BUY"))
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }
}
