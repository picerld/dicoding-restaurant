import 'package:flutter/material.dart' as m;
import 'package:provider/provider.dart';
import 'package:restaurant_app/ui/widgets/bottom_nav.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../../provider/restaurant_provider.dart';
import '../../provider/nav_provider.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/error_state.dart';
import '../widgets/ui_app_bar.dart';
import 'restaurant_detail_page.dart';

class RestaurantListPage extends m.StatefulWidget {
  const RestaurantListPage({super.key});

  @override
  m.State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends m.State<RestaurantListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<RestaurantProvider>(
        context,
        listen: false,
      ).fetchRestaurants();
    });
  }

  @override
  m.Widget build(m.BuildContext context) {
    final navProvider = Provider.of<NavProvider>(context);
    final provider = Provider.of<RestaurantProvider>(context);

    return Scaffold(
      headers: const [UiAppBar(title: 'Restaurant')],
      child: CustomScrollView(slivers: _buildContent(provider)),
      footers: [
        ShadcnBottomNav(
          currentIndex: navProvider.index,
          onTap: (i) => navProvider.setIndex(context, i),
        ),
      ],
    );
  }

  List<m.Widget> _buildContent(RestaurantProvider provider) {
    switch (provider.state) {
      case ResultState.loading:
        return const [
          SliverToBoxAdapter(
            child: m.Center(
              child: m.Padding(
                padding: m.EdgeInsets.only(top: 20),
                child: m.CircularProgressIndicator(),
              ),
            ),
          ),
        ];

      case ResultState.hasData:
        return [
          m.SliverPadding(
            padding: const m.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: m.SliverList.builder(
              itemCount: provider.restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = provider.restaurants[index];
                return m.Padding(
                  padding: const m.EdgeInsets.only(bottom: 20),
                  child: m.GestureDetector(
                    onTap: () {
                      m.Navigator.push(
                        context,
                        m.MaterialPageRoute(
                          builder: (_) =>
                              RestaurantDetailPage(id: restaurant.id),
                        ),
                      );
                    },
                    child: RestaurantCard(restaurant: restaurant),
                  ),
                );
              },
            ),
          ),
        ];

      case ResultState.noData:
        return [
          SliverToBoxAdapter(
            child: m.Center(
              child: m.Padding(
                padding: const m.EdgeInsets.only(top: 20),
                child: m.Text(provider.message),
              ),
            ),
          ),
        ];

      case ResultState.error:
        return [
          SliverToBoxAdapter(
            child: ErrorState(
              message: provider.message,
              onRetry: () {
                provider.fetchRestaurants();
              },
            ),
          ),
        ];
    }
  }
}
