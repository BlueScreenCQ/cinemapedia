import 'package:cinemapedia/domain/entities/watch_provider.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/providers_reponse.dart';

class WatchProviderMapper {
  static List<WatchProvider> watchProviderToEntity(WatchProvidersResponse response) {
    List<WatchProvider> res = [];

    for (WatchProviderInfo wPinfo in response.flatrate) {
      res.add(WatchProvider(providerId: wPinfo.providerId, providerName: wPinfo.providerName, logoPath: 'https://image.tmdb.org/t/p/w200${wPinfo.logoPath}'));
    }

    return res;
  }
}
