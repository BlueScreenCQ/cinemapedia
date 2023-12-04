import 'package:cinemapedia/presentation/providers/tv/tv_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

final searchTVQueryProvider = StateProvider<String>((ref) => '');

final searchedTVProvider = StateNotifierProvider<SearchTVNotifier, List<Movie>>((ref) {
  final tvRepository = ref.read(tvRepositoryProvider);

  return SearchTVNotifier(searhTV: tvRepository.searchTV, ref: ref);
});

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchTVNotifier extends StateNotifier<List<Movie>> {
  final SearchMoviesCallback searhTV;
  final Ref ref;

  SearchTVNotifier({required this.searhTV, required this.ref}) : super([]);

  Future<List<Movie>> searchMoviesByQuery(String query) async {
    final List<Movie> movies = await searhTV(query);
    ref.read(searchTVQueryProvider.notifier).update((state) => query);

    state = movies;

    return movies;
  }
}
