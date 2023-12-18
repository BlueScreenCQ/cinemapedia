import 'dart:async';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:animate_do/animate_do.dart';

typedef SearchMovieCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMovieCallback searchMovies;
  List<Movie> initialMovies;
  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  StreamController<bool> isLoading = StreamController.broadcast();
  bool esTv;

  Timer? _debounceTimer;

  SearchMovieDelegate({required this.searchMovies, required this.initialMovies, this.esTv = false});

  void clearStream() {
    debounceMovies.close();
    isLoading.close();
  }

  void _onQueryChange(String query) {
    isLoading.add(true);

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      // if(query.isEmpty) {
      //   debounceMovies.add([]);
      //   return;
      // }

      final movies = await searchMovies(query);

      debounceMovies.add(movies);
      initialMovies = movies;

      isLoading.add(false);
    });
  }

  @override
  String get searchFieldLabel => (esTv) ? 'Buscar TV y series' : 'Buscar películas';

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: debounceMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) => _MovieSearchItem(
                movie: movies[index],
                onMovieSelected: (context, movie) {
                  clearStream();
                  close(context, movie);
                }));
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
          stream: isLoading.stream,
          initialData: false,
          builder: (context, snapshot) {
            if (snapshot.data ?? false) {
              return SpinPerfect(
                duration: const Duration(seconds: 10),
                infinite: true,
                spins: 10,
                child: IconButton(onPressed: () => query = '', icon: const Icon(Icons.refresh_rounded)),
              );
            }

            return FadeIn(
              animate: query.isNotEmpty,
              child: IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear_rounded)),
            );
          }),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          clearStream();
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded));
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Controlar el disparo de querys
    _onQueryChange(query);

    return buildResultsAndSuggestions();
  }
}

class _MovieSearchItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;

  const _MovieSearchItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage(
                  height: 130,
                  fit: BoxFit.cover,
                  image: NetworkImage(movie.posterPath),
                  placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      // movie.mediaType == 'movie' ? movie.title : movie.name!,
                      movie.title != "" ? movie.title : movie.name!,
                      style: textStyles.titleMedium),
                  (movie.overview.length >= 150) ? Text('${movie.overview.substring(0, 150)}...') : Text(movie.overview),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      if (movie.releaseDate != null) ...[
                        const Icon(Icons.calendar_month_outlined),
                        const SizedBox(width: 2),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Text('${movie.releaseDate!.year}'),
                        ),
                        const SizedBox(width: 15.0),
                      ],
                      if (movie.firstAirDate != null) ...[
                        const Icon(Icons.calendar_month_outlined),
                        const SizedBox(width: 2),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Text('${movie.firstAirDate!.year}'),
                        ),
                        const SizedBox(width: 15.0),
                      ],
                      if (movie.voteCount > 0) ...[
                        Icon(Icons.star_half_rounded, color: Colors.yellow.shade800),
                        const SizedBox(width: 2),
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            HumanFormats.number(movie.voteAverage, 2),
                            style: textStyles.bodyMedium!.copyWith(color: Colors.yellow.shade800),
                          ),
                        )
                      ]
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
