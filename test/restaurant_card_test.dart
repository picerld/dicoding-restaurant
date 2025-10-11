import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/theme_provider.dart';
import 'package:restaurant_app/theme.dart';
import 'package:restaurant_app/ui/widgets/restaurant_card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

void main() {
  // Mock restaurant data untuk testing
  final mockRestaurant = Restaurant(
    id: 'test-001',
    name: 'Resto Test',
    description: 'Deskripsi resto test',
    pictureId: 'test-picture',
    city: 'Jakarta',
    rating: 4.5,
  );

  Widget createTestWidget(Restaurant restaurant) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: ShadcnApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        home: Scaffold(
          child: RestaurantCard(restaurant: restaurant),
        ),
      ),
    );
  }

  testWidgets('RestaurantCard menampilkan nama restoran', (
      WidgetTester tester,
      ) async {
    await tester.pumpWidget(createTestWidget(mockRestaurant));
    await tester.pumpAndSettle();

    expect(find.text('Resto Test'), findsOneWidget);
  });

  testWidgets('RestaurantCard menampilkan kota restoran', (
      WidgetTester tester,
      ) async {
    await tester.pumpWidget(createTestWidget(mockRestaurant));
    await tester.pumpAndSettle();

    expect(find.text('Jakarta'), findsOneWidget);
  });

  testWidgets('RestaurantCard menampilkan rating restoran', (
      WidgetTester tester,
      ) async {
    await tester.pumpWidget(createTestWidget(mockRestaurant));
    await tester.pumpAndSettle();

    expect(find.text('4.5'), findsOneWidget);
  });

  testWidgets('RestaurantCard menampilkan icon star untuk rating', (
      WidgetTester tester,
      ) async {
    await tester.pumpWidget(createTestWidget(mockRestaurant));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('RestaurantCard memiliki Hero widget dengan tag yang benar', (
      WidgetTester tester,
      ) async {
    await tester.pumpWidget(createTestWidget(mockRestaurant));
    await tester.pumpAndSettle();

    final heroFinder = find.byType(Hero);
    expect(heroFinder, findsOneWidget);

    final Hero hero = tester.widget(heroFinder);
    expect(hero.tag, equals('test-001'));
  });

  testWidgets('RestaurantCard menampilkan gambar restoran', (
      WidgetTester tester,
      ) async {
    await tester.pumpWidget(createTestWidget(mockRestaurant));
    await tester.pumpAndSettle();

    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);
  });

  testWidgets('RestaurantCard menggunakan ThemeProvider untuk styling', (
      WidgetTester tester,
      ) async {
    await tester.pumpWidget(createTestWidget(mockRestaurant));
    await tester.pumpAndSettle();

    // Verify Provider is used
    final BuildContext context = tester.element(find.byType(RestaurantCard));
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    expect(themeProvider, isNotNull);
  });

  testWidgets('RestaurantCard text tidak overflow dengan nama panjang', (
      WidgetTester tester,
      ) async {
    final longNameRestaurant = Restaurant(
      id: 'test-002',
      name: 'Resto Dengan Nama Yang Sangat Panjang Sekali',
      description: 'Deskripsi',
      pictureId: 'test-picture',
      city: 'Jakarta Selatan Timur Utara',
      rating: 4.8,
    );

    await tester.pumpWidget(createTestWidget(longNameRestaurant));
    await tester.pumpAndSettle();

    // Verify no overflow errors
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'RestaurantCard dengan rating berbeda menampilkan nilai yang benar',
        (WidgetTester tester) async {
      final highRatedRestaurant = Restaurant(
        id: 'test-003',
        name: 'High Rated Resto',
        description: 'Deskripsi',
        pictureId: 'test-picture',
        city: 'Bandung',
        rating: 4.9,
      );

      await tester.pumpWidget(createTestWidget(highRatedRestaurant));
      await tester.pumpAndSettle();

      expect(find.text('4.9'), findsOneWidget);
      expect(find.text('Bandung'), findsOneWidget);
    },
  );

  testWidgets('RestaurantCard di dalam ListView tidak overflow', (
      WidgetTester tester,
      ) async {
    final restaurants = List.generate(
      3,
          (index) => Restaurant(
        id: 'test-$index',
        name: 'Resto $index',
        description: 'Deskripsi',
        pictureId: 'pic-$index',
        city: 'Jakarta',
        rating: 4.0 + (index * 0.1),
      ),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: ShadcnApp(
          theme: lightTheme,
          home: Scaffold(
            child: ListView.separated(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                return RestaurantCard(restaurant: restaurants[index]);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 20),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify no overflow
    expect(tester.takeException(), isNull);

    // Find at least one card (some may be off-screen)
    expect(find.byType(RestaurantCard), findsWidgets);

    // Verify first card is visible
    expect(find.text('Resto 0'), findsOneWidget);
  });
}