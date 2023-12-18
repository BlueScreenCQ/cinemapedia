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
  Widget build(BuildContext context) {
    //El Map está en el provider y va a mantener los datos de las pelis que ya se han consultado

    final TV? tv = ref.watch(tvInfoProvider)[widget.tvId];
    Episode? episode;
    String posterURL = "";

    if (tv == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    int i;

    //Buscamos el episodio por su número
    for (i = 0; i < tv.seasons.length; i++) {
      if (tv.seasons[i].seasonNumber == widget.seasonNumber) {
        for (int j = 0; j < tv.seasons[i].episodes.length; j++) {
          if (tv.seasons[i].episodes[j].episodeNumber == widget.episodeNumber) {
            episode = tv.seasons[i].episodes[j];
            posterURL = (tv.seasons[i].posterPath != 'no-poster') ? tv.seasons[i].posterPath : tv.posterPath;
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
        slivers: [_CustomSliverAppbar(tv: tv, posterURL: posterURL), SliverList(delegate: SliverChildBuilderDelegate((context, index) => _EpisodeDetails(tv: tv, episode: episode!), childCount: 1))],
      ),
    );
  }
}

class _CustomSliverAppbar extends ConsumerWidget {
  final TV tv;
  final String posterURL;

  const _CustomSliverAppbar({required this.tv, required this.posterURL});

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
                posterURL,
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

class _EpisodeDetails extends StatelessWidget {
  final TV tv;
  final Episode episode;

  const _EpisodeDetails({required this.tv, required this.episode});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10.0),
            child: Text(tv.name, style: textStyle.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text('${episode.seasonNumber}x${episode.episodeNumber.toString().padLeft(2, '0')} - ${episode.name}', style: textStyle.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10.0),
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: (episode.stillPath != 'no-poster')
                  ? Image.network(
                      episode.stillPath,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 220,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.secondaryContainer,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.live_tv_outlined,
                            size: 60,
                          ),
                        ),
                      ),
                    )),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: CustomReadMoreText(
              text: episode.overview,
              textStyle: textStyle.bodyLarge,
              trimLines: 10,
            ),
          ),

          const SizedBox(height: 8.0),

          if (episode.episodeType == "finale") _episodeType(type: episode.episodeType),

          const SizedBox(height: 8.0),

          // Rating
          SizedBox(
            width: 300,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.star_half_outlined, color: Colors.yellow.shade800, size: 30),
                const SizedBox(width: 2),
                Text(tv.voteAverage.toStringAsPrecision(2), style: textStyle.titleLarge?.copyWith(color: Colors.yellow.shade800)),
                // Text('${HumanFormats.intNumber(tv.voteCount)} veces valorado', style: textStyle.titleLarge),
              ],
            ),
          ),

          const SizedBox(height: 8.0),

          // Fecha de estreno
          if (episode.airDate != null)
            SizedBox(
                width: 200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 30,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${episode.airDate!.day.toString().padLeft(2, '0')}/${episode.airDate!.month.toString().padLeft(2, '0')}/${episode.airDate!.year.toString().padLeft(4, '0')}',
                      style: textStyle.titleLarge,
                    ),
                  ],
                )),

          const SizedBox(height: 8.0),

          // Duración
          if (episode.runtime != null)
            SizedBox(
                width: 200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      size: 30,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${episode.runtime} minutos',
                      style: textStyle.titleLarge,
                    ),
                  ],
                )),

          const SizedBox(height: 15.0),

          if (episode.guestStars != null && episode.guestStars.isNotEmpty) ...[
            _GuestStars(actors: episode.guestStars),
          ],
          if (episode.crew != null && episode.crew.isNotEmpty) ...[
            _Crew(crew: episode.crew),
          ],
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}

class _GuestStars extends StatelessWidget {
  final List<Actor> actors;

  const _GuestStars({required this.actors});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 20, top: 3, bottom: 3),
        child: Text('Reparto del episodio', style: textStyle.titleLarge),
      ),

      //Actors
      SizedBox(
        height: 260,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: actors.length,
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
    ]);
  }
}

class _Crew extends StatelessWidget {
  final List<Crew> crew;

  const _Crew({required this.crew});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 3),
          child: Text('Equipo de producción', style: textStyle.titleLarge),
        ),

        //Crew
        SizedBox(
          height: 290,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: crew.length,
              itemBuilder: (context, index) {
                final Crew item = crew[index];

                return GestureDetector(
                  onTap: () => context.push('/home/0/actor/${item.id}'),
                  child: Container(
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
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class _episodeType extends StatelessWidget {
  final String type;

  const _episodeType({required this.type});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Chip(
      backgroundColor: Colors.blueGrey[200],
      labelPadding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
      label: Text(
        'Season Finale',
        style: textStyle.labelLarge!.copyWith(color: Colors.black87, fontSize: 18),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}
