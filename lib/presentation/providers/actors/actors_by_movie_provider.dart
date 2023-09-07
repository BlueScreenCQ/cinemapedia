import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier, Map<String,Map<String, List<dynamic>>>> ((ref) {

  final actorRepository = ref.watch(actorsRepositoryProvider);

  return ActorsByMovieNotifier(getActors: actorRepository.getActorsByMovie);
});


/*
{
  '506684' : Map<String, List<dynamic>> elenco,
  '506521' : Map<String, List<dynamic>> elenco,
  '506368' : Map<String, List<dynamic>> elenco,
  '506656' : Map<String, List<dynamic>> elenco,
  '506841' : Map<String, List<dynamic>> elenco,
}
*/

typedef GetActorsCallback = Future<Map<String, List<dynamic>>> Function(String movieID);

class ActorsByMovieNotifier extends StateNotifier<Map<String,Map<String, List<dynamic>>>> {

  final GetActorsCallback getActors;

  ActorsByMovieNotifier({
    required this.getActors
  }) : super({});


  Future<void> loadActors (String movieID) async {

    if(state[movieID] != null ) return;

    final elenco = await getActors (movieID);

    state = {...state, movieID:elenco}; 
  }
}