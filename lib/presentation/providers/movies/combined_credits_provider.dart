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

    splitMoviesAndTV(credits);

    orderCredits(credits);

    state = {...state, actorID: credits};
  }
}

Map<String, List<Movie>> orderCredits(Map<String, List<Movie>> credits) {
  credits['Cast']!.sort((a, b) => a.releaseDate!.compareTo(b.releaseDate!));
  credits['Cast'] = credits['Cast']!.reversed.toList();

  credits['TV']!.sort((a, b) => a.firstAirDate!.compareTo(b.firstAirDate!));
  credits['TV'] = credits['TV']!.reversed.toList();

  credits['Crew']!.sort((a, b) => (a.releaseDate ?? a.firstAirDate)!.compareTo(b.releaseDate!));
  credits['Crew'] = credits['Crew']!.reversed.toList();

  return credits;
}

Map<String, List<Movie>> splitMoviesAndTV(Map<String, List<Movie>> credits) {
  List<Movie> tv = [];

  for (int i = 0; i < credits['Cast']!.length; i++) {
    if (credits['Cast']![i].mediaType == "tv") {
      tv.add(credits['Cast']![i]);
    }
  }

  for (int i = 0; i < credits['Cast']!.length; i++) {
    if (credits['Cast']![i].mediaType == "tv") {
      credits['Cast']!.remove(credits['Cast']![i]);
    }
  }

  credits['TV'] = tv;

  return credits;
}
