import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_collection.dart';
import 'package:cinemapedia/presentation/providers/collections/collection_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final collectionInfoProvider = StateNotifierProvider<CollectionMapNotifier, Map<String, MovieCollection>>((ref) {
  final collectionRepository = ref.watch(collectionRepositoryProvider);

  return CollectionMapNotifier(getCollection: collectionRepository.getMovieCollectionById);
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

typedef GetCollectionCallback = Future<MovieCollection> Function(String collectionID);

class CollectionMapNotifier extends StateNotifier<Map<String, MovieCollection>> {
  final GetCollectionCallback getCollection;

  CollectionMapNotifier({required this.getCollection}) : super({});

  Future<void> loadMovieCollection(String collectionID) async {
    if (state[collectionID] != null) return;

    MovieCollection collection = await getCollection(collectionID);

    if (collection.parts != null) orderMovies(collection.parts!);

    state = {...state, collectionID: collection};
  }
}

List<Movie> orderMovies(List<Movie> movies) {
  movies.sort((a, b) => a.releaseDate!.compareTo(b.releaseDate!));
  // movies = movies.reversed.toList();

  return movies;
}
