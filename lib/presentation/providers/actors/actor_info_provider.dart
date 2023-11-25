import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorInfoProvider = StateNotifierProvider<ActorNotifier, Map<String, Actor>>((ref) {
  final actorRepository = ref.watch(actorsRepositoryProvider);

  return ActorNotifier(getActor: actorRepository.getActorById);
});

/*
{
  '506684' : Actor(),
  '506521' : Actor(),
  '506368' : Actor(),
  '506656' : Actor(),
  '506841' : Actor(),
}
*/

typedef GetActorCallback = Future<Actor> Function(String actorID);

class ActorNotifier extends StateNotifier<Map<String, Actor>> {
  final GetActorCallback getActor;

  ActorNotifier({required this.getActor}) : super({});

  Future<void> loadActor(String actorID) async {
    if (state[actorID] != null) return;

    final actor = await getActor(actorID);

    state = {...state, actorID: actor};
  }
}
