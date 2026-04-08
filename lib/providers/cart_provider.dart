import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == index)
            CartItem(product: state[i].product, quantity: state[i].quantity + 1)
          else
            state[i],
      ];
    } else {
      state = [...state, CartItem(product: product)];
    }
  }

  void removeItem(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  double get total =>
      state.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  int get itemCount => state.fold(0, (sum, item) => sum + item.quantity);
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);
