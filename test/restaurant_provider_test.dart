import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/data/api_service.dart';

import 'restaurant_provider_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late MockApiService mockApiService;
  late RestaurantProvider provider;

  setUp(() {
    mockApiService = MockApiService();
    provider = RestaurantProvider(apiService: mockApiService);
  });

  group('RestaurantProvider Test', () {
    test('State awal harus ResultState.loading', () {
      expect(provider.state, ResultState.loading);
    });

    test('Berhasil ambil restoran saat API sukses', () async {
      final mockData = RestaurantResult(
        restaurants: [
          Restaurant(
            id: '1',
            name: 'Mock Resto',
            description: 'Deskripsi resto',
            pictureId: 'pic1',
            city: 'Jakarta',
            rating: 4.5,
          ),
        ],
      );

      when(mockApiService.listRestaurants())
          .thenAnswer((_) async => mockData);

      await provider.fetchRestaurants();

      expect(provider.state, ResultState.hasData);
      expect(provider.restaurants.length, 1);
      expect(provider.restaurants[0].name, 'Mock Resto');
    });

    test('Gagal ambil data saat API error', () async {
      when(mockApiService.listRestaurants())
          .thenThrow(Exception('API Error'));

      await provider.fetchRestaurants();

      expect(provider.state, ResultState.error);
      expect(provider.message, contains('Failed to fetch restaurants'));
    });
  });
}
