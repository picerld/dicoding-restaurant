import 'dart:ui' as ui;
import 'package:provider/provider.dart';
import 'package:restaurant_app/ui/widgets/ui_app_bar.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../../provider/restaurant_provider.dart';
import '../widgets/review_form.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String id;
  const RestaurantDetailPage({super.key, required this.id});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<RestaurantProvider>(context, listen: false)
        .fetchRestaurantDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        UiAppBar(title: "Restaurant", showBack: true,)
      ],
      child: Consumer<RestaurantProvider>(
        builder: (context, provider, _) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: () {
              switch (provider.state) {
                case ResultState.loading:
                  return const Center(
                    key: ValueKey('loading'),
                    child: CircularProgressIndicator(),
                  );
                case ResultState.hasData:
                  final restaurant = provider.restaurantDetail!;
                  return SingleChildScrollView(
                    key: const ValueKey('hasData'),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: restaurant.id,
                          transitionOnUserGestures: true,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              "https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(restaurant.name).h2,
                        const SizedBox(height: 6),
                        Text("${restaurant.city} • ${restaurant.address}"),
                        const SizedBox(height: 8),
                        AnimatedValueBuilder<double>(
                          value: restaurant.rating,
                          duration: const Duration(milliseconds: 400),
                          lerp: (a, b, t) => ui.lerpDouble(a, b, t) ?? a,
                          builder: (context, animatedRating, _) {
                            return Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber),
                                const SizedBox(width: 6),
                                Text(animatedRating.toStringAsFixed(1)),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(restaurant.description),
                        const SizedBox(height: 24),

                        Text('Foods').h4,
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (restaurant.menus['foods'] ?? [])
                              .map<Widget>((f) => PrimaryBadge(child: Text(f.name)))
                              .toList(),
                        ),
                        const SizedBox(height: 16),

                        Text('Drinks').h4,
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (restaurant.menus['drinks'] ?? [])
                              .map<Widget>((d) => PrimaryBadge(child: Text(d.name)))
                              .toList(),
                        ),
                        const SizedBox(height: 24),

                        Text('Reviews').h3,
                        const SizedBox(height: 8),
                        ...restaurant.customerReviews.expand((r) => [
                          PrimaryBadge(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(r.name).h4,
                                      Text(r.date),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(r.review),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ]),

                        const SizedBox(height: 24),
                        ReviewForm(restaurantId: restaurant.id),
                      ],
                    ),
                  );
                case ResultState.noData:
                  return Center(
                    key: const ValueKey('noData'),
                    child: Text(provider.message),
                  );
                case ResultState.error:
                default:
                  return Center(
                    key: const ValueKey('error'),
                    child: Text('Error: ${provider.message}'),
                  );
              }
            }(),
          );
        },
      ),
    );
  }
}
