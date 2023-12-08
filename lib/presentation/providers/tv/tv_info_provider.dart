import 'package:cinemapedia/domain/entities/episode.dart';
import 'package:cinemapedia/domain/entities/tv.dart';
import 'package:cinemapedia/presentation/providers/tv/tv_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tvInfoProvider = StateNotifierProvider<TVMapNotifier, Map<String, TV>>((ref) {
  final tvRepository = ref.watch(tvRepositoryProvider);

  return TVMapNotifier(getTV: tvRepository.getTvById, getSeasons: tvRepository.getSeasonById);
});

/*
{
  '506684' : TV(),
  '506521' : TV(),
  '506368' : TV(),
  '506656' : TV(),
  '506841' : TV(),
}
*/

typedef GetTVCallback = Future<TV> Function(String tvID);
typedef GetSeasonCallback = Future<List<Episode>> Function(String tvID, int seasonNumber);

class TVMapNotifier extends StateNotifier<Map<String, TV>> {
  final GetTVCallback getTV;
  final GetSeasonCallback getSeasons;

  TVMapNotifier({required this.getTV, required this.getSeasons}) : super({});

  Future<void> loadTV(String tvID) async {
    if (state[tvID] != null) return;

    final tv = await getTV(tvID);

    state = {...state, tvID: tv};

    //Primero cargamos la serie para pintar la información y mientras tanto vamos cargando los capítulos de cada temporada

    //SEASONS
    if (tv.numberOfSeasons != null && tv.numberOfSeasons != 0) {
      for (int i = 0; i < tv.numberOfSeasons; i++) {
        if (tv.seasons[i] != null) {
          List<Episode> season = await getSeasons(tvID, tv.seasons[i].seasonNumber);
          tv.seasons[i].episodes = season;
        }
      }
    }

    for (int i = 0; i < tv.numberOfSeasons; i++) {
      state['tvID']!.seasons.add(tv.seasons[i]);
    }
  }
}
