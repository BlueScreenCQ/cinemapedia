import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/datasources/actor_moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/actor_repository_imp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final combinedCreditsProvider = StateNotifierProvider<CombinedCreditsNotifier, Map<String, Map<String, List<Movie>>>>((ref) {
  final datasource = ActorRepositoryImp(ActorMovieDbDatasource());

  // return datasource.getCombinedCreditsOfActor(id);
  return CombinedCreditsNotifier(getCombinedCredits: datasource.getCombinedCreditsOfActor);
});

typedef GetCastCallback = Future<Map<String, List<Movie>>> Function(String actorID);

class CombinedCreditsNotifier extends StateNotifier<Map<String, Map<String, List<Movie>>>> {
  final GetCastCallback getCombinedCredits;

  CombinedCreditsNotifier({required this.getCombinedCredits}) : super({});

  Future<void> loadCombinedCredits(String actorID) async {
    if (state[actorID] != null) return;

    final credits = await getCombinedCredits(actorID);

    state = {...state, actorID: credits};
  }
}
