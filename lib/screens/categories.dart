import 'package:flutter/material.dart';

import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/category.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({
    super.key,
    // required this.onToggleFavorite, // replaced by riverpod
    required this.availableMeals,
  });

  // final void Function(Meal meal) onToggleFavorite; // replaced by riverpod
  
  final List<Meal> availableMeals;

  // this function that will be passed when GridCategoryItem is tapped.
  void _selectedCategory(BuildContext context, Category category) {
    // .where() is iterable but is a list
    // iterating through that contains the category id of a meal
    final filteredMeals = availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        // MaterialPageRoute() is used to build the screen widget
        // adding builder is necessary to create a new build screen page
        builder: (ctx) => MealsScreen(
          // onToggleFavorite: onToggleFavorite, // replaced by riverpod
          title: category.title,
          meals: filteredMeals,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(24),
      // controls the grid layout
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // horizontal
        childAspectRatio: 3 / 2, // or 1.5
        crossAxisSpacing: 20, //spacing between columns
        mainAxisSpacing: 20, // space around
      ),
      children: [
        // availableCategories came from dummy_data.dart
        for (final category in availableCategories)
          // boxing each category through CategoryGridItem
          CategoryGridItem(
            category: category,
            onSelectCategory: () {
              _selectedCategory(context, category);
            },
          )
      ],
    );
  }
}
