import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class RestaurantCard extends StatelessWidget {
  final String name;
  final String city;
  const RestaurantCard({super.key, required this.name, required this.city});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(name, key: const Key('restaurant_name')),
          Text(city, key: const Key('restaurant_city')),
        ],
      ),
    );
  }
}

void main() {
  testWidgets('RestaurantCard menampilkan nama dan kota',
          (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
            body: RestaurantCard(name: 'Resto Test', city: 'Jakarta'),
          ),
        ));

        expect(find.byKey(const Key('restaurant_name')), findsOneWidget);
        expect(find.text('Resto Test'), findsOneWidget);
        expect(find.byKey(const Key('restaurant_city')), findsOneWidget);
        expect(find.text('Jakarta'), findsOneWidget);
      });
}
