import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsBytvProvider = StateNotifierProvider<ActorsByTvNotifier, Map<String, Map<String, List<dynamic>>>>((ref) {
  final actorRepository = ref.watch(actorsRepositoryProvider);

  return ActorsByTvNotifier(getActors: actorRepository.getActorsByTV);
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

typedef GetActorsTVCallback = Future<Map<String, List<dynamic>>> Function(String tvId);

class ActorsByTvNotifier extends StateNotifier<Map<String, Map<String, List<dynamic>>>> {
  final GetActorsTVCallback getActors;

  ActorsByTvNotifier({required this.getActors}) : super({});

  Future<void> loadActors(String tvId) async {
    if (state[tvId] != null) return;

    final elenco = await getActors(tvId);

    state = {...state, tvId: elenco};
  }
}
