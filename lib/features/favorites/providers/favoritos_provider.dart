import 'package:flutter/material.dart';
import 'package:escucha_tu_historia_front/features/monuments/data/models/monument_model.dart';
import '../data/services/favorites_service.dart';

class FavoritosProvider extends ChangeNotifier {
  final FavoritesService _service = FavoritesService();

  // IDs de los monumentos en favoritos
  List<String> _favoriteIds = [];

  FavoritosProvider() {
    _cargarFavoritos();
  }

  Future<void> _cargarFavoritos() async {
    _favoriteIds = await _service.getFavoriteIds();
    notifyListeners();
  }

  bool esFavorito(String monumentId) {
    return _favoriteIds.contains(monumentId);
  }

  // Añade o quita el monumento de favoritos y devuelve el nuevo estado
  Future<bool> toggleFavorito(String monumentId) async {
    final esFav = await _service.toggleFavorite(monumentId);
    _favoriteIds = await _service.getFavoriteIds();
    notifyListeners();
    return esFav;
  }

  // Devuelve solo los monumentos que están en favoritos
  List<MonumentResponse> getFavoritosDeListado(List<MonumentResponse> todos) {
    return todos.where((m) => _favoriteIds.contains(m.id)).toList();
  }
}
