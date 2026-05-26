import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigProvider with ChangeNotifier {
  bool _modoOscuro;
  bool _notificaciones;
  String _idioma;

  ConfigProvider({
    required bool modoOscuro,
    required bool notificaciones,
    required String idioma,
  }) : _modoOscuro = modoOscuro,
       _notificaciones = notificaciones,
       _idioma = idioma;

  bool get modoOscuro => _modoOscuro;
  bool get notificaciones => _notificaciones;
  String get idioma => _idioma;

  void setModoOscuro(bool valor) async {
    _modoOscuro = valor;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', valor);
  }

  void setNotificaciones(bool valor) async {
    _notificaciones = valor;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificaciones', valor);
  }

  void setIdioma(String valor) async {
    _idioma = valor;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('idioma', valor);
  }
}
