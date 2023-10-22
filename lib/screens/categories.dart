import 'package:flutter/material.dart';

import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/category.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  // a function that will be passed on onTap.
  void _selectedCategory(BuildContext context, Category category) {
    // where is iterable but is a list
    // iterating through that contains the category id of a meal
    final filteredMeals = dummyMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        // MaterialPageRoute() is used to build the screen widget 
        // and adding builder is necessary to create a new build screen page
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick your category'),
      ),
      // main page content
      body: GridView(
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
      ),
    );
  }
}
