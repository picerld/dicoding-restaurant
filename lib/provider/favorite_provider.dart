import 'package:flutter/foundation.dart';
import 'package:restaurant_app/data/local/shared_prefs_service.dart';
import 'package:restaurant_app/data/model/favorite_restaurant.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<FavoriteRestaurant> _favorites = [];

  List<FavoriteRestaurant> get favorites => List.unmodifiable(_favorites);

  Future<void> loadFavorites() async {
    final listMap = await SharedPrefsService.getFavorites();
    _favorites
      ..clear()
      ..addAll(listMap.map((e) => FavoriteRestaurant.fromMap(e)));
    notifyListeners();
  }

  bool isFavorite(String id) => _favorites.any((e) => e.id == id);

  Future<void> addFavorite(FavoriteRestaurant r) async {
    if (isFavorite(r.id)) return;
    _favorites.add(r);
    await _persist();
  }

  Future<void> removeFavorite(String id) async {
    _favorites.removeWhere((e) => e.id == id);
    await _persist();
  }

  Future<void> toggleFavorite(FavoriteRestaurant r) async {
    if (isFavorite(r.id)) {
      await removeFavorite(r.id);
    } else {
      await addFavorite(r);
    }
  }

  Future<void> _persist() async {
    await SharedPrefsService.setFavorites(
      _favorites.map((e) => e.toMap()).toList(),
    );
    notifyListeners();
  }
}
