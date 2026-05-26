import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _key = 'favorites_monument_ids';

  // Devuelve los IDs de monumentos guardados en disco
  Future<List<String>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  // Guarda un ID en favoritos si no estaba, o lo elimina si ya estaba
  Future<bool> toggleFavorite(String monumentId) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_key) ?? [];

    if (ids.contains(monumentId)) {
      ids.remove(monumentId);
      await prefs.setStringList(_key, ids);
      return false; // Ya no es favorito
    } else {
      ids.add(monumentId);
      await prefs.setStringList(_key, ids);
      return true; // Ahora es favorito
    }
  }

  // Comprueba si un monumento está en favoritos
  Future<bool> isFavorite(String monumentId) async {
    final ids = await getFavoriteIds();
    return ids.contains(monumentId);
  }
}