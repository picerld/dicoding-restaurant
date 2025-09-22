class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final List<Category> categories;
  final Map<String, List<MenuItem>> menus;
  final double rating;
  List<CustomerReview> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.categories,
    required this.menus,
    required this.rating,
    required this.customerReviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      city: json['city'],
      address: json['address'],
      pictureId: json['pictureId'],
      categories: (json['categories'] as List)
          .map((e) => Category.fromJson(e))
          .toList(),
      menus: {
        "foods": (json['menus']['foods'] as List)
            .map((e) => MenuItem.fromJson(e))
            .toList(),
        "drinks": (json['menus']['drinks'] as List)
            .map((e) => MenuItem.fromJson(e))
            .toList(),
      },
      rating: (json['rating'] as num).toDouble(),
      customerReviews: (json['customerReviews'] as List)
          .map((e) => CustomerReview.fromJson(e))
          .toList(),
    );
  }
}

class Category {
  final String name;
  Category({required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json['name']);
  }
}

class MenuItem {
  final String name;
  MenuItem({required this.name});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(name: json['name']);
  }
}

class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'],
      review: json['review'],
      date: json['date'],
    );
  }
}

class RestaurantDetailResponse {
  final bool error;
  final String message;
  final RestaurantDetail restaurant;

  RestaurantDetailResponse({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailResponse(
      error: json['error'],
      message: json['message'],
      restaurant: RestaurantDetail.fromJson(json['restaurant']),
    );
  }
}
