class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    pictureId: json["pictureId"],
    city: json["city"],
    rating: (json["rating"] as num).toDouble(),
  );
}

class RestaurantResult {
  final List<Restaurant> restaurants;

  RestaurantResult({required this.restaurants});

  factory RestaurantResult.fromJson(Map<String, dynamic> json) =>
      RestaurantResult(
        restaurants: List<Restaurant>.from(
          json["restaurants"].map((x) => Restaurant.fromJson(x)),
        ),
      );
}
