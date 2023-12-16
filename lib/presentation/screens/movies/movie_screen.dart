import 'package:cinemapedia/domain/entities/watch_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/similar_movies.dart';
import 'package:cinemapedia/presentation/widgets/shared/actors_by_show.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_gradient.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_read_more_text.dart';
import 'package:cinemapedia/presentation/widgets/shared/snack_bar.dart';
import 'package:cinemapedia/presentation/widgets/videos/videos_from_movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';

  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
    ref.read(watchProviderByMovieProvider.notifier).loadWatchProviders(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    //El Map está en el provider y va a mantener los datos de las pelis que ya se han consultado
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [_CustomSliverAppbar(movie: movie), SliverList(delegate: SliverChildBuilderDelegate((context, index) => _MovieDetails(movie: movie), childCount: 1))],
      ),
    );
  }
}

class _CustomSliverAppbar extends ConsumerWidget {
  final Movie movie;

  const _CustomSliverAppbar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));

    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.6,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async {
            // await ref.watch(localStorageRepositoryProvider)
            //   .toggleFavorite(movie);

            await ref.read(favoriteMoviesProvider.notifier).toggleFavorite(movie);

            //Esto invalida el estado actual del provider y lo vuelve a consultar
            ref.invalidate(isFavoriteProvider(movie.id));
          },
          icon: isFavoriteFuture.when(
            loading: () => const CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
            data: (isFavorite) => isFavorite ? const Icon(Icons.favorite_rounded, color: Colors.red, size: 30) : const Icon(Icons.favorite_border, size: 30),
            error: (_, __) => throw UnimplementedError(),
          ),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(bottom: 0),
        //Gradiente título
        title: const CustomGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [
          0.8,
          1.0
        ], colors: [
          Colors.transparent,
          Colors.black54,
        ]),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();
                  return FadeIn(child: child);
                },
              ),
            ),

            //Gradiente botón fav
            const CustomGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, stops: [
              0.0,
              0.2
            ], colors: [
              Colors.black54,
              Colors.transparent,
            ]),

            //Gradiente flecha atrás
            const CustomGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, stops: [
              0.0,
              0.3
            ], colors: [
              Colors.black54,
              Colors.transparent,
            ]),
          ],
        ),
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;

  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    movie.posterPath,
                    width: size.width * 0.3,
                  ),
                ),

                const SizedBox(height: 5.0),

                // Rating
                SizedBox(
                  width: 120,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star_half_outlined, color: Colors.yellow.shade800, size: 25),
                      const SizedBox(width: 2),
                      Text(movie.voteAverage.toStringAsPrecision(2), style: textStyle.titleMedium?.copyWith(color: Colors.yellow.shade800)),
                      // const Spacer(),
                      const SizedBox(width: 15.0),
                      Text(HumanFormats.number(movie.popularity), style: textStyle.titleMedium),
                    ],
                  ),
                ),

                SizedBox(
                  width: 120,
                  child: Text(
                    'Idioma original: ${movie.originalLanguage.toUpperCase()}',
                    style: textStyle.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ),

                //Fecha de estreno
                if (movie.releaseDate != null)
                  SizedBox(
                    width: 120,
                    child: Text(
                      '${movie.releaseDate!.day.toString().padLeft(2, '0')}/${movie.releaseDate!.month.toString().padLeft(2, '0')}/${movie.releaseDate!.year.toString().padLeft(4, '0')}',
                      style: textStyle.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: (size.width * 0.7) - 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyle.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                  if (movie.title != movie.originalTitle) Text(movie.originalTitle, style: textStyle.titleMedium!.copyWith(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 3.0),
                  // Text(movie.overview),
                  CustomReadMoreText(
                    text: movie.overview,
                    trimLines: 8,
                  ),
                ],
              ),
            ),
          ]),
        ),

        //PLATAFORMAS//
        _WatchProvidersByMovie(movieID: movie.id.toString()),
        //PLATAFORMAS//

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              ...movie.genreIds.map((gender) => Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Chip(
                      label: Text(gender),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                  ))
            ],
          ),
        ),

        //Actores
        ActorsByShow(showId: movie.id.toString()),

        //* Videos de la película (si tiene)
        VideosFromMovie(movieId: movie.id),

        //* Películas similares
        SimilarMovies(movieId: movie.id),

        // const SizedBox(height: 50)
      ],
    );
  }
}

class _WatchProvidersByMovie extends ConsumerWidget {
  final String movieID;
  const _WatchProvidersByMovie({required this.movieID});

  @override
  Widget build(BuildContext context, ref) {
    Map<String, List<WatchProvider>> providers = ref.watch(watchProviderByMovieProvider)[movieID] ?? {};

    final textStyle = Theme.of(context).textTheme;

    if (providers[movieID] == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Text('No disponible en ninguna plataforma', style: textStyle.bodyMedium!.copyWith(color: Colors.red)),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          ...providers[movieID]!.map((provider) => Container(
              margin: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () => showProviderNameToast(context, provider.providerName),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    provider.logoPath,
                    height: 40,
                  ),
                ),
              )))
        ],
      ),
    );
  }
}
