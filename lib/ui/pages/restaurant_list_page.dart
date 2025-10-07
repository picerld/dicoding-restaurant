import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/nav_provider.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantProvider>().fetchRestaurants();
      context.read<NavProvider>().setIndex(context, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavProvider>();

    return Scaffold(
      headers: const [UiAppBar(title: "Restaurant")],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
      footers: [
        Consumer<NavProvider>(
          builder: (context, nav, _) => ShadcnBottomNav(
            currentIndex: nav.index,
            onTap: (i) => nav.setIndex(context, i),
          ),
        ),
      ],
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
          separatorBuilder: (context, _) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final restaurant = provider.restaurants[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RestaurantDetailPage(id: restaurant.id),
                    maintainState: true,
                  ),
                );
              },
              child: RestaurantCard(restaurant: restaurant),
            );
          },
        );

      case ResultState.noData:
        return Center(
          child: Text(provider.message, style: const TextStyle(fontSize: 16)),
        );

      case ResultState.error:
        return ErrorState(
          message: provider.message,
          onRetry: provider.fetchRestaurants,
        );
    }
  }
}
