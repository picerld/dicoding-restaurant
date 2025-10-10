import 'package:flutter/material.dart';
import '../data/api_service.dart';
import '../data/model/restaurant.dart';
import '../data/model/restaurant_detail.dart';

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

  Future<void> fetchRestaurants() async {
    _state = ResultState.loading;
    _restaurants = [];
    notifyListeners();

    try {
      final result = await apiService.listRestaurants();
      if (result.restaurants.isEmpty) {
        _state = ResultState.noData;
        _message = "No restaurants found";
      } else {
        _restaurants = result.restaurants;
        _state = ResultState.hasData;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = "Failed to fetch restaurants: $e";
    }

    notifyListeners();
  }

  Future<void> fetchRestaurantDetail(String id) async {
    _state = ResultState.loading;
    _restaurantDetail = null;
    notifyListeners();

    try {
      final result = await apiService.restaurantDetail(id);

      if (result.restaurant != null) {
        _restaurantDetail = result.restaurant;
        _state = ResultState.hasData;
      } else {
        _state = ResultState.noData;
        _message = "Restaurant not found";
      }
    } catch (e) {
      _state = ResultState.error;
      _message = "Failed to fetch detail: $e";
    }

    notifyListeners();
  }

  Future<void> searchRestaurants(String query) async {
    _state = ResultState.loading;
    _searchResults = [];
    notifyListeners();

    try {
      final result = await apiService.searchRestaurants(query);

      if (result.restaurants.isEmpty) {
        _state = ResultState.noData;
        _message = "No results found for \"$query\"";
      } else {
        _searchResults = result.restaurants;
        _state = ResultState.hasData;
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
      } else {
        _message = "Failed to add review";
      }
    } catch (e) {
      _message = "Error adding review: $e";
    }

    notifyListeners();
  }
}
