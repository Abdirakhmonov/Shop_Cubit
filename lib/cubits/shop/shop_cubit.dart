import 'package:bloc/bloc.dart';
import 'package:cubit_bloc/cubits/shop/shop_state.dart';
import 'package:flutter/cupertino.dart';

import '../../data/models/shop.dart';

class ShopCubit extends Cubit<ShopState> {
  ShopCubit() : super(InitialState());
  List<Shop> products = [
    Shop(
        id: UniqueKey().toString(),
        title: "Iphone",
        image:
            "https://ss.sport-express.ru/userfiles/materials/193/1930423/volga.jpg",
        price: "\$1200"),
    Shop(
        id: UniqueKey().toString(),
        title: "Airpods",
        image:
            "https://assets.asaxiy.uz/product/items/desktop/cad87ad16130789485abc63ecd369ed42021102815535175907VF2Y3djqax.jpg.webp",
        price: "\$50"),
    Shop(
        id: UniqueKey().toString(),
        title: "Macbook",
        image:
            "https://220volt.uz/image/cache/catalog/apple/MacBook/macbook%20air%202020%20grey-2-320x320.jpg.webp",
        price: "\$1300"),
    Shop(
        id: UniqueKey().toString(),
        title: "Watch",
        image:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Apple_Watch_Series_8_Midnight_Aluminium_Case.jpg/1200px-Apple_Watch_Series_8_Midnight_Aluminium_Case.jpg",
        price: "\$200")
  ];

  void getProducts() async {
    try {
      emit(LoadingState());

      emit(LoadedState(products));
    } catch (e) {
      ErrorState("Ma'lumot olishda xatolik bor!!!");
    }
  }

  void addProduct(Shop product) {
    products.add(product);
    emit(LoadedState(products));
  }

  void editProduct(Shop editedProduct) {
    final index = products.indexWhere((product) => product.id == editedProduct.id);
    if (index != -1) {
      products[index] = editedProduct;
      emit(LoadedState(products));
    }
  }
  void deleteProduct(String id){
    final index = products.indexWhere((product) => product.id == id);
    if (index != -1) {
      products.removeAt(index);
      emit(LoadedState(products));
    }
  }
  void toggleFavorite(Shop product) {
    product.isFavorite = !product.isFavorite;
    emit(LoadedState(products));
  }
}
