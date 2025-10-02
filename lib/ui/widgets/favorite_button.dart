import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:restaurant_app/data/model/favorite_restaurant.dart';
import 'package:restaurant_app/provider/favorite_provider.dart';

class FavoriteButton extends StatelessWidget {
  final FavoriteRestaurant fav;

  const FavoriteButton({super.key, required this.fav});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoriteProvider>();
    final isFav = provider.isFavorite(fav.id);

    return IconButton.ghost(
      onPressed: () => context.read<FavoriteProvider>().toggleFavorite(fav),
      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
      leading: Text(isFav ? 'Hapus dari Favorit' : 'Tambah ke Favorit'),
    );
  }
}
