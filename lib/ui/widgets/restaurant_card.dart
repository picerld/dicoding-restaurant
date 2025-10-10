import 'package:flutter/material.dart' as m;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../../data/model/restaurant.dart';
import '../../data/local/shared_prefs_service.dart';

class RestaurantCard extends m.StatefulWidget {
  final Restaurant restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  m.State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends m.State<RestaurantCard> {
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    final savedMode = await SharedPrefsService.getThemeMode(); // 'dark' or 'light' or 'system'
    setState(() {
      _isDark = savedMode == 'dark';
    });
  }

  @override
  m.Widget build(m.BuildContext context) {
    final textColor = _isDark ? m.Colors.white : m.Colors.black;

    return m.Hero(
      tag: widget.restaurant.id,
      transitionOnUserGestures: true,
      flightShuttleBuilder: (
          flightContext,
          animation,
          flightDirection,
          fromHeroContext,
          toHeroContext,
          ) {
        return m.Material(
          color: m.Colors.transparent,
          child: toHeroContext.widget,
        );
      },
      child: SurfaceCard(
        clipBehavior: m.Clip.hardEdge,
        padding: m.EdgeInsets.zero,
        borderRadius: m.BorderRadius.circular(12),
        child: m.IntrinsicHeight( // ✅ allows correct sizing
          child: m.Column(
            crossAxisAlignment: m.CrossAxisAlignment.start,
            children: [
              m.AspectRatio(
                aspectRatio: 16 / 9,
                child: m.Image.network(
                  "https://restaurant-api.dicoding.dev/images/medium/${widget.restaurant.pictureId}",
                  fit: m.BoxFit.cover,
                  errorBuilder: (_, __, ___) => m.Container(
                    color: m.Colors.grey.shade300,
                    child: const m.Center(
                      child: m.Icon(
                        m.Icons.image_not_supported_outlined,
                        size: 40,
                        color: m.Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              m.Padding(
                padding: const m.EdgeInsets.all(12),
                child: m.Column(
                  crossAxisAlignment: m.CrossAxisAlignment.start,
                  mainAxisSize: m.MainAxisSize.min,
                  children: [
                    m.Text(
                      widget.restaurant.name,
                      style: m.TextStyle(
                        fontSize: 16,
                        fontWeight: m.FontWeight.bold,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: m.TextOverflow.ellipsis,
                    ),
                    const m.SizedBox(height: 4),
                    m.Text(
                      widget.restaurant.city,
                      style: m.TextStyle(
                        fontSize: 12,
                        color: textColor.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: m.TextOverflow.ellipsis,
                    ),
                    const m.SizedBox(height: 8),
                    m.Row(
                      children: [
                        const m.Icon(
                          m.Icons.star,
                          size: 16,
                          color: m.Colors.amber,
                        ),
                        const m.SizedBox(width: 6),
                        m.Text(
                          widget.restaurant.rating.toString(),
                          style: m.TextStyle(
                            fontSize: 14,
                            color: textColor,
                          ),
                          maxLines: 1,
                          overflow: m.TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
