import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';

// Extending the StateNotifier class.
// StateNotifier<List<Meal>> the <<>> is an indicator what kind of data to be
// managed.
// When using StateNotifier it is not allowed to edit an existing value of data
// but rather you have to create a new value of data.
class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  // initialize data as an empty list
  FavoriteMealsNotifier() : super([]);

  void toggleMealFavoriteStatus(Meal meal) {
    // state is a globally state property from StateNotifier
    final mealIsFavorite = state.contains(meal);

    if (mealIsFavorite) {
      // remove a meal 
      state = state.where((m) => m.id != meal.id).toList();
    } else {
      state = [...state, meal];
    }
  }
}

// StateNotifierProvider() is used for optimized data that can change
final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>((ref) {
  return FavoriteMealsNotifier();
});
