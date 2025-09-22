import 'package:flutter/material.dart';
import '../data/api_service.dart';
import '../data/model/restaurant.dart';
import '../data/model/restaurant_detail.dart';
import '../data/model/review_response.dart';

enum ResultState { loading, hasData, noData, error }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({required this.apiService});

  ResultState _state = ResultState.loading;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurant> _restaurants = [];
  List<Restaurant> get restaurants => _restaurants;

  RestaurantDetail? _restaurantDetail;
  RestaurantDetail? get restaurantDetail => _restaurantDetail;

  List<Restaurant> _searchResults = [];
  List<Restaurant> get searchResults => _searchResults;

  /// Fetch all restaurants
  Future<void> fetchRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final result = await apiService.listRestaurants();
      if (result.restaurants.isEmpty) {
        _state = ResultState.noData;
        _message = "No restaurants found";
      } else {
        _state = ResultState.hasData;
        _restaurants = result.restaurants;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = "Failed to fetch restaurants: $e";
    }
    notifyListeners();
  }

  Future<void> fetchRestaurantDetail(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final result = await apiService.restaurantDetail(id);
      _state = ResultState.hasData;
      _restaurantDetail = result.restaurant;
    } catch (e) {
      _state = ResultState.error;
      _message = "Failed to fetch detail: $e";
    }
    notifyListeners();
  }

  Future<void> searchRestaurants(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final result = await apiService.searchRestaurants(query);
      if (result.restaurants.isEmpty) {
        _state = ResultState.noData;
        _message = "No results found for \"$query\"";
      } else {
        _state = ResultState.hasData;
        _searchResults = result.restaurants;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = "Search failed: $e";
    }
    notifyListeners();
  }

  Future<void> addReview(String id, String name, String review) async {
    try {
      final result = await apiService.addReview(id, name, review);
      if (result.error == false) {
        _restaurantDetail?.customerReviews = result.customerReviews;
        notifyListeners();
      } else {
        _message = "Failed to add review";
      }
    } catch (e) {
      _message = "Error adding review: $e";
    }
    notifyListeners();
  }
}
