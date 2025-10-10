import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

class FavoriteRobot {
  final WidgetTester tester;

  const FavoriteRobot(this.tester);

  ValueKey favoriteCardKey(String id) => ValueKey('favoriteCard_$id');
  ValueKey deleteButtonKey(String id) => ValueKey('favoriteDelete_$id');

  Future<void> loadUI(Widget widget) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  }

  Future<void> tapDeleteFavorite(String id) async {
    final deleteFinder = find.byKey(deleteButtonKey(id));
    await tester.tap(deleteFinder);
    await tester.pumpAndSettle();
  }

  Future<void> expectFavoriteExists(String id, {bool exists = true}) async {
    final cardFinder = find.byKey(favoriteCardKey(id));
    if (exists) {
      expect(cardFinder, findsOneWidget);
    } else {
      expect(cardFinder, findsNothing);
    }
  }
}
