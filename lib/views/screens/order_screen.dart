import 'package:cubit_bloc/cubits/shop/order_cubit.dart';
import 'package:cubit_bloc/cubits/shop/order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      context.read<OrderCubit>().getOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Orders",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
          builder: (BuildContext context, OrderState state) {
        if (state is InitialOrderState) {
          return const Center(
            child: Text("Ma'lumot hali yuklanmadi"),
          );
        }

        if (state is LoadingOrderState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ErrorOrderState) {
          return Center(
            child: Text(state.message),
          );
        }

        final orders = (state as LoadedOrderState).orders;
        return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final product = orders[index];
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
                ),
              );
            });
      }),
    );
  }
}
