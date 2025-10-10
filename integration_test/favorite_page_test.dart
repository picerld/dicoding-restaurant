import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/favorite_restaurant.dart';
import 'package:restaurant_app/provider/favorite_provider.dart';
import 'package:restaurant_app/provider/nav_provider.dart';
import 'package:restaurant_app/provider/theme_provider.dart';
import 'package:restaurant_app/theme.dart';
import 'package:restaurant_app/ui/pages/favorite_page.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class TestFavoriteProvider extends FavoriteProvider {
  @override
  Future<void> loadFavorites() async {
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('FavoritePage Integration Test', () {
    late TestFavoriteProvider favoriteProvider;

    setUp(() {
      favoriteProvider = TestFavoriteProvider()
        ..addFavorite(
          FavoriteRestaurant(
            id: '1',
            name: 'Sushi Place',
            city: 'Tokyo',
            pictureId: 'sushi.jpg',
            rating: 4.5,
          ),
        )
        ..addFavorite(
          FavoriteRestaurant(
            id: '2',
            name: 'Pizza Corner',
            city: 'Rome',
            pictureId: 'pizza.jpg',
            rating: 4.2,
          ),
        );
    });

    testWidgets('Show favorite items and delete', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<FavoriteProvider>.value(
              value: favoriteProvider,
            ),
            ChangeNotifierProvider(create: (_) => NavProvider()),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ],
          child: Builder(
            builder: (context) {
              final themeProvider = Provider.of<ThemeProvider>(context);
              return ShadcnApp(
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: themeProvider.themeMode,
                home: MaterialApp(home: const FavoritePage()),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('favoriteCard_1')), findsOneWidget);
      expect(find.byKey(const ValueKey('favoriteName_1')), findsOneWidget);
      expect(find.byKey(const ValueKey('favoriteCard_2')), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('favoriteDelete_1')));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('favoriteCard_1')), findsNothing);
      expect(find.byKey(const ValueKey('favoriteCard_2')), findsOneWidget);
    });
  });
}
