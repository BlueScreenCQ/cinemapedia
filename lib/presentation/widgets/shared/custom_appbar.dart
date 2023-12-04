import 'package:cinemapedia/presentation/providers/search/search_tv_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/delegates/search_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
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
                        if (pageName == 'home') {
                          final searchedMovies = ref.read(searchedMoviesProvider);
                          final searchQuery = ref.read(searchQueryProvider);

                          showSearch<Movie?>(
                                  query: searchQuery,
                                  context: context,
                                  delegate: SearchMovieDelegate(initialMovies: searchedMovies, searchMovies: ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery))
                              .then((movie) {
                            if (movie != null) {
                              context.push('/home/0/movie/${movie.id}');
                            }
                          });
                        }

                        if (pageName == 'tv') {
                          final searchedTV = ref.read(searchedTVProvider);
                          final searchQuery = ref.read(searchTVQueryProvider);

                          showSearch<Movie?>(
                                  query: searchQuery,
                                  context: context,
                                  delegate: SearchMovieDelegate(initialMovies: searchedTV, searchMovies: ref.read(searchedTVProvider.notifier).searchMoviesByQuery, esTv: true))
                              .then((movie) {
                            if (movie != null) {
                              context.push('/home/0/tv/${movie.id}');
                            }
                          });
                        }
                      },
                      icon: const Icon(Icons.search))
                ],
              )),
        ));
  }
}
