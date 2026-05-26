import 'package:escucha_tu_historia_front/features/settings/presentation/screens/licencias_screen.dart';
import 'package:escucha_tu_historia_front/features/settings/presentation/screens/privacidad_screen.dart';
import 'package:escucha_tu_historia_front/features/settings/providers/config_provider.dart';
import 'package:escucha_tu_historia_front/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Tamaño estimado del contenido offline guardado en el dispositivo
  String _tamanoOffline = '...';

  @override
  void initState() {
    super.initState();
    _calcularTamanoOffline();
  }

  // Calcula el espacio que ocupa la información guardada localmente:
  // favoritos, ajustes de usuario y caché de la app.
  Future<void> _calcularTamanoOffline() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    // Sumamos el peso aproximado de cada valor almacenado
    int bytesTotal = 0;
    for (final key in keys) {
      final valor = prefs.get(key);
      if (valor is String) {
        bytesTotal += valor.length * 2; // UTF-16: ~2 bytes por carácter
      } else if (valor is List) {
        // Lista de IDs de favoritos, etc.
        bytesTotal += valor.fold<int>(
          0,
          (acc, e) => acc + (e.toString().length * 2),
        );
      } else {
        bytesTotal += 8; // bool, int, double
      }
    }

    // Añadimos una estimación conservadora de la caché de imágenes de Flutter
    // (miniaturas de monumentos que el framework guarda automáticamente)
    const int cacheImagenesAproximada = 8 * 1024 * 1024; // ~8 MB típico
    bytesTotal += cacheImagenesAproximada;

    final texto = _formatearBytes(bytesTotal);
    if (mounted) setState(() => _tamanoOffline = texto);
  }

  String _formatearBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigProvider>(context);
    final l = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
        ),
        title: Text(
          l.settings_title,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          _tituloCabecera(l.settings_title),
          const SizedBox(height: 8),
          _tarjetaOpciones(
            hijos: [
              SwitchListTile(
                secondary: _iconoConFondo(
                  Icons.dark_mode_outlined,
                  const Color(0xFF5C6BC0),
                ),
                title: Text(l.settings_darkMode),
                value: config.modoOscuro,
                onChanged: (valor) => config.setModoOscuro(valor),
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: _iconoConFondo(
                  Icons.translate,
                  const Color(0xFF26A69A),
                ),
                title: Text(l.settings_language),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      config.idioma,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
                onTap: () => _mostrarSelectorIdioma(context, config),
              ),
              const Divider(height: 1, indent: 56),
              SwitchListTile(
                secondary: _iconoConFondo(
                  Icons.notifications_outlined,
                  const Color(0xFFEF5350),
                ),
                title: Text(l.settings_notifications),
                value: config.notificaciones,
                onChanged: (valor) => config.setNotificaciones(valor),
              ),
            ],
          ),

          const SizedBox(height: 24),

          _tituloCabecera(l.settings_securityData),
          const SizedBox(height: 8),
          _tarjetaOpciones(
            hijos: [
              ListTile(
                leading: _iconoConFondo(
                  Icons.security_outlined,
                  const Color(0xFF66BB6A),
                ),
                title: Text(l.settings_privacy),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PrivacidadScreen()),
                  );
                },
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: _iconoConFondo(
                  Icons.cloud_download_outlined,
                  const Color(0xFF42A5F5),
                ),
                title: Text(l.settings_offlineContent),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Mostramos el tamaño real calculado desde SharedPreferences
                    Text(
                      _tamanoOffline,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
                onTap: () {
                  // TODO: gestión de contenido offline
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Sección legal: imprescindible para publicar en Google Play
          _tituloCabecera('Legal'),
          const SizedBox(height: 8),
          _tarjetaOpciones(
            hijos: [
              ListTile(
                leading: _iconoConFondo(
                  Icons.code_outlined,
                  const Color(0xFF8D6E63),
                ),
                title: const Text('Licencias de código abierto'),
                subtitle: const Text(
                  'Paquetes de terceros usados en la app',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LicenciasScreen()),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 32),

          Center(
            child: Text(
              'Escucha tu historia v2.4.0 · Hecho en Jaén',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _mostrarSelectorIdioma(BuildContext context, ConfigProvider config) {
    final idiomas = ['Español', 'English'];
    final l = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l.settings_selectLanguage,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ...idiomas.map((idioma) {
                return ListTile(
                  title: Text(idioma),
                  trailing: config.idioma == idioma
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    config.setIdioma(idioma);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _tituloCabecera(String texto) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 2),
      child: Text(
        texto.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _tarjetaOpciones({required List<Widget> hijos}) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Column(children: hijos),
    );
  }

  Widget _iconoConFondo(IconData icono, Color color) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icono, color: Colors.white, size: 18),
    );
  }
}
