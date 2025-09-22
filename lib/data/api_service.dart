import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/model/restaurant.dart';
import '../data/model/restaurant_detail.dart';
import '../data/model/review_response.dart';

class ApiService {
  static const String baseUrl = "https://restaurant-api.dicoding.dev";

  Future<RestaurantResult> listRestaurants() async {
    final response = await http.get(Uri.parse("$baseUrl/list"));
    if (response.statusCode == 200) {
      return RestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load restaurants");
    }
  }

  Future<RestaurantDetailResponse> restaurantDetail(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/detail/$id"));
    if (response.statusCode == 200) {
      return RestaurantDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load restaurant detail");
    }
  }

  Future<RestaurantResult> searchRestaurants(String query) async {
    final response = await http.get(Uri.parse("$baseUrl/search?q=$query"));
    if (response.statusCode == 200) {
      return RestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to search restaurants");
    }
  }

  Future<ReviewResponse> addReview(String id, String name, String review) async {
    final response = await http.post(
      Uri.parse("$baseUrl/review"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"id": id, "name": name, "review": review}),
    );
    if (response.statusCode == 200) {
      return ReviewResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to add review");
    }
  }
}
