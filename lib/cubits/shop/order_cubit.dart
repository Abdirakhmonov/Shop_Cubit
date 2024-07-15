import 'package:bloc/bloc.dart';
import 'package:cubit_bloc/cubits/shop/order_state.dart';
import '../../data/models/order.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(InitialOrderState());

  List<Order> orders = [];

  void getOrders() async {
    try {
      emit(LoadingOrderState());
      emit(LoadedOrderState(orders));
    } catch (e) {
      ErrorOrderState("Ma'lumot olishda xatolik bor!!!");
    }
  }

  void addOrder({required id, required title, required price, required image}) {
    orders.add(Order(id: id, title: title, price: price, image: image));
    emit(LoadedOrderState(orders));
  }
}
