import 'package:cinemapedia/domain/entities/search_item.dart';
import 'package:cinemapedia/presentation/providers/search/search_actor_provider.dart';
import 'package:cinemapedia/presentation/providers/search/search_provider.dart';
import 'package:cinemapedia/presentation/providers/search/search_tv_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/delegates/search_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends ConsumerWidget {
  final String pageName;

  const CustomAppBar(this.pageName, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final tittleStyle = Theme.of(context).textTheme.titleLarge;

    return SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Icon(
                    (pageName == 'home' ? Icons.movie_outlined : Icons.live_tv_outlined),
                    color: colors.primary,
                  ),
                  const SizedBox(width: 10),
                  Text('Cinemapedia', style: tittleStyle),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        //EXPERIMENTO

                        final searchQuery = ref.read(searchQueryProvider.notifier).state;

                        showSearch(context: context, query: searchQuery, delegate: CustomSearchDelegate(ref: ref)).then((item) {
                          if (item != null) {
                            if (item.isPeli) context.push('/home/0/movie/${item.sId}');
                            if (item.isTV) context.push('/home/0/tv/${item.sId}');
                            if (item.isActor) context.push('/home/0/actor/${item.sId}');
                          }
                        });
                        //

                        // final int searchType = ref.read(searchProvider.notifier).state;
                        // List<SearchItem> searchedItems = [];
                        // String searchQuery = '';
                        // Future<List<SearchItem>> Function(String) searchCallback;

                        // switch (searchType) {
                        //   case 0: //Pelis
                        //     searchedItems = ref.read(searchedMoviesProvider);
                        //     searchQuery = ref.read(searchQueryProvider);
                        //     searchCallback = ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery;
                        //     break;
                        //   case 1: //Series
                        //     searchedItems = ref.read(searchedTVProvider);
                        //     searchQuery = ref.read(searchTVQueryProvider);
                        //     searchCallback = ref.read(searchedTVProvider.notifier).searchMoviesByQuery;
                        //     break;
                        //   case 2: //Actores
                        //     searchedItems = ref.read(searchedActorsProvider);
                        //     searchQuery = ref.read(searchCctorsQueryProvider);
                        //     searchCallback = ref.read(searchedActorsProvider.notifier).searchActorsByQuery;
                        //     break;
                        //   default: //Ponemos pelis para que no se queje el Callback pero es imposible que pase a priori
                        //     searchedItems = ref.read(searchedMoviesProvider);
                        //     searchQuery = ref.read(searchQueryProvider);
                        //     searchCallback = ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery;
                        //     break;
                        // }

                        // showSearch(context: context, query: searchQuery, delegate: CustomSearchDelegate(initialItems: searchedItems, searchCallback: searchCallback)).then((item) {
                        //   if (item != null) {
                        //     if (item.isPeli) context.push('/home/0/movie/${item.sId}');
                        //     if (item.isTV) context.push('/home/0/tv/${item.sId}');
                        //     if (item.isActor) context.push('/home/0/actor/${item.sId}');
                        //   }
                        // });

                        // if (pageName == 'home') {
                        //   final searchedMovies = ref.read(searchedMoviesProvider);
                        //   final searchQuery = ref.read(searchQueryProvider);

                        //   showSearch<Movie?>(
                        //           query: searchQuery,
                        //           context: context,
                        //           delegate: CustomSearchDelegate(initialItems: searchedMovies, searchMovies: ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery))
                        //       .then((movie) {
                        //     if (movie != null) {
                        //       context.push('/home/0/movie/${movie.id}');
                        //     }
                        //   });
                        // }

                        // if (pageName == 'tv') {
                        //   final searchedTV = ref.read(searchedTVProvider);
                        //   final searchQuery = ref.read(searchTVQueryProvider);

                        //   showSearch<Movie?>(
                        //           query: searchQuery,
                        //           context: context,
                        //           delegate: CustomSearchDelegate(initialItems: searchedTV, searchMovies: ref.read(searchedTVProvider.notifier).searchMoviesByQuery, esTv: true))
                        //       .then((movie) {
                        //     if (movie != null) {
                        //       context.push('/home/0/tv/${movie.id}');
                        //     }
                        //   });
                        // }
                      },
                      icon: const Icon(Icons.search))
                ],
              )),
        ));
  }
}
