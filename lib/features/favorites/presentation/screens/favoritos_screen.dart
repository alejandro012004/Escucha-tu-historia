import 'package:escucha_tu_historia_front/core/constants/app_colors.dart';
import 'package:escucha_tu_historia_front/features/favorites/providers/favoritos_provider.dart';
import 'package:escucha_tu_historia_front/features/monuments/data/models/monument_model.dart';
import 'package:escucha_tu_historia_front/features/monuments/presentation/widgets/empty_monuments_widget.dart';
import 'package:escucha_tu_historia_front/features/monuments/presentation/widgets/monument_card_widget.dart';
import 'package:escucha_tu_historia_front/features/monuments/providers/monuments_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  String _busqueda = '';

  @override
  Widget build(BuildContext context) {
    final monumentsProv = Provider.of<MonumentsProvider>(context);
    final favoritosProv = Provider.of<FavoritosProvider>(context);
    final size = MediaQuery.of(context).size;

    // Obtenemos solo los monumentos guardados como favoritos
    final favoritos = favoritosProv.getFavoritosDeListado(
      monumentsProv.monuments,
    );

    // Aplicamos el filtro de búsqueda local
    final filtrados = _busqueda.isEmpty
        ? favoritos
        : favoritos
              .where(
                (m) => m.name.toLowerCase().contains(_busqueda.toLowerCase()),
              )
              .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _cabecera(context),
                const SizedBox(height: 20),
                _barraBusqueda(context),
                const SizedBox(height: 24),
                _cuerpo(context, filtrados, favoritos, size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cabecera(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textPrimary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(Icons.arrow_back, color: textColor, size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MARTOS, JAÉN',
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w800,
                fontSize: 11,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              'Favoritos',
              style: TextStyle(
                color: textColor,
                fontSize:
                    28, // Bajamos un pelín el tamaño para equilibrar la fila
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _barraBusqueda(BuildContext context) {
    return SearchBar(
      hintText: 'Buscar en favoritos...',
      hintStyle: const WidgetStatePropertyAll(
        TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.w600),
      ),
      leading: const Icon(Icons.search, color: AppColors.primaryGreen),
      backgroundColor: WidgetStatePropertyAll(Theme.of(context).cardColor),
      elevation: const WidgetStatePropertyAll(2),
      shadowColor: const WidgetStatePropertyAll(Colors.black26),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      ),
      onChanged: (value) {
        setState(() => _busqueda = value);
      },
    );
  }

  Widget _cuerpo(
    BuildContext context,
    List<MonumentResponse> filtrados,
    List<MonumentResponse> favoritos,
    Size size,
  ) {
    // Sin favoritos guardados aún
    if (favoritos.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: size.height * 0.1),
        child: _sinFavoritos(context),
      );
    }

    // Hay favoritos pero la búsqueda no devuelve nada
    if (filtrados.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: size.height * 0.1),
        child: const EmptyMonumentsWidget(type: 1),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtrados.length,
      itemBuilder: (context, index) {
        return MonumentCard(monument: filtrados[index]);
      },
    );
  }

  Widget _sinFavoritos(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryGreen.withAlpha(26),
            ),
            child: const Icon(
              Icons.favorite_border,
              size: 60,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Sin favoritos todavía',
            style: TextStyle(
              color: AppColors.primaryGreen,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Pulsa el corazón en un monumento\npara añadirlo aquí.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.primaryGreen, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
