import 'package:cinemapedia/domain/entities/movie_collection.dart';
import 'package:cinemapedia/domain/entities/watch_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/similar_movies.dart';
import 'package:cinemapedia/presentation/widgets/shared/actors_by_show.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_gradient.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_read_more_text.dart';
import 'package:cinemapedia/presentation/widgets/shared/production_companies_by_show.dart';
import 'package:cinemapedia/presentation/widgets/shared/snack_bar.dart';
import 'package:cinemapedia/presentation/widgets/videos/videos_from_movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';

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
      expandedHeight: size.height * 0.25,
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
                movie.backdropPath,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    movie.posterPath,
                    width: size.width * 0.3,
                  ),
                ),

                if (movie.adult) Icon(Icons.explicit_outlined, color: Colors.red.shade800, size: 25),

                // Rating
                SizedBox(
                  width: 120,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.star_half_outlined, color: Colors.yellow.shade800, size: 25),
                      const SizedBox(width: 2),
                      Text(movie.voteAverage.toStringAsPrecision(2), style: textStyle.titleSmall?.copyWith(color: Colors.yellow.shade800)),
                      // const Spacer(),
                      const SizedBox(width: 15.0),
                      Text(HumanFormats.intNumber(movie.voteCount), style: textStyle.titleSmall),
                    ],
                  ),
                ),

                //Fecha de estreno
                if (movie.releaseDate != null)
                  SizedBox(
                    width: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.green,
                          size: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${movie.releaseDate!.day.toString().padLeft(2, '0')}/${movie.releaseDate!.month.toString().padLeft(2, '0')}/${movie.releaseDate!.year.toString().padLeft(4, '0')}',
                          style: textStyle.titleSmall,
                          maxLines: 2,
                          // textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                SizedBox(
                  width: 120,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.language_outlined,
                        color: Colors.blueAccent,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        movie.originalLanguage.toUpperCase(),
                        style: textStyle.titleSmall,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),

                // Duración
                if (movie.runtime != null)
                  SizedBox(
                      width: 120,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${movie.runtime} minutos',
                            style: textStyle.titleSmall,
                          ),
                        ],
                      )),

                // Presupuesto
                if (movie.budget != null && movie.budget != 0)
                  SizedBox(
                      width: 120,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.payment_outlined,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            HumanFormats.money(movie.budget!),
                            style: textStyle.titleSmall,
                          ),
                        ],
                      )),

                // Recaudación
                if (movie.revenue != null && movie.revenue != 0)
                  SizedBox(
                      width: 120,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.confirmation_num_outlined,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            HumanFormats.money(movie.revenue!),
                            style: textStyle.titleSmall,
                          ),
                        ],
                      )),

                //COLECCION
                if (movie.belongsToCollection != null) _CollectionByMovie(collection: movie.belongsToCollection!),
                //COLECCION
              ],
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: (size.width * 0.7) - 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyle.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                  if (movie.title != movie.originalTitle) Text(movie.originalTitle, style: textStyle.titleSmall!.copyWith(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                  if (movie.tagline != null && movie.tagline != "") Text('"${movie.tagline}"', style: textStyle.titleSmall!.copyWith(fontStyle: FontStyle.italic)),
                  const SizedBox(height: 3.0),
                  // Text(movie.overview),
                  CustomReadMoreText(
                    text: movie.overview,
                    trimLines: 8,
                    textStyle: textStyle.bodyLarge,
                  ),
                ],
              ),
            ),
          ]),
        ),

        //GÉNEROS
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
                      padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                    ),
                  ))
            ],
          ),
        ),

        //PRODUCTORA
        if (movie.productionCompanies != null && movie.productionCompanies != []) ProductionCompaniesByShow(companies: movie.productionCompanies!),
        //PRODUCTORA

        const SizedBox(height: 10.0),

        //PLATAFORMAS//
        _WatchProvidersByMovie(movieID: movie.id.toString()),
        //PLATAFORMAS//

        const SizedBox(height: 10.0),

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
    Map<String, Map<String, List<WatchProvider>>> providers = ref.watch(watchProviderByMovieProvider)[movieID] ?? {};

    final textStyle = Theme.of(context).textTheme;

    if (providers[movieID] == null || ((providers[movieID]!['buy']!.isEmpty) && (providers[movieID]!['rent']!.isEmpty) && (providers[movieID]!['flatrate']!.isEmpty))) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Text('No disponible en ninguna plataforma', style: textStyle.bodyMedium!.copyWith(color: Colors.red)),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(left: 20, top: 3, bottom: 5),
        //   child: Text('Disponible en', style: textStyle.titleLarge),
        // ),

        if (providers[movieID]!['flatrate']!.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 5, bottom: 2),
            child: Text('Disponible en', style: textStyle.titleLarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [...providers[movieID]!['flatrate']!.map((provider) => _WatchProviderIcon(provider: provider))],
            ),
          ),
        ],

        if (providers[movieID]!['buy']!.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 3, bottom: 2),
            child: Text('Comprar', style: textStyle.titleLarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [...providers[movieID]!['buy']!.map((provider) => _WatchProviderIcon(provider: provider))],
            ),
          ),
        ],
        if (providers[movieID]!['rent']!.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 5, bottom: 2),
            child: Text('Alquilar', style: textStyle.titleLarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [...providers[movieID]!['rent']!.map((provider) => _WatchProviderIcon(provider: provider))],
            ),
          ),
        ],
      ],
    );
  }
}

class _WatchProviderIcon extends StatelessWidget {
  final WatchProvider provider;

  const _WatchProviderIcon({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        width: 40,
        margin: const EdgeInsets.only(right: 10),
        child: GestureDetector(
          onTap: () => showProviderNameToast(context, provider.providerName),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(provider.logoPath, height: 40, fit: BoxFit.contain),
          ),
        ));
  }
}

// class _CollectionByMovie extends StatelessWidget {
//   final MovieCollection collection;

//   const _CollectionByMovie({required this.collection});

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;

//     return SizedBox(
//       width: 120,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           const SizedBox(height: 5),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(5),
//             child: Image.network(
//               collection.backdropPath!,
//               fit: BoxFit.cover,
//               width: double.infinity,
//               // height: 65,
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress != null) {
//                   return const DecoratedBox(
//                     decoration: BoxDecoration(color: Colors.black12),
//                   );
//                 }
//                 return GestureDetector(onTap: () => context.push('/home/0/collection/${collection.id}'), child: FadeIn(child: child));
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 5),
//             child: Text(collection.name, style: textTheme.titleSmall, textAlign: TextAlign.start, maxLines: 2),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _CollectionByMovie extends StatelessWidget {
  final MovieCollection collection;

  const _CollectionByMovie({required this.collection});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: 120,
      child: GestureDetector(
        onTap: () => context.push('/home/0/collection/${collection.id}'),
        child: Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.video_collection_outlined,
                size: 20,
              ),
              const SizedBox(width: 5),
              Text(
                'Ver colección',
                style: textTheme.titleMedium!.copyWith(color: colors.primary),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
