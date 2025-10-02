import 'package:provider/provider.dart';
import 'package:restaurant_app/ui/widgets/bottom_nav.dart';
import 'package:restaurant_app/ui/widgets/error_state.dart';
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
  int _index = 0;

  void _onNavTap(int i) {
    setState(() => _index = i);
    if (i == 0) {
      Navigator.pushReplacementNamed(context, '/');
    } else if (i == 1) {
      Navigator.pushReplacementNamed(context, '/favorites');
    } else if (i == 2) {
      Navigator.pushReplacementNamed(context, '/settings');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RestaurantProvider>(
        context,
        listen: false,
      ).fetchRestaurants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [UiAppBar(title: "Restaurant")],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Welcome!",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Cari restoran favorit kamu!!",
                  style: TextStyle(fontSize: 16, color: Colors.gray),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<RestaurantProvider>(
              builder: (context, provider, _) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _buildContent(provider),
                );
              },
            ),
          ),
        ],
      ),
      footers: [ShadcnBottomNav(currentIndex: _index, onTap: _onNavTap)],
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
          separatorBuilder: (context, index) => const SizedBox(height: 20),
        );
      case ResultState.noData:
        return Center(
          child: Text(provider.message, style: const TextStyle(fontSize: 16)),
        );
      case ResultState.error:
        return ErrorState(
          message: provider.message,
          onRetry: () {
            provider.fetchRestaurants();
          },
        );
    }
  }
}
