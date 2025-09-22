import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/theme_provider.dart';
import 'package:restaurant_app/ui/widgets/ui_app_bar.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../../provider/restaurant_provider.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_detail_page.dart';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<RestaurantProvider>(context, listen: false).fetchRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        UiAppBar(title: "Restaurant")
      ],
      child: Consumer<RestaurantProvider>(
        builder: (context, provider, _) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _buildContent(provider),
          );
        },
      ),
    );
  }

  Widget _buildContent(RestaurantProvider provider) {
    switch (provider.state) {
      case ResultState.loading:
        return const Center(child: CircularProgressIndicator());
      case ResultState.hasData:
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: provider.restaurants.length,
          itemBuilder: (context, index) {
            final restaurant = provider.restaurants[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RestaurantDetailPage(id: restaurant.id),
                  ),
                );
              },
              child: RestaurantCard(restaurant: restaurant),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 30),
        );
      case ResultState.noData:
        return Center(child: Text(provider.message));
      case ResultState.error:
        return Center(child: Text("Error: ${provider.message}"));
    }
  }
}
