import 'package:flutter/material.dart' as m;
import 'package:provider/provider.dart';
import 'package:restaurant_app/ui/widgets/bottom_nav.dart';
import 'package:restaurant_app/ui/widgets/ui_app_bar.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:restaurant_app/provider/favorite_provider.dart';
import 'package:restaurant_app/ui/pages/restaurant_detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  int _index = 1;

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
    context.read<FavoriteProvider>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoriteProvider>();
    final items = provider.favorites;

    return Scaffold(
      headers: const [UiAppBar(title: "Favorit", showBack: true,)],
      child: items.isEmpty
          ? const Center(child: Text("Belum ada restoran favorit"))
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, i) {
          final r = items[i];
          return Card(
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
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        "https://restaurant-api.dicoding.dev/images/small/${r.pictureId}",
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.gray[300],
                          child: const Icon(Icons.restaurant, size: 32),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Info (name, city, rating)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            r.city,
                            style: TextStyle(fontSize: 13, color: Colors.gray[600]),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.star, size: 14),
                              const SizedBox(width: 6),
                              Text(r.rating.toString(), style: const TextStyle(fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Action buttons (hapus favorit)
                    const SizedBox(width: 8),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // pakai ikon kecil — sesuaikan dengan shadcn jika mau style beda
                        IconButton.ghost(
                          onPressed: () => context.read<FavoriteProvider>().removeFavorite(r.id),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      footers: [ShadcnBottomNav(currentIndex: _index, onTap: _onNavTap)],
    );
  }
}
