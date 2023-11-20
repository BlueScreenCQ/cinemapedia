import 'package:cinemapedia/domain/entities/watch_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/watch_providers/watch_provider_repository_provider.dart';

final watchProviderByMovieProvider = StateNotifierProvider<WatchProviderByMovieNotifier, Map<String, Map<String, List<WatchProvider>>>>((ref) {
  final watchProviderRepository = ref.watch(watchProviderRepositoryProvider);

  return WatchProviderByMovieNotifier(getWatchProviders: watchProviderRepository.getWatchProviderById);
});

/*
{
  '506684' : Map<String, List<watchProvider>> providers,
  '506521' : Map<String, List<watchProvider>> providers,
  '506368' : Map<String, List<watchProvider>> providers,
  '506656' : Map<String, List<watchProvider>> providers,
  '506841' : Map<String, List<watchProvider>> providers,
}
*/

typedef GetWatchProvidersCallback = Future<Map<String, List<WatchProvider>>> Function(String movieID);

class WatchProviderByMovieNotifier extends StateNotifier<Map<String, Map<String, List<WatchProvider>>>> {
  final GetWatchProvidersCallback getWatchProviders;

  WatchProviderByMovieNotifier({required this.getWatchProviders}) : super({});

  Future<void> loadWatchProviders(String movieID) async {
    if (state[movieID.toString()] != null) return;

    final providers = await getWatchProviders(movieID);

    state = {...state, movieID.toString(): providers};
  }
}
