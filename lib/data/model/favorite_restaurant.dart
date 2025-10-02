class FavoriteRestaurant {
  final String id;
  final String name;
  final String pictureId;
  final String city;
  final double rating;

  FavoriteRestaurant({
    required this.id,
    required this.name,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory FavoriteRestaurant.fromMap(Map<String, dynamic> map) {
    return FavoriteRestaurant(
      id: map['id'],
      name: map['name'],
      pictureId: map['pictureId'],
      city: map['city'],
      rating: (map['rating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'pictureId': pictureId,
    'city': city,
    'rating': rating,
  };
}
