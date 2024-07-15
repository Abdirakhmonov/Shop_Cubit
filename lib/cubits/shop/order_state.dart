import '../../data/models/order.dart';

sealed class OrderState {}

class InitialOrderState extends OrderState {}

class LoadingOrderState extends OrderState {}

class LoadedOrderState extends OrderState {
  List<Order> orders = [];

  LoadedOrderState(this.orders);
}

class ErrorOrderState extends OrderState {
  final String message;

  ErrorOrderState(this.message);
}
