import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

class FavoritesNotifier extends StateNotifier<List<Product>> {
  FavoritesNotifier() : super([]);

  void toggle(Product product) {
    final exists = state.any((p) => p.id == product.id);
    if (exists) {
      state = state.where((p) => p.id != product.id).toList();
    } else {
      state = [...state, product];
    }
  }

  bool isFavorite(String id) => state.any((p) => p.id == id);
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Product>>(
  (ref) => FavoritesNotifier(),
);