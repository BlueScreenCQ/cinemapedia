import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  ConsumerState<FavoritesView> createState() => _FavoritesViewState();
  
}

class _FavoritesViewState extends ConsumerState<FavoritesView> {

  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    loadNextPate();
  }

  void loadNextPate() async {

    if( isLoading | isLastPage ) return;

    isLoading =  true;

    final movies = await  ref.read(favoriteMoviesProvider.notifier).loadNextPage();

    if(movies.isEmpty) isLastPage = true;

    isLoading =  false;
  }

  @override
  Widget build(BuildContext context) {

    final favoritesMovies = ref.watch(favoriteMoviesProvider).values.toList();

    if (favoritesMovies.isEmpty) {

      final colors = Theme.of(context).colorScheme;

      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              Icon(Icons.favorite_outline_sharp, size: 60, color: colors.primary),
              Text('Puedes guardar aquí tus películas favoritas', style: TextStyle(fontSize: 30, color: colors.primary), textAlign: TextAlign.center,),
              const SizedBox(height: 15),
              const Text('Añade una película a favoritos desde la pantalla de detalles de la película ', style: TextStyle(fontSize: 20, color: Colors.black45), textAlign: TextAlign.center,),
              const SizedBox(height: 20),
              FilledButton.tonal( //TODO poner otro botón que cargue una peli aleatoria
                onPressed: () => context.go('/home/0'),
                child: const Text('Buscar películas'),
              )
        
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: MovieMasonry(
        movies: favoritesMovies,
        loadNextPage: loadNextPate,
      ),

      // appBar: AppBar(
      //   title: const Text('Favorites View'),
      // ),
      // body: ListView.builder(
      //   itemCount: favoritesMovies.length,
      //   itemBuilder: (context, index) {


      //     return ListTile(
      //       title: Text(favoritesMovies[index].title),
      //     );
      //   }
      //   )
    );
  }
}