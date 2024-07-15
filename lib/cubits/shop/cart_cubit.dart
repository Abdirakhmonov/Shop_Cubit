import 'package:bloc/bloc.dart';
import '../../data/models/cart.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(InitialCartState());

  List<Cart> carts = [];

  void getCarts() async {
    try {
      emit(LoadingCartState());

      emit(LoadedCartState(carts));
    } catch (e) {
      ErrorCartState("Ma'lumot olishda xatolik bor!!!");
    }
  }

  void addCart({required id, required title, required price, required image}) {
    carts.add(Cart(id: id, title: title, price: price, image: image));
    emit(LoadedCartState(carts));
  }

  void deleteCart(String id) {
    final index = carts.indexWhere((product) => product.id == id);
    if (index != -1) {
      carts.removeAt(index);
      emit(LoadedCartState(carts));
    }
  }
}
