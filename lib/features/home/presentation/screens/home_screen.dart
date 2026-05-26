import 'package:escucha_tu_historia_front/core/constants/app_colors.dart';
import 'package:escucha_tu_historia_front/core/constants/app_constants.dart';
import 'package:escucha_tu_historia_front/features/monuments/data/models/monument_model.dart';
import 'package:escucha_tu_historia_front/features/monuments/providers/monuments_provider.dart';
import 'package:escucha_tu_historia_front/features/news/providers/noticias_provider.dart';
import 'package:escucha_tu_historia_front/features/settings/providers/config_provider.dart';
import 'package:escucha_tu_historia_front/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final monumentosProv = Provider.of<MonumentsProvider>(context);
    final l = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : AppColors.background;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: _construirAppBar(context, l, isDark),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _construirTarjetaHero(context),
            const SizedBox(height: 24),
            Text(
              l.home_exploreCity,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _construirMenuPrincipal(context, l),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l.home_recommendedToday,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/monuments'),
                  child: Text(
                    l.home_seeAll,
                    style: const TextStyle(color: AppColors.primaryGreen),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            monumentosProv.isLoading
                ? _construirCargando()
                : _construirListaMonumentos(
                    context,
                    monumentosProv.monuments,
                    l,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _construirCargando() {
    return SizedBox(
      height: 160,
      child: Center(
        child: Lottie.asset(
          AppConstants.splashAnimation,
          width: 100,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  AppBar _construirAppBar(
    BuildContext context,
    AppLocalizations l,
    bool isDark,
  ) {
    final noticias = Provider.of<NoticiasProvider>(context);
    final barColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final iconColor = isDark ? Colors.white : const Color(0xFF1A1A1A);

    return AppBar(
      backgroundColor: barColor,
      elevation: 0,
      titleSpacing: 12,
      title: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Image.asset('assets/images/logo.png', width: 22, height: 22),
          ),
          const SizedBox(width: 10),
          Text(
            l.home_listenYourStory,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => context.push('/settings'),
          icon: Icon(Icons.settings_outlined, color: iconColor),
          tooltip: l.home_settings,
        ),
        Consumer<ConfigProvider>(
          builder: (context, config, _) {
            return Stack(
              children: [
                IconButton(
                  onPressed: () => _mostrarNotificaciones(context),
                  icon: Icon(Icons.notifications_none, color: iconColor),
                ),
                if (noticias.cantidadNoLeidas > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        noticias.cantidadNoLeidas > 9
                            ? '9+'
                            : '${noticias.cantidadNoLeidas}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _mostrarNotificaciones(BuildContext context) {
    final noticiasProvider = Provider.of<NoticiasProvider>(
      context,
      listen: false,
    );
    final l = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        l.news_title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${noticiasProvider.cantidadNoLeidas}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (noticiasProvider.cantidadNoLeidas > 0)
                    TextButton(
                      onPressed: () {
                        noticiasProvider.marcarTodasComoLeidas();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Todas las noticias marcadas como leídas',
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Text(
                        l.news_markAllRead,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),
              Expanded(
                child: Consumer<NoticiasProvider>(
                  builder: (context, provider, child) {
                    if (provider.cargando) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (provider.error != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error al cargar noticias',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => provider.cargarNoticias(),
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      );
                    }

                    final noticiasNoLeidas = provider.noticiasNoLeidas;

                    if (noticiasNoLeidas.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 64,
                              color: Colors.green.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '¡Todo al día!',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No tienes noticias sin leer',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: noticiasNoLeidas.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final noticia = noticiasNoLeidas[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryGreen.withAlpha(
                              26,
                            ),
                            child: const Icon(
                              Icons.campaign,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          title: Text(
                            noticia.titulo,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            noticia.subtitulo,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          trailing: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            context.push('/noticia/${noticia.id}');
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _construirTarjetaHero(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context)!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Image.network(
            'https://martos.es/wp-content/uploads/2023/11/MG_9907-1-1024x683.jpg',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 200,
              color: Colors.grey.shade300,
              child: const Center(
                child: Icon(Icons.image_not_supported, size: 48),
              ),
            ),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withAlpha(192)],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'CUNA DEL OLIVAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l.home_discover,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Explora la historia, cultura y gastronomía de la ciudad de la Peña.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirMenuPrincipal(BuildContext context, AppLocalizations l) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _tarjetaMenu(
          icono: Icons.castle_outlined,
          etiqueta: l.home_monuments,
          colorFondo: AppColors.primaryGreen,
          colorIcono: Colors.white,
          colorTexto: Colors.white,
          alPulsar: () => context.go('/monuments'),
        ),
        // Favoritos
        _tarjetaMenu(
          icono: Icons.favorite_outline,
          etiqueta: l.home_favorites,
          colorFondo: const Color(0xFF5DA5E4),
          colorIcono: Colors.white,
          colorTexto: Colors.white,
          alPulsar: () => context.push('/favoritos'),
        ),
        _tarjetaMenu(
          icono: Icons.smart_toy_outlined,
          etiqueta: l.home_aiAssistant,
          colorFondo: const Color(0xFFE53935),
          colorIcono: Colors.white,
          colorTexto: Colors.white,
          alPulsar: () => context.push('/chatbot'),
        ),
        _tarjetaMenu(
          icono: Icons.newspaper_outlined,
          etiqueta: l.home_news,
          colorFondo: const Color(0xFFF59C1A),
          colorIcono: Colors.white,
          colorTexto: Colors.white,
          alPulsar: () => context.push('/noticias'),
        ),
      ],
    );
  }

  Widget _tarjetaMenu({
    required IconData icono,
    required String etiqueta,
    String? subEtiqueta,
    required Color colorFondo,
    required Color colorIcono,
    Color colorTexto = Colors.black87,
    required VoidCallback alPulsar,
  }) {
    return Material(
      color: colorFondo,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: alPulsar,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono dentro de un cubo/caja semitransparente
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icono, color: colorIcono, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                etiqueta,
                style: TextStyle(
                  color: colorTexto,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              if (subEtiqueta != null)
                Text(
                  subEtiqueta,
                  style: TextStyle(
                    color: colorTexto.withAlpha(204),
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirListaMonumentos(
    BuildContext context,
    List<MonumentResponse> monumentos,
    AppLocalizations l,
  ) {
    if (monumentos.isEmpty) {
      return SizedBox(
        height: 140,
        child: Center(
          child: Text(
            l.home_empty_monumets,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: monumentos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) =>
            _tarjetaMonumento(context, monumentos[index]),
      ),
    );
  }

  Widget _tarjetaMonumento(BuildContext context, MonumentResponse monumento) {
    AppLocalizations l = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tieneImagen = monumento.picture.isNotEmpty;
    Color colorTag = AppColors.primaryGreen;
    try {
      final hex = monumento.tag.colorHex.replaceAll('#', '');
      colorTag = Color(int.parse('FF$hex', radix: 16));
    } catch (_) {}

    return GestureDetector(
      // Navegamos al detalle pasando el objeto por extra
      onTap: () => context.push('/monument-detail', extra: monumento),
      child: Container(
        width: 170,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            if (tieneImagen)
              Image.network(
                monumento.picture.first.url,
                width: 170,
                height: 160,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return SizedBox(
                    width: 170,
                    height: 160,
                    child: Center(
                      child: Lottie.asset(
                        AppConstants.splashAnimation,
                        width: 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => _placeholderImagen(l),
              )
            else
              _placeholderImagen(l),
            Container(
              width: 170,
              height: 160,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    (isDark ? const Color(0xFF2C2C2C) : Colors.white).withAlpha(
                      255,
                    ),
                  ],
                  stops: const [0.3, 1],
                ),
              ),
            ),

            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    monumento.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: colorTag.withAlpha(230),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  monumento.tag.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImagen(dynamic l) {
    // Usamos un builder para acceder al contexto y saber si es modo oscuro
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          width: 170,
          height: 160,
          color: isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.castle_outlined,
                size: 40,
                color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
              ),
              SizedBox(height: 6),
              Text(
                l.detail_imageNotAvailable,
                style: TextStyle(
                  color: isDark ? Colors.grey.shade600 : Colors.grey.shade500,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
