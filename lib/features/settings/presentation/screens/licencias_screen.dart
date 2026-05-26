import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Pantalla de licencias de los paquetes de código abierto que usa la app.
// Google Play requiere que las apps sean transparentes con las dependencias
// de terceros, especialmente las que tienen licencias MIT, BSD o Apache 2.0.
class LicenciasScreen extends StatelessWidget {
  const LicenciasScreen({super.key});

  // Lista manual de los paquetes más relevantes. En producción también
  // puedes abrir LicensePage() de Flutter que las carga automáticamente,
  // pero esta vista personalizada queda más integrada con el diseño de la app.
  static const List<_PaqueteLicencia> _paquetes = [
    _PaqueteLicencia(
      nombre: 'Flutter',
      version: 'SDK',
      licencia: 'BSD 3-Clause',
      descripcion: 'Framework de UI multiplataforma de Google.',
      url: 'https://github.com/flutter/flutter/blob/master/LICENSE',
    ),
    _PaqueteLicencia(
      nombre: 'provider',
      version: '^6.0.0',
      licencia: 'MIT',
      descripcion: 'Gestión de estado basada en InheritedWidget.',
      url: 'https://pub.dev/packages/provider',
    ),
    _PaqueteLicencia(
      nombre: 'go_router',
      version: '^14.0.0',
      licencia: 'BSD 3-Clause',
      descripcion: 'Sistema de navegación declarativa para Flutter.',
      url: 'https://pub.dev/packages/go_router',
    ),
    _PaqueteLicencia(
      nombre: 'shared_preferences',
      version: '^2.0.0',
      licencia: 'BSD 3-Clause',
      descripcion: 'Persistencia de datos clave-valor en el dispositivo.',
      url: 'https://pub.dev/packages/shared_preferences',
    ),
    _PaqueteLicencia(
      nombre: 'google_maps_flutter',
      version: '^2.0.0',
      licencia: 'BSD 3-Clause',
      descripcion: 'Widget de Google Maps para Flutter.',
      url: 'https://pub.dev/packages/google_maps_flutter',
    ),
    _PaqueteLicencia(
      nombre: 'lottie',
      version: '^3.0.0',
      licencia: 'MIT',
      descripcion: 'Reproducción de animaciones Lottie/Bodymovin.',
      url: 'https://pub.dev/packages/lottie',
    ),
    _PaqueteLicencia(
      nombre: 'flutter_markdown',
      version: '^0.7.0',
      licencia: 'BSD 3-Clause',
      descripcion: 'Renderizado de texto en formato Markdown.',
      url: 'https://pub.dev/packages/flutter_markdown',
    ),
    _PaqueteLicencia(
      nombre: 'url_launcher',
      version: '^6.0.0',
      licencia: 'BSD 3-Clause',
      descripcion: 'Apertura de URLs en el navegador del sistema.',
      url: 'https://pub.dev/packages/url_launcher',
    ),
    _PaqueteLicencia(
      nombre: 'intl',
      version: '^0.19.0',
      licencia: 'BSD 3-Clause',
      descripcion: 'Internacionalización y formateo de fechas.',
      url: 'https://pub.dev/packages/intl',
    ),
    _PaqueteLicencia(
      nombre: 'http',
      version: '^1.0.0',
      licencia: 'BSD 3-Clause',
      descripcion: 'Cliente HTTP para llamadas a la API.',
      url: 'https://pub.dev/packages/http',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecundario = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: isDark ? Colors.white : const Color(0xFF1A1A1A)),
        title: Text(
          'Licencias de código abierto',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        // Acceso rápido a la vista oficial de Flutter con todas las licencias
        actions: [
          IconButton(
            icon: Icon(Icons.list_alt_outlined, color: isDark ? Colors.white70 : Colors.grey.shade600),
            tooltip: 'Ver todas',
            onPressed: () => showLicensePage(
              context: context,
              applicationName: 'Martos Guía',
              applicationVersion: 'v2.4.0',
              applicationLegalese: '© 2024 Martos Guía · Hecho en Jaén',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Nota informativa
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2D24) : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF4CAF50), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Esta app usa paquetes de código abierto. Puedes consultar sus licencias completas desde el icono de la esquina superior derecha.',
                    style: TextStyle(fontSize: 12, color: textSecundario, height: 1.4),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _paquetes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final p = _paquetes[index];
                return _TarjetaLicencia(paquete: p, isDark: isDark);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaLicencia extends StatelessWidget {
  final _PaqueteLicencia paquete;
  final bool isDark;

  const _TarjetaLicencia({required this.paquete, required this.isDark});

  Color get _colorLicencia {
    switch (paquete.licencia) {
      case 'MIT':
        return const Color(0xFF42A5F5);
      case 'Apache 2.0':
        return const Color(0xFFEF5350);
      default:
        return const Color(0xFF66BB6A); // BSD
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icono de paquete
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _colorLicencia.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.extension_outlined, color: _colorLicencia, size: 20),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          paquete.nombre,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _colorLicencia.withAlpha(30),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          paquete.licencia,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _colorLicencia,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    paquete.descripcion,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Modelo simple para cada paquete
class _PaqueteLicencia {
  final String nombre;
  final String version;
  final String licencia;
  final String descripcion;
  final String url;

  const _PaqueteLicencia({
    required this.nombre,
    required this.version,
    required this.licencia,
    required this.descripcion,
    required this.url,
  });
}
