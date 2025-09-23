import 'package:provider/provider.dart';
import 'package:restaurant_app/ui/widgets/ui_app_bar.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../../provider/restaurant_provider.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  void _onSearch() {
    final query = _controller.text;
    if (query.isNotEmpty) {
      Provider.of<RestaurantProvider>(
        context,
        listen: false,
      ).searchRestaurants(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [UiAppBar(title: "Restaurant", showBack: true)],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              placeholder: const Text("Search..."),
              leading: PrimaryButton(
                onPressed: _onSearch,
                child: const Text("Go"),
              ),
            ),
          ),
          Expanded(
            child: Consumer<RestaurantProvider>(
              builder: (context, provider, _) {
                switch (provider.state) {
                  case ResultState.loading:
                    return const Center(child: CircularProgressIndicator());
                  case ResultState.hasData:
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: provider.searchResults.length,
                      itemBuilder: (context, index) {
                        final restaurant = provider.searchResults[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    RestaurantDetailPage(id: restaurant.id),
                              ),
                            );
                          },
                          child: RestaurantCard(restaurant: restaurant),
                        );
                      },
                    );
                  case ResultState.noData:
                    return Center(child: Text(provider.message));
                  case ResultState.error:
                    return Center(child: Text("Error: ${provider.message}"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
