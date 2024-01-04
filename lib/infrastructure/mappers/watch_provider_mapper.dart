import 'package:cinemapedia/domain/entities/watch_provider.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/providers_reponse.dart';

class WatchProviderMapper {
  static Map<String, List<WatchProvider>> watchProviderToEntity(WatchProvidersResponse response) {
    Map<String, List<WatchProvider>> res = {};

    List<WatchProvider> flatrate = [];
    List<WatchProvider> buy = [];
    List<WatchProvider> rent = [];

    for (WatchProviderInfo wPinfo in response.flatrate) {
      flatrate.add(WatchProvider(providerId: wPinfo.providerId, providerName: wPinfo.providerName, logoPath: 'https://image.tmdb.org/t/p/w200${wPinfo.logoPath}'));
    }

    for (WatchProviderInfo wPinfo in response.buy) {
      buy.add(WatchProvider(providerId: wPinfo.providerId, providerName: wPinfo.providerName, logoPath: 'https://image.tmdb.org/t/p/w200${wPinfo.logoPath}'));
    }

    for (WatchProviderInfo wPinfo in response.rent) {
      rent.add(WatchProvider(providerId: wPinfo.providerId, providerName: wPinfo.providerName, logoPath: 'https://image.tmdb.org/t/p/w200${wPinfo.logoPath}'));
    }

    if (flatrate != []) res['flatrate'] = flatrate;
    if (buy != []) res['buy'] = buy;
    if (rent != []) res['rent'] = rent;

    return res;
  }
}
