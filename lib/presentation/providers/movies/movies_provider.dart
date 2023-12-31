import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowPlayingProvider = StateNotifierProvider<MoviesNotifier,List<Movie>>((ref) {

  final fetchMoreMoves = ref.watch(movieRepositoryProvider).getNowPlaying;
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMoves
  );
});

final trendingProvider = StateNotifierProvider<MoviesNotifier,List<Movie>>((ref) {

  final fetchMoreMoves = ref.watch(movieRepositoryProvider).getTrending;
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMoves
  );
});

final upcomingProvider = StateNotifierProvider<MoviesNotifier,List<Movie>>((ref) {

  final fetchMoreMoves = ref.watch(movieRepositoryProvider).getUpcoming;
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMoves
  );
});

final topRatedProvider = StateNotifierProvider<MoviesNotifier,List<Movie>>((ref) {

  final fetchMoreMoves = ref.watch(movieRepositoryProvider).getTopRated;
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMoves
  );
});



typedef MovieCallback = Future<List<Movie>>Function({int page});

class MoviesNotifier extends StateNotifier<List<Movie>> {

  int currentPage = 0;
  bool isLoading= false;
  MovieCallback fetchMoreMovies;
  
  MoviesNotifier({
    required this.fetchMoreMovies
  }) : super([]);


  Future<void> loadNextPage() async {

    if(isLoading) return;

    isLoading=true;

    currentPage++;

    final List<Movie> movies = await fetchMoreMovies(page: currentPage);

    state = [...state, ...movies];

    await Future.delayed(const Duration(milliseconds: 300));
    isLoading=false;
  }
}