import 'package:flutter/material.dart' as m;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../../data/model/restaurant.dart';

class RestaurantCard extends m.StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  m.Widget build(m.BuildContext context) {
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
      child: SurfaceCard(
        clipBehavior: m.Clip.hardEdge, // prevent image overflow
        padding: m.EdgeInsets.zero,
        borderRadius: m.BorderRadius.circular(12),
        child: ClipRect(
          child: m.Column(
            mainAxisSize: m.MainAxisSize.min,
            crossAxisAlignment: m.CrossAxisAlignment.start,
            children: [
              // Image
              m.AspectRatio(
                aspectRatio: 16 / 9,
                child: m.Image.network(
                  "https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}",
                  fit: m.BoxFit.cover,
                  errorBuilder: (_, __, ___) => m.Container(
                    color: m.Colors.grey[200],
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
                      restaurant.name,
                      style: m.Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: m.FontWeight.bold),
                      maxLines: 1,
                      overflow: m.TextOverflow.ellipsis,
                    ),
                    const m.SizedBox(height: 4),

                    m.Text(
                      restaurant.city,
                      style: m.Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: m.Colors.grey[600],
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
                        m.Expanded(
                          child: m.Text(
                            restaurant.rating.toString(),
                            style: m.Theme.of(context).textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: m.TextOverflow.ellipsis,
                          ),
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
