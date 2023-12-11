import 'package:cinemapedia/domain/entities/episode.dart';
import 'package:cinemapedia/domain/entities/tv.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_gradient.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_read_more_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/crew.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:go_router/go_router.dart';

class EpisodeScreen extends ConsumerStatefulWidget {
  static const name = 'episode-screen';

  final String tvId;
  final int seasonNumber;
  final int episodeNumber;

  const EpisodeScreen({super.key, required this.tvId, required this.seasonNumber, required this.episodeNumber});

  @override
  EpisodeScreenState createState() => EpisodeScreenState();
}

class EpisodeScreenState extends ConsumerState<EpisodeScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(tvInfoProvider.notifier).loadTV(widget.tvId);

    // ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    // ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
    // ref.read(watchProviderByMovieProvider.notifier).loadWatchProviders(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    //El Map está en el provider y va a mantener los datos de las pelis que ya se han consultado

    final TV? tv = ref.watch(tvInfoProvider)[widget.tvId];
    Episode? episode;

    if (tv == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    //Buscamos el episodio por su número
    for (int i = 0; i < tv.seasons.length; i++) {
      if (tv.seasons[i].seasonNumber == widget.seasonNumber) {
        for (int j = 0; j < tv.seasons[i].episodes.length; j++) {
          if (tv.seasons[i].episodes[j].episodeNumber == widget.episodeNumber) {
            episode = tv.seasons[i].episodes[j];
          }
        }
      }
    }

    if (episode == null) {
      return Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Lo sentimos, no hemos encontrado el episodio que buscabas',
            ),
            const SizedBox(height: 10.0),
            FilledButton.tonal(
              onPressed: () => context.go('/home/0'),
              child: const Text('Volver'),
            )
          ],
        )),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [_CustomSliverAppbar(tv: tv), SliverList(delegate: SliverChildBuilderDelegate((context, index) => _MovieDetails(tv: tv, episode: episode!), childCount: 1))],
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
          onPressed: () async {},
          // await ref.watch(localStorageRepositoryProvider)
          //   .toggleFavorite(movie);

          // await ref.read(favoriteMoviesProvider.notifier).toggleFavorite(tv); //TODO ARREGLAR

          //Esto invalida el estado actual del provider y lo vuelve a consultar
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

class _MovieDetails extends StatelessWidget {
  final TV tv;
  final Episode episode;

  const _MovieDetails({required this.tv, required this.episode});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(tv.name, style: textStyle.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text('${episode.seasonNumber}x${episode.episodeNumber.toString().padLeft(2, '0')} - ${episode.name}', style: textStyle.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 5.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              episode.stillPath,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10.0),
          CustomReadMoreText(
            text: tv.overview,
            textStyle: textStyle.bodyLarge,
            trimLines: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 5.0),

                // Rating
                SizedBox(
                  width: 120,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
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

                // Fecha de estreno
                if (episode.airDate != null)
                  SizedBox(
                      width: 120,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            size: 15,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${episode.airDate!.day.toString().padLeft(2, '0')}/${episode.airDate!.month.toString().padLeft(2, '0')}/${episode.airDate!.year.toString().padLeft(4, '0')}',
                            style: textStyle.titleMedium,
                          ),
                        ],
                      )),
              ],
            ),
            const SizedBox(width: 10),
          ]),
        ],
      ),
    );
  }
}
