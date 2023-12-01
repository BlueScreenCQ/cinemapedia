import 'package:flutter/material.dart';
import 'package:cinemapedia/domain/entities/watch_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/similar_movies.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_gradient.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_read_more_text.dart';
import 'package:cinemapedia/presentation/widgets/videos/videos_from_movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/crew.dart';
import 'package:cinemapedia/domain/entities/tv.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:go_router/go_router.dart';

class TVScreen extends ConsumerStatefulWidget {
  static const name = 'tv-screen';

  final String tvId;

  const TVScreen({super.key, required this.tvId});

  @override
  TVScreenState createState() => TVScreenState();
}

class TVScreenState extends ConsumerState<TVScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(tvInfoProvider.notifier).loadTV(widget.tvId);
    // ref.read(actorsByMovieProvider.notifier).loadActors(widget.tvId);
    // ref.read(watchProviderByMovieProvider.notifier).loadWatchProviders(widget.tvId);
  }

  @override
  Widget build(BuildContext context) {
    //El Map está en el provider y va a mantener los datos de las pelis que ya se han consultado
    final TV? tv = ref.watch(tvInfoProvider)[widget.tvId];

    if (tv == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [_CustomSliverAppbar(tv: tv), SliverList(delegate: SliverChildBuilderDelegate((context, index) => _TVDetails(tv: tv), childCount: 1))],
      ),
    );
  }
}

class _CustomSliverAppbar extends ConsumerWidget {
  final TV tv;

  const _CustomSliverAppbar({required this.tv});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavoriteFuture = ref.watch(isFavoriteProvider(tv.id));

    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.6,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () {},
          // onPressed: () async {
          //   // await ref.watch(localStorageRepositoryProvider)
          //   //   .toggleFavorite(movie);

          //   await ref.read(favoriteMoviesProvider.notifier).toggleFavorite(tv); //TODO ARREGLAR

          //   //Esto invalida el estado actual del provider y lo vuelve a consultar
          //   ref.invalidate(isFavoriteProvider(tv.id));
          // },
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
                tv.posterPath,
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

class _TVDetails extends StatelessWidget {
  final TV tv;

  const _TVDetails({required this.tv});

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
                    tv.posterPath,
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
                      Text(tv.voteAverage.toStringAsPrecision(2), style: textStyle.titleMedium?.copyWith(color: Colors.yellow.shade800)),
                      // const Spacer(),
                      const SizedBox(width: 15.0),
                      Text(HumanFormats.number(tv.popularity), style: textStyle.titleMedium),
                    ],
                  ),
                ),

                //Fecha de estreno
                if (tv.firstAirDate != null)
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
                          '${tv.firstAirDate!.day.toString().padLeft(2, '0')}/${tv.firstAirDate!.month.toString().padLeft(2, '0')}/${tv.firstAirDate!.year.toString().padLeft(4, '0')}',
                          style: textStyle.titleMedium,
                          maxLines: 2,
                          // textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                //Fecha de fin
                if (tv.lastAirDate != null)
                  SizedBox(
                    width: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${tv.lastAirDate!.day.toString().padLeft(2, '0')}/${tv.lastAirDate!.month.toString().padLeft(2, '0')}/${tv.lastAirDate!.year.toString().padLeft(4, '0')}',
                          style: textStyle.titleMedium,
                          maxLines: 2,
                          // textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                SizedBox(
                  width: 120,
                  child: Text(
                    'Idioma original: ${tv.originalLanguage.toUpperCase()}',
                    style: textStyle.titleSmall,
                    textAlign: TextAlign.start,
                  ),
                ),

                SizedBox(
                  width: 120,
                  child: Text(
                    'Nº temporadas: ${tv.numberOfSeasons}',
                    style: textStyle.titleSmall,
                    textAlign: TextAlign.start,
                  ),
                ),

                SizedBox(
                  width: 120,
                  child: Text(
                    'Nº episodios: ${tv.numberOfEpisodes}',
                    style: textStyle.titleSmall,
                    textAlign: TextAlign.start,
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
                  Text(tv.name, style: textStyle.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                  if (tv.name != tv.originalName) Text(tv.originalName, style: textStyle.titleMedium!.copyWith(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 3.0),
                  // Text(movie.overview),
                  CustomReadMoreText(
                    text: tv.overview,
                    trimLines: 8,
                  ),
                ],
              ),
            ),
          ]),
        ),

        //PLATAFORMAS
        // _WatchProvidersByMovie(movieID: tv.id.toString()),
        //PLATAFORMAS

        //*Géneros
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              ...tv.genreIds.map((gender) => Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Chip(
                      label: Text(gender),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                  ))
            ],
          ),
        ),

        _ActorsByMovie(movieID: tv.id.toString()),

        //* Videos de la película (si tiene)
        // VideosFromMovie(movieId: tv.id),

        //* Películas similares
        // SimilarMovies(movieId: tv.id),

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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  provider.logoPath,
                  height: 40,
                ),
              )))
        ],
      ),
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieID;

  const _ActorsByMovie({required this.movieID});

  @override
  Widget build(BuildContext context, ref) {
    final textStyle = Theme.of(context).textTheme;

    final actorsByMovie = ref.watch(actorsByMovieProvider);

    if (actorsByMovie[movieID] == null) {
      return const CircularProgressIndicator(strokeWidth: 2);
    }

    final actors = actorsByMovie[movieID]!['Actors'];
    final crew = actorsByMovie[movieID]!['Crew'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 3, bottom: 3),
          child: Text('Reparto', style: textStyle.titleLarge),
        ),

        //Actors
        SizedBox(
          height: 280,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: actors!.length,
              itemBuilder: (context, index) {
                final Actor actor = actors[index];

                return GestureDetector(
                  onTap: () => context.push('/home/0/actor/${actor.id}'),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: 135,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      //Actor photo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          actor.profilePath,
                          height: 180,
                          width: 135,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 5),

                      //Name
                      Text(
                        actor.name,
                        maxLines: 2,
                        style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                      ),
                      Text(
                        actor.character ?? '',
                        maxLines: 2,
                        style: const TextStyle(fontStyle: FontStyle.italic, overflow: TextOverflow.ellipsis),
                      ),
                    ]),
                  ),
                );
              }),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 20, top: 3, bottom: 3),
          child: Text('Crew', style: textStyle.titleLarge),
        ),

        //Crew
        SizedBox(
          height: 290,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: crew!.length,
              itemBuilder: (context, index) {
                final Crew item = crew[index];

                return Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 135,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    //Actor photo
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        item.profilePath!,
                        height: 180,
                        width: 135,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 5),

                    //Name
                    Text(
                      item.name,
                      maxLines: 2,
                      style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                    ),

                    Text(
                      item.job ?? '',
                      maxLines: 2,
                      style: const TextStyle(overflow: TextOverflow.ellipsis),
                    ),

                    if (item.department != null)
                      Text(
                        '(${item.department})',
                        maxLines: 2,
                        style: const TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                  ]),
                );
              }),
        ),
      ],
    );
  }
}
