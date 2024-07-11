import '../../data/models/shop.dart';

sealed class ShopState {}

class InitialState extends ShopState {}

class LoadingState extends ShopState {}

class LoadedState extends ShopState {
  List<Shop> products = [];
  LoadedState(this.products);
}

class ErrorState extends ShopState {
  String message;
  ErrorState(this.message);
}
