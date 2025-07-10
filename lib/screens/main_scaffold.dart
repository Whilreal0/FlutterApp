import 'package:flutter/material.dart';
import '../services/favorites_service.dart';
import 'home_screen.dart';
import 'favorites_screen.dart';
import 'search_screen.dart';
import 'about_screen.dart';
import 'municipality_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;
  Set<String> _favorites = {};
  final _favoritesService = FavoritesService();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _favorites = await _favoritesService.loadFavorites();
    setState(() {});
  }

  void _toggleFavorite(String id) {
    setState(() {
      _favorites.contains(id) ? _favorites.remove(id) : _favorites.add(id);
    });
    _favoritesService.saveFavorites(_favorites);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(favorites: _favorites, onFavoriteToggle: _toggleFavorite),
      MunicipalityScreen(
        favorites: _favorites,
        onFavoriteToggle: _toggleFavorite,
      ),
      SearchScreen(favorites: _favorites, onFavoriteToggle: _toggleFavorite),
      FavoritesScreen(favorites: _favorites),
      const AboutScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(
            icon: Icon(Icons.location_city),
            label: "Places",
          ),
          NavigationDestination(icon: Icon(Icons.search), label: "Search"),
          NavigationDestination(icon: Icon(Icons.favorite), label: "Favorites"),
          NavigationDestination(icon: Icon(Icons.info), label: "About"),
        ],
      ),
    );
  }
}
