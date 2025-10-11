import 'package:flutter/material.dart' as m;
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../../data/model/restaurant.dart';
import '../../provider/theme_provider.dart';

class RestaurantCard extends m.StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  m.Widget build(m.BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDark(context);
    final textColor = isDark ? m.Colors.white : m.Colors.black;

    return m.Hero(
      tag: restaurant.id,
      transitionOnUserGestures: true,
      flightShuttleBuilder:
          (
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
      child: m.SizedBox(
        width: double.infinity,
        child: SurfaceCard(
          clipBehavior: m.Clip.hardEdge,
          padding: m.EdgeInsets.zero,
          borderRadius: m.BorderRadius.circular(12),
          child: m.SingleChildScrollView(
            physics: const m.NeverScrollableScrollPhysics(),
            child: m.Column(
              crossAxisAlignment: m.CrossAxisAlignment.start,
              mainAxisSize: m.MainAxisSize.min,
              children: [
                // Image
                m.AspectRatio(
                  aspectRatio: 16 / 9,
                  child: m.Image.network(
                    "https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}",
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

                // Content
                m.Padding(
                  padding: const m.EdgeInsets.all(12),
                  child: m.Column(
                    crossAxisAlignment: m.CrossAxisAlignment.start,
                    mainAxisSize: m.MainAxisSize.min,
                    children: [
                      m.Text(
                        restaurant.name,
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
                        restaurant.city,
                        style: m.TextStyle(
                          fontSize: 12,
                          color: textColor.withOpacity(0.7),
                        ),
                        maxLines: 1,
                        overflow: m.TextOverflow.ellipsis,
                      ),
                      const m.SizedBox(height: 6),
                      m.Row(
                        mainAxisSize: m.MainAxisSize.min,
                        children: [
                          const m.Icon(
                            m.Icons.star,
                            size: 16,
                            color: m.Colors.amber,
                          ),
                          const m.SizedBox(width: 6),
                          m.Text(
                            restaurant.rating.toString(),
                            style: m.TextStyle(fontSize: 14, color: textColor),
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
      ),
    );
  }
}
