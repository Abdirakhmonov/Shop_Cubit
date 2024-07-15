import 'package:cubit_bloc/counter/counter_cubit.dart';
import 'package:cubit_bloc/cubits/shop/cart_cubit.dart';
import 'package:cubit_bloc/cubits/shop/order_cubit.dart';
import 'package:cubit_bloc/cubits/shop/shop_cubit.dart';
import 'package:cubit_bloc/cubits/shop/theme_cubit.dart';
import 'package:cubit_bloc/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CounterCubit()),
        BlocProvider(create: (context) => ShopCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => OrderCubit())
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeMode,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
