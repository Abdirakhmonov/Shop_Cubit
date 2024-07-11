import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../counter/counter_cubit.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.read<CounterCubit>().decrement();
            },
            icon: const Icon(Icons.remove),
          ),
          IconButton(
            onPressed: () {
              context.read<CounterCubit>().increment();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<CounterCubit, int>(
        builder: (BuildContext context, state) {
          return Center(
            child: Text(
              state.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          );
        },
      ),
    );
  }
}
