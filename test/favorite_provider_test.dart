import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/provider/favorite_provider.dart';
import 'package:restaurant_app/data/model/favorite_restaurant.dart';
import 'package:restaurant_app/data/local/shared_prefs_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FavoriteProvider provider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    provider = FavoriteProvider();
    await provider.loadFavorites();
  });

  group('FavoriteProvider Unit Test', () {
    test('Menambahkan restoran ke favorite', () async {
      final resto = FavoriteRestaurant(
        id: '1',
        name: 'Resto Test',
        pictureId: 'pic1',
        city: 'Jakarta',
        rating: 4.5,
      );

      await provider.addFavorite(resto);

      expect(provider.favorites.length, 1);
      expect(provider.favorites[0].name, 'Resto Test');
      expect(provider.isFavorite('1'), isTrue);
    });

    test('Menghapus restoran dari favorite', () async {
      final resto = FavoriteRestaurant(
        id: '2',
        name: 'Resto Test 2',
        pictureId: 'pic2',
        city: 'Bandung',
        rating: 4.0,
      );

      await provider.addFavorite(resto);
      expect(provider.favorites.length, 1);

      await provider.removeFavorite('2');
      expect(provider.favorites.length, 0);
      expect(provider.isFavorite('2'), isFalse);
    });

    test('Toggle favorite restoran', () async {
      final resto = FavoriteRestaurant(
        id: '3',
        name: 'Resto Toggle',
        pictureId: 'pic3',
        city: 'Surabaya',
        rating: 3.5,
      );

      await provider.toggleFavorite(resto);
      expect(provider.isFavorite('3'), isTrue);

      await provider.toggleFavorite(resto);
      expect(provider.isFavorite('3'), isFalse);
    });
  });
}
