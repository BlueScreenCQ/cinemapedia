import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:cinemapedia/presentation/providers/search/search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/actor.dart';

final searchedActorsProvider = StateNotifierProvider<SearchActorsNotifier, List<Actor>>((ref) {
  final actorsRepository = ref.read(actorsRepositoryProvider);

  return SearchActorsNotifier(searchActors: actorsRepository.searchActors, ref: ref);
});

typedef SearchActorsCallback = Future<List<Actor>> Function(String query);

class SearchActorsNotifier extends StateNotifier<List<Actor>> {
  final SearchActorsCallback searchActors;
  final Ref ref;

  SearchActorsNotifier({required this.searchActors, required this.ref}) : super([]);

  Future<List<Actor>> searchActorsByQuery(String query) async {
    final List<Actor> actors = await searchActors(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);

    state = actors;

    return actors;
  }
}
