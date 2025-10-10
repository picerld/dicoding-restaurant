import 'dart:ui' as ui;
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:restaurant_app/data/model/favorite_restaurant.dart';
import 'package:restaurant_app/provider/nav_provider.dart';
import 'package:restaurant_app/ui/widgets/error_state.dart';
import 'package:restaurant_app/ui/widgets/favorite_button.dart';
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
  final ScrollController _reviewScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantProvider>().fetchRestaurantDetail(widget.id);
    });
  }

  @override
  void dispose() {
    _reviewScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: const [UiAppBar(title: "Restaurant", showBack: true)],
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
                  final restaurant = provider.restaurantDetail;
                  if (restaurant == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

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
                        FavoriteButton(
                          fav: FavoriteRestaurant(
                            id: restaurant.id,
                            name: restaurant.name,
                            pictureId: restaurant.pictureId,
                            city: restaurant.city,
                            rating: restaurant.rating,
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
                        ReadMoreText(
                          restaurant.description,
                          trimLines: 3,
                          colorClickableText:
                          Theme.of(context).colorScheme.primary,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: ' Baca Selengkapnya',
                          trimExpandedText: ' Sembunyikan',
                        ),
                        const SizedBox(height: 24),

                        // Foods
                        Text('Foods').h4,
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (restaurant.menus['foods'] ?? [])
                              .map<Widget>(
                                (f) => PrimaryBadge(child: Text(f.name)),
                          )
                              .toList(),
                        ),
                        const SizedBox(height: 16),

                        // Drinks
                        Text('Drinks').h4,
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (restaurant.menus['drinks'] ?? [])
                              .map<Widget>(
                                (d) => PrimaryBadge(child: Text(d.name)),
                          )
                              .toList(),
                        ),
                        const SizedBox(height: 24),

                        // Reviews section
                        Text('Reviews').h3,
                        const SizedBox(height: 8),
                        Container(
                          constraints: const BoxConstraints(maxHeight: 300),
                          child: Scrollbar(
                            controller: _reviewScrollController,
                            thumbVisibility: true,
                            child: ListView.builder(
                              controller: _reviewScrollController,
                              itemCount: restaurant.customerReviews.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final r = restaurant.customerReviews[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: PrimaryBadge(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          // ✅ FIX OVERFLOW
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  r.name,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ).h4,
                                              ),
                                              const SizedBox(width: 8),
                                              Flexible(
                                                child: Text(
                                                  r.date,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  textAlign: TextAlign.end,
                                                ).h4,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(r.review),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
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
                  return ErrorState(
                    message: provider.message,
                    onRetry: () {
                      provider.fetchRestaurantDetail(widget.id);
                    },
                  );
              }
            }(),
          );
        },
      ),
    );
  }
}
