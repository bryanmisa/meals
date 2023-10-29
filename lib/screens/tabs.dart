import 'package:flutter/material.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';
import 'package:meals/providers/meals_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/favorites_provider.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

// ConsumerStatefulWidget is provided by the RiverPod Package allows to listen
// to the providers and allow changes to the providers.
// To convert to ConsumerStateful Widget add Consumer on all state (single
// word state).

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  // the below code has been replaced by the riverpod favoritesProvider from the
  // favorites_provider.dart
  // final List<Meal> _favoriteMeals = []; // stores new list as favorite meals

  Map<Filter, bool> _selectedFilters = kInitialFilters;

  // replaced by riverpod.
  // funtciton that show info message when meal is added to favorites or
  // removed from favorites
  // void _showInfoMessage(String message) {
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //     ),
  //   );
  // }

  // This function has been removed since it is now managed by the StateNotifer
  // from the favorites_provider.dart
  // this function will add or remove the favorite meals
  // void _toggleMealFavoriteStatus(Meal meal) {
  //   // variable that check if the meals is is already included in the
  //   // favorite meal. The .contains() does the checking.
  //   final isExisting = _favoriteMeals.contains(meal);
  //   // remove and add the meals in the _favoriteMeals List.
  //   if (isExisting) {
  //     setState(() {
  //       _favoriteMeals.remove(meal);
  //     });
  //     _showInfoMessage('Meal is no longer a favorite');
  //   } else {
  //     _favoriteMeals.add(meal);
  //     _showInfoMessage('Added as favorites');
  //   }
  // }

  // function for selecting a page with current index
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  // Drawer, a function that is required by the Drawer.
  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FilterScreen(
            currentFilters: _selectedFilters,
          ),
        ),
      );
      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ref -> allows to setup listeners to providers this is from RiverPod
    // ref.read(); -> to get data from a provider once.
    // ref.watch(); -> to make sure that the build method executes again as the
    // data changes. as advised from the technical reference use ref.watch as
    // often as possible even if it will read data once to avoid bugs

    // returns the data of the provider it watches
    final meals = ref.watch(mealsProvider);

    // availableMeals will be passed to Categories Screen
    final availableMeals = meals.where((meals) {
      /*meals is a reference provider*/

      if (_selectedFilters[Filter.glutenFree]! && !meals.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meals.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meals.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meals.isVegan) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      // onToggleFavorite: _toggleMealFavoriteStatus, // replaced by riverpod
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      // The riverpod package automatically extracts the "state" property
      // value from the notifier class that belongs to the provider. Hence,
      // ref.watch yields List<Meal> here (instaed of the Notifier class)
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      // this place is where all the meals that is marked as favorites
      activePage = MealsScreen(
        meals: favoriteMeals,
        // onToggleFavorite: _toggleMealFavoriteStatus, // replaced by riverpod
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        // main_drawer.dart
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favories',
          ),
        ],
      ),
    );
  }
}
