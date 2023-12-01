import 'package:cinemapedia/domain/entities/tv.dart';
import 'package:cinemapedia/presentation/providers/tv/tv_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tvInfoProvider = StateNotifierProvider<TVMapNotifier, Map<String, TV>>((ref) {
  final tvRepository = ref.watch(tvRepositoryProvider);

  return TVMapNotifier(getTV: tvRepository.getTvById);
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

typedef GetTVCallback = Future<TV> Function(String movieID);

class TVMapNotifier extends StateNotifier<Map<String, TV>> {
  final GetTVCallback getTV;

  TVMapNotifier({required this.getTV}) : super({});

  Future<void> loadTV(String tvID) async {
    if (state[tvID] != null) return;

    final tv = await getTV(tvID);

    state = {...state, tvID: tv};
  }
}
