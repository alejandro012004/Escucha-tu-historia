import 'package:flutter/material.dart';
import 'package:escucha_tu_historia_front/core/constants/app_colors.dart';

// Pantalla de politica de privacidad.
// Google Play obliga a tener una política accesible desde dentro de la app.
// La politica completa vive en una URL externa para poder actualizarla
// sin necesidad de publicar una nueva version de la app.
class PrivacidadScreen extends StatelessWidget {
  const PrivacidadScreen({super.key});

  // Sustituir por la URL real cuando este publicada la politica
  // static const String _urlPolitica = 'https://martos.es'; // TODO: URL real de la politica de privacidad

  static const List<_SeccionPrivacidad> _secciones = [
    _SeccionPrivacidad(
      icono: Icons.person_outline,
      titulo: 'Datos que recogemos',
      contenido:
          'Martos Guía no requiere registro. Guardamos localmente en tu dispositivo tus preferencias (idioma, modo oscuro, notificaciones) y los monumentos que marcas como favoritos. Ningún dato personal se envía a nuestros servidores.',
    ),
    _SeccionPrivacidad(
      icono: Icons.map_outlined,
      titulo: 'Google Maps',
      contenido:
          'La pantalla de mapa usa Google Maps SDK, que puede recoger datos de ubicación y uso según la política de privacidad de Google. Puedes consultar los detalles en policies.google.com/privacy.',
    ),
    _SeccionPrivacidad(
      icono: Icons.smart_toy_outlined,
      titulo: 'Asistente de IA',
      contenido:
          'Las consultas al asistente inteligente se envían a nuestro servidor de IA para generar la respuesta. No asociamos las consultas a ningún dato personal identificable.',
    ),
    _SeccionPrivacidad(
      icono: Icons.share_outlined,
      titulo: 'Compartición de datos',
      contenido:
          'No vendemos ni cedemos tus datos a terceros con fines publicitarios o comerciales.',
    ),
    _SeccionPrivacidad(
      icono: Icons.delete_outline,
      titulo: 'Tus derechos',
      contenido:
          'Puedes eliminar todos los datos guardados localmente desinstalando la aplicación. Para cualquier consulta sobre privacidad puedes contactarnos.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecundario = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
        ),
        title: Text(
          'Política de privacidad',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                // Cabecera informativa
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E2D24)
                        : const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        color: AppColors.primaryGreen,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tu privacidad nos importa',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Aquí encontrarás un resumen de cómo tratamos tus datos. Puedes consultar la política completa en nuestra web.',
                              style: TextStyle(
                                fontSize: 12,
                                color: textSecundario,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Secciones de privacidad
                ..._secciones.map(
                  (s) => _TarjetaSeccion(
                    seccion: s,
                    isDark: isDark,
                    textSecundario: textSecundario,
                  ),
                ),

                const SizedBox(height: 8),

                // Fecha de última actualización
                Text(
                  'Última actualización: mayo 2025',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),

          // Botón para abrir la política completa en el navegador
        ],
      ),
    );
  }
}

class _TarjetaSeccion extends StatelessWidget {
  final _SeccionPrivacidad seccion;
  final bool isDark;
  final Color textSecundario;

  const _TarjetaSeccion({
    required this.seccion,
    required this.isDark,
    required this.textSecundario,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withAlpha(25),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  seccion.icono,
                  color: AppColors.primaryGreen,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      seccion.titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      seccion.contenido,
                      style: TextStyle(
                        fontSize: 12,
                        color: textSecundario,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SeccionPrivacidad {
  final IconData icono;
  final String titulo;
  final String contenido;

  const _SeccionPrivacidad({
    required this.icono,
    required this.titulo,
    required this.contenido,
  });
}
