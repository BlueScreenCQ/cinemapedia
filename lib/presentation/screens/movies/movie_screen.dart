import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/crew.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:animate_do/animate_do.dart';


import '../../providers/providers.dart';

class MovieScreen extends ConsumerStatefulWidget {

  static const name= 'movie-screen';

  final String movieId;

  const MovieScreen({
    super.key,
    required this.movieId
    });

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {

  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
    
    
  }

  @override
  Widget build(BuildContext context) {

    //El Map está en el provider y va a mantener los datos de las pelis que ya se han consultado
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null ) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(strokeWidth: 2)
          ),
      );
    }

    return Scaffold(
     body: CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        _CustomSliverAppbar(movie: movie),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _MovieDetails(movie: movie),
            childCount: 1
            )
          )
      ],
     ),
    );
  }

}

class _CustomSliverAppbar extends StatelessWidget {

    final Movie movie;
  
    const _CustomSliverAppbar({required this.movie});

    @override
    Widget build(BuildContext context) {

      final size = MediaQuery.of(context).size;

      return SliverAppBar(
        backgroundColor: Colors.black,
        expandedHeight: size.height * 0.6,
        foregroundColor: Colors.white,
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          // title: Text(
          //   movie.title,
          //   style: const TextStyle(fontSize: 20),
          //   textAlign: TextAlign.start,
          //   ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const  SizedBox();
                  return FadeIn(
                    child: child
                    );
                },
              ),
            ),

            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                   gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [ 0.7, 1.0 ],
                    colors: [
                      Colors.transparent,
                      Colors.black87,
                    ]
                   )
                  )
                ),
            ),

            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                   gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    stops: [ 0.0, 0.3 ],
                    colors: [
                      Colors.black87,
                      Colors.transparent,
                    ]
                   )
                  )
                ),
            )

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
    
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
                        Icon( Icons.star_half_outlined, color: Colors.yellow.shade800, size: 25),
                        const SizedBox(width: 2),
                        Text(movie.voteAverage.toStringAsPrecision(2), style: textStyle.titleMedium?.copyWith( color: Colors.yellow.shade800 )),
                        // const Spacer(),
                        const SizedBox(width: 15.0),
                        Text( HumanFormats.number(movie.popularity), style: textStyle.titleMedium ),                  
                        ],
                      ),
                    ),

                  if(movie.releaseDate != null)
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
    
              const SizedBox( width: 10),
    
              SizedBox(
                width: (size.width * 0.7) - 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title, style: textStyle.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3.0),
                    Text(movie.overview),
                  ],
                ),
              ),
    
            ]
            ),
          ),
    
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                ...movie.genreIds.map((gender) => Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Chip(
                    label: Text(gender),
                    shape: RoundedRectangleBorder (borderRadius: BorderRadius.circular(15)),
                    ),
                ))
              ],
            ),
            ),
    
            //TODO: HACER CLICABLES LOS GÉNEROS, PELÍCULAS SIMILARES
    
          _ActorsByMovie(movieID: movie.id.toString()),
    
      
      
        const SizedBox(height: 50)
      ],
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
            height:260,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: actors!.length,
              itemBuilder: (context, index) {
                final Actor actor = actors[index];

                return Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 135,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //Actor photo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          actor.profilePath!,
                          height: 180,
                          width: 135,
                          fit: BoxFit.cover,

                        ),
                      ),

                      const SizedBox(height: 5),
            
                      //Name
                      Text(actor.character ?? '',
                      maxLines: 2,
                      style: TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis ),
                      ),
                      Text(actor.name,
                      maxLines: 2,
                      style: TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                  ]
                  ),
              );
            }
            ),
          ),

          //Crew 
          SizedBox(
            height:290,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: crew!.length,
              itemBuilder: (context, index) {
                final Crew item = crew[index];

                return Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 135,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

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
                      Text(item.name,
                      maxLines: 2,
                      style: TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis ),
                      ),

                      Text(item.job ?? '',
                      maxLines: 2,
                      style: TextStyle(overflow: TextOverflow.ellipsis ),
                      ),

                      if(item.departament != null)
                        Text('(${item.departament})',
                        maxLines: 2,
                        style: TextStyle(overflow: TextOverflow.ellipsis ),
                        ),
                  ]
                  ),
              );
            }
            ),
          ),
      ],
    );

    
  }
}