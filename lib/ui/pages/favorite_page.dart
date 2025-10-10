import 'package:flutter/material.dart' as m;
import 'package:provider/provider.dart';
import 'package:restaurant_app/ui/widgets/bottom_nav.dart';
import 'package:restaurant_app/ui/widgets/ui_app_bar.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:restaurant_app/provider/favorite_provider.dart';
import 'package:restaurant_app/provider/nav_provider.dart';
import 'package:restaurant_app/ui/pages/restaurant_detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteProvider>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoriteProvider>();
    final navProvider = context.watch<NavProvider>();
    final items = provider.favorites;

    return Scaffold(
      headers: const [UiAppBar(title: "Favorit", showBack: true)],
      child: items.isEmpty
          ? const Center(child: Text("Belum ada restoran favorit"))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, i) {
                final r = items[i];
                return Card(
                  key: ValueKey('favoriteCard_${r.id}'),
                  child: m.InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RestaurantDetailPage(id: r.id),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              "https://restaurant-api.dicoding.dev/images/small/${r.pictureId}",
                              width: 80,
                              height: 80,
                              fit: m.BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 80,
                                height: 80,
                                color: m.Colors.grey[300],
                                child: const m.Icon(
                                  m.Icons.restaurant,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: m.CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.name,
                                  key: ValueKey('favoriteName_${r.id}'),
                                  style: const m.TextStyle(
                                    fontSize: 16,
                                    fontWeight: m.FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: m.TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  r.city,
                                  style: m.TextStyle(
                                    fontSize: 13,
                                    color: m.Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const m.Icon(m.Icons.star, size: 14),
                                    const SizedBox(width: 6),
                                    Text(
                                      r.rating.toString(),
                                      style: const m.TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            mainAxisSize: m.MainAxisSize.min,
                            children: [
                              IconButton.ghost(
                                key: ValueKey('favoriteDelete_${r.id}'),
                                onPressed: () => context
                                    .read<FavoriteProvider>()
                                    .removeFavorite(r.id),
                                icon: const m.Icon(m.Icons.delete_outline),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      footers: [
        ShadcnBottomNav(
          currentIndex: navProvider.index,
          onTap: (i) => navProvider.setIndex(context, i),
        ),
      ],
    );
  }
}
