import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/actors/actor_info_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/combined_credits_provider.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_read_more_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ActorScreen extends ConsumerStatefulWidget {
  static const name = 'actor-screen';

  final String actorId;

  const ActorScreen({super.key, required this.actorId});

  @override
  ActorScreenState createState() => ActorScreenState();
}

class ActorScreenState extends ConsumerState<ActorScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(actorInfoProvider.notifier).loadActor(widget.actorId);
    ref.read(combinedCreditsProvider.notifier).loadCombinedCredits(widget.actorId);
  }

  @override
  Widget build(BuildContext context) {
    //El Map está en el provider y va a mantener los datos de las pelis que ya se han consultado
    final Actor? actor = ref.watch(actorInfoProvider)[widget.actorId];

    if (actor == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(actor.name),
      ),
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) => _ActorDetails(actor: actor), childCount: 1),
          )
        ],
      ),
    );
  }
}

class _ActorDetails extends StatelessWidget {
  final Actor actor;

  const _ActorDetails({required this.actor});

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
                    actor.profilePath,
                    width: size.width * 0.3,
                  ),
                ),

                const SizedBox(height: 8.0),

                // // Rating
                // SizedBox(
                //   width: 120,
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.end,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Icon(Icons.star_half_outlined, color: Colors.yellow.shade800, size: 25),
                //       const SizedBox(width: 2),
                //       Text(movie.voteAverage.toStringAsPrecision(2), style: textStyle.titleMedium?.copyWith(color: Colors.yellow.shade800)),
                //       // const Spacer(),
                //       const SizedBox(width: 15.0),
                //       Text('${HumanFormats.number(movie.popularity)}', style: textStyle.titleMedium),
                //     ],
                //   ),
                // ),

                SizedBox(
                  width: 120,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.cake_outlined, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        '${actor.birthday!.day.toString().padLeft(2, '0')}/${actor.birthday!.month.toString().padLeft(2, '0')}/${actor.birthday!.year.toString().padLeft(4, '0')}',
                        style: textStyle.titleMedium,
                        // textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                if (actor.deatday != null)
                  SizedBox(
                    width: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.airline_seat_flat_angled_outlined,
                          size: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${actor.deatday!.day.toString().padLeft(2, '0')}/${actor.deatday!.month.toString().padLeft(2, '0')}/${actor.deatday!.year.toString().padLeft(4, '0')}',
                          style: textStyle.titleMedium,
                          maxLines: 2,
                          // textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: (size.width * 0.7) - 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(actor.name, style: textStyle.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        width: 3.0,
                      ),
                      if (actor.gender != null && actor.gender != 0)
                        _ActorGender(
                          gender: actor.gender!,
                        )
                    ],
                  ),
                  // Lugar de nacimiento
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.place_outlined, size: 20),
                      const SizedBox(width: 3),
                      Text(
                        actor.placeOfBirth!,
                        style: textStyle.titleSmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 3.0),
                  CustomReadMoreText(
                    text: actor.biography!,
                    trimLines: 8,
                  ),
                ],
              ),
            ),
          ]),
        ),
        _CombinedCreditsByActor(actorID: actor.id.toString()),
      ],
    );
  }
}

class _ActorGender extends StatelessWidget {
  final int gender;

  const _ActorGender({required this.gender});

  @override
  Widget build(BuildContext context) {
    IconData? icondata;

    switch (gender) {
      case 0:
        icondata = null;
        break;
      case 1:
        icondata = (Icons.female_outlined);
        break;
      case 2:
        icondata = (Icons.male_outlined);
        break;
      case 3:
        icondata = (Icons.transgender_outlined);
        break;
    }

    return Icon(icondata);
  }
}

class _CombinedCreditsByActor extends ConsumerWidget {
  final String actorID;

  const _CombinedCreditsByActor({required this.actorID});

  @override
  Widget build(BuildContext context, ref) {
    final textStyle = Theme.of(context).textTheme;

    final combinedCredits = ref.watch(combinedCreditsProvider);

    if (combinedCredits[actorID] == null) {
      return const CircularProgressIndicator(strokeWidth: 2);
    }

    final actors = combinedCredits[actorID]!['Cast'];
    final crew = combinedCredits[actorID]!['Crew'];
    final tv = combinedCredits[actorID]!['TV'] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, bottom: 3),
          child: Text('Filmografía', style: textStyle.titleLarge),
        ),

        //Movies
        SizedBox(
          height: 290,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: actors!.length,
              itemBuilder: (context, index) {
                final Movie movie = actors[index];

                return GestureDetector(
                  onTap: () => context.push('/home/0/movie/${movie.id}'),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: 135,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      //Movie Poster
                      MovieOrTVPoster(movie: movie),

                      const SizedBox(height: 5),

                      //Name
                      Text(
                        movie.title,
                        maxLines: 2,
                        style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                      ),

                      Text(
                        movie.character ?? '',
                        maxLines: 2,
                        style: const TextStyle(fontStyle: FontStyle.italic, overflow: TextOverflow.ellipsis),
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //*Date movie
                          if (movie.releaseDate != null && movie.releaseDate!.year != 1900) ...[
                            const Icon(Icons.calendar_month_outlined, size: 20),
                            const SizedBox(width: 2),
                            Text(
                              '${movie.releaseDate!.year}',
                              style: textStyle.bodySmall,
                            ),
                            const SizedBox(width: 15.0),
                          ],

                          //* Rating
                          if (movie.voteCount > 0) ...[
                            Icon(Icons.star_half_rounded, color: Colors.yellow.shade800, size: 20),
                            const SizedBox(width: 2),
                            Text(
                              HumanFormats.number(movie.voteAverage, 2),
                              style: textStyle.bodySmall!.copyWith(color: Colors.yellow.shade800),
                            )
                          ]
                        ],
                      )
                    ]),
                  ),
                );
              }),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 3),
          child: Text('TV', style: textStyle.titleLarge),
        ),

        //TV
        SizedBox(
          height: 290,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tv.length,
              itemBuilder: (context, index) {
                final Movie movie = tv[index];

                return GestureDetector(
                  onTap: () => context.push('/home/0/tv/${movie.id}'),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: 135,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      //Movie Poster
                      MovieOrTVPoster(movie: movie),

                      const SizedBox(height: 5),

                      //Name
                      Text(
                        (movie.mediaType == "movie") ? movie.title : movie.name!,
                        maxLines: 2,
                        style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                      ),

                      Text(
                        movie.character ?? '',
                        maxLines: 2,
                        style: const TextStyle(fontStyle: FontStyle.italic, overflow: TextOverflow.ellipsis),
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //*Date TV
                          if (movie.firstAirDate != null && movie.firstAirDate!.year != 1900) ...[
                            const Icon(Icons.calendar_month_outlined, size: 20),
                            const SizedBox(width: 2),
                            Text(
                              '${movie.firstAirDate!.year}',
                              style: textStyle.bodySmall,
                            ),
                            const SizedBox(width: 15.0),
                          ],

                          //* Rating
                          if (movie.voteCount > 0) ...[
                            Icon(Icons.star_half_rounded, color: Colors.yellow.shade800, size: 20),
                            const SizedBox(width: 2),
                            Text(
                              HumanFormats.number(movie.voteAverage, 2),
                              style: textStyle.bodySmall!.copyWith(color: Colors.yellow.shade800),
                            )
                          ]
                        ],
                      )
                    ]),
                  ),
                );
              }),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 3),
          child: Text('Crew', style: textStyle.titleLarge),
        ),

        //Crew
        SizedBox(
          height: 290,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: crew!.length,
              itemBuilder: (context, index) {
                final Movie movie = crew[index];

                return GestureDetector(
                  onTap: (movie.mediaType == "movie") ? () => context.push('/home/0/moive/${movie.id}') : () => context.push('/home/0/tv/${movie.id}'),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: 135,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      //Movie Poster
                      MovieOrTVPoster(movie: movie),

                      const SizedBox(height: 5),

                      //Name
                      Text(
                        (movie.mediaType == "movie") ? movie.title : movie.name!,
                        maxLines: 2,
                        style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                      ),

                      if (movie.job != null && movie.job != "")
                        Text(
                          movie.job ?? '',
                          maxLines: 2,
                          style: const TextStyle(overflow: TextOverflow.ellipsis),
                        ),

                      if (movie.department != null && movie.department != "")
                        Text(
                          '(${movie.department})',
                          maxLines: 2,
                          style: const TextStyle(overflow: TextOverflow.ellipsis),
                        ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //*Date TV
                          if (movie.mediaType == 'movie' && movie.releaseDate != null && movie.releaseDate!.year != 1900) ...[
                            const Icon(Icons.calendar_month_outlined, size: 20),
                            const SizedBox(width: 2),
                            Text(
                              '${movie.releaseDate!.year}',
                              style: textStyle.bodySmall,
                            ),
                            const SizedBox(width: 15.0),
                          ],

                          //*Date TV
                          if (movie.mediaType == 'tv' && movie.firstAirDate != null && movie.firstAirDate!.year != 1900) ...[
                            const Icon(Icons.calendar_month_outlined, size: 20),
                            const SizedBox(width: 2),
                            Text(
                              '${movie.firstAirDate!.year}',
                              style: textStyle.bodySmall,
                            ),
                            const SizedBox(width: 15.0),
                          ],

                          //* Rating
                          if (movie.voteCount > 0) ...[
                            Icon(Icons.star_half_rounded, color: Colors.yellow.shade800, size: 20),
                            const SizedBox(width: 2),
                            Text(
                              HumanFormats.number(movie.voteAverage, 2),
                              style: textStyle.bodySmall!.copyWith(color: Colors.yellow.shade800),
                            )
                          ]
                        ],
                      )
                    ]),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class MovieOrTVPoster extends StatelessWidget {
  const MovieOrTVPoster({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Image.network(
            movie.posterPath,
            height: 180,
            width: 135,
            fit: BoxFit.cover,
          ),

          // const CustomGradient(begin: Alignment.bottomLeft, end: Alignment.bottomRight, stops: [
          //   0.0,
          //   0.3
          // ], colors: [
          //   Colors.black54,
          //   Colors.transparent,
          // ]),

          Positioned(
              bottom: 5.0,
              right: 10.0,
              child: Icon(
                (movie.mediaType == "movie") ? Icons.movie_outlined : Icons.live_tv_outlined,
                color: Colors.white,
                size: 30,
                shadows: const [Shadow(color: Colors.black45, offset: Offset(2.0, 2.0))],
              ))
        ],
      ),
    );
  }
}
