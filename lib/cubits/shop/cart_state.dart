import '../../data/models/cart.dart';

sealed class CartState {}

class InitialCartState extends CartState {}

class LoadingCartState extends CartState {}

class LoadedCartState extends CartState {
  List<Cart> carts = [];

  LoadedCartState(this.carts);
}

class ErrorCartState extends CartState {
  final String message;

  ErrorCartState(this.message);
}
