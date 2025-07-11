import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Riverpod provider that exposes a `Set<String>` of spot IDs the user liked.
/// We use an AsyncNotifier so the UI can show loading until prefs are read.
final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, Set<String>>(FavoritesNotifier.new);

class FavoritesNotifier extends AsyncNotifier<Set<String>> {
  /// Load favorites from SharedPreferences when the provider boots.
  @override
  FutureOr<Set<String>> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorites')?.toSet() ?? <String>{};
  }

  /// Toggle a spot ID; write the new set back to prefs and update state.
  Future<void> toggle(String id) async {
    final current = {...(state.value ?? {})};
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    state = AsyncValue.data(current);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', current.toList());
  }
}
