import 'package:cinemapedia/presentation/providers/watch_providers/watch_provider_by_tv_provider.dart';
import 'package:cinemapedia/presentation/widgets/shared/actors_by_show.dart';
import 'package:cinemapedia/presentation/widgets/shared/production_companies_by_show.dart';
import 'package:cinemapedia/presentation/widgets/shared/snack_bar.dart';
import 'package:cinemapedia/presentation/widgets/tv/season_expansion_panel_list.dart';
import 'package:flutter/material.dart';
import 'package:cinemapedia/domain/entities/watch_provider.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_gradient.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_read_more_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    ref.read(actorsBytvProvider.notifier).loadActors(widget.tvId);
    ref.read(watchProviderByTvProvider.notifier).loadWatchProviders(widget.tvId);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    tv.posterPath,
                    width: size.width * 0.3,
                  ),
                ),

                const SizedBox(height: 5.0),

                if (tv.adult) Icon(Icons.explicit_outlined, color: Colors.red.shade800, size: 25),

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
                      Text(tv.voteAverage.toStringAsPrecision(2), style: textStyle.titleSmall?.copyWith(color: Colors.yellow.shade800)),
                      // const Spacer(),
                      const SizedBox(width: 15.0),
                      Text(HumanFormats.intNumber(tv.voteCount), style: textStyle.titleSmall),
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
                          style: textStyle.titleSmall,
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
                        tv.originalLanguage.toUpperCase(),
                        style: textStyle.titleSmall,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),

                if (tv.status != null && tv.status != "") _tvStatus(status: tv.status),

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
                  if (tv.name != tv.originalName) Text(tv.originalName, style: textStyle.titleSmall!.copyWith(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                  if (tv.tagline != null && tv.tagline != "") Text('"${tv.tagline}"', style: textStyle.titleSmall!.copyWith(fontStyle: FontStyle.italic)),
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
                      padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                    ),
                  ))
            ],
          ),
        ),

        //PRODUCTORA
        if (tv.productionCompanies != null && tv.productionCompanies != []) ProductionCompaniesByShow(companies: tv.productionCompanies),
        //PRODUCTORA

        const SizedBox(height: 10.0),

        //PLATAFORMAS
        _WatchProvidersByTv(movieID: tv.id.toString()),
        //PLATAFORMAS

        const SizedBox(height: 10.0),

        if (tv.createdBy.isNotEmpty) _CreatedBy(tv: tv),

        //Actores
        ActorsByShow(showId: tv.id.toString(), isTV: true),

        _Seasons(tv: tv),

        //* Videos de la película (si tiene)
        // VideosFromMovie(movieId: tv.id),

        //* Películas similares
        // SimilarMovies(movieId: tv.id),

        const SizedBox(height: 50)
      ],
    );
  }
}

class _WatchProvidersByTv extends ConsumerWidget {
  final String movieID;
  const _WatchProvidersByTv({required this.movieID});

  @override
  Widget build(BuildContext context, ref) {
    Map<String, List<WatchProvider>> providers = ref.watch(watchProviderByTvProvider)[movieID] ?? {};

    final textStyle = Theme.of(context).textTheme;

    if (providers[movieID] == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Text('No disponible en ninguna plataforma', style: textStyle.bodyMedium!.copyWith(color: Colors.red)),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 3, bottom: 5),
          child: Text('Disponible en', style: textStyle.titleLarge),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              ...providers[movieID]!.map((provider) => Container(
                  height: 40,
                  width: 40,
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
        ),
      ],
    );
  }
}

class _CreatedBy extends StatelessWidget {
  final TV tv;
  const _CreatedBy({required this.tv});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    if (tv.createdBy == null || tv.createdBy == []) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5.0, left: 20.0),
          child: Text('Creada por', style: textStyle.titleLarge),
        ),

        //Crew
        SizedBox(
          height: 230,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tv.createdBy.length,
              itemBuilder: (context, index) {
                final Crew item = tv.createdBy[index];

                return GestureDetector(
                  onTap: () => context.push('/home/0/actor/${item.id}'),
                  child: Container(
                    padding: const EdgeInsets.only(top: 5.0, left: 8.0),
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
                    ]),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class _Seasons extends StatelessWidget {
  final TV tv;

  const _Seasons({required this.tv});

  @override
  Widget build(BuildContext context) {
    if (tv.seasons == null || tv.seasons == []) return Container();

    return SeasonExpansionPanelList(
      tvID: tv.id,
      seasons: tv.seasons,
    );
  }
}

class _tvStatus extends StatelessWidget {
  final String status;

  const _tvStatus({required this.status});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    String text;

    switch (status) {
      case 'Ended':
        text = "Serie finalizada";
        break;
      case 'Returning Series':
        text = 'Esperando nueva temporada';
        break;
      case 'Canceled':
        text = 'Serie cancelada';
        break;
      case 'In Production':
        text = 'En producción';
        break;
      default:
        text = status;
        break;
    }

    return SizedBox(
      width: 120,
      child: Text(
        text,
        style: textStyle.titleSmall,
        // textAlign: TextAlign.center,
      ),
    );
  }
}
