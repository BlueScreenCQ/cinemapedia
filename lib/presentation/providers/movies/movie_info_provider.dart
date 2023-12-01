import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  final movieRepository = ref.watch(movieRepositoryProvider);

  return MovieMapNotifier(getMovie: movieRepository.getMovieById);
});

/*
{
  '506684' : Movie(),
  '506521' : Movie(),
  '506368' : Movie(),
  '506656' : Movie(),
  '506841' : Movie(),
}
*/

typedef GetMovieCallback = Future<Movie> Function(String movieID);

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallback getMovie;

  MovieMapNotifier({required this.getMovie}) : super({});

  Future<void> loadMovie(String movieID) async {
    if (state[movieID] != null) return;

    final movie = await getMovie(movieID);

    state = {...state, movieID: movie};
  }
}
