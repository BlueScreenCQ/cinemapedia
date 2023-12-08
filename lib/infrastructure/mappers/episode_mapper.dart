import 'package:cinemapedia/domain/entities/episode.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_episode_response.dart';

class EpisodeMapper {
  static Episode episodeFromMovieDBToEntity(EpisodeResponse movieDB) => Episode(
        id: movieDB.id,
        name: movieDB.name,
        overview: movieDB.overview,
        voteAverage: movieDB.voteAverage,
        voteCount: movieDB.voteCount,
        airDate: movieDB.airDate,
        episodeNumber: movieDB.episodeNumber,
        episodeType: movieDB.episodeType,
        productionCode: movieDB.productionCode,
        // runtime: movieDB.runtime,
        seasonNumber: movieDB.seasonNumber,
        showId: movieDB.showId,
        stillPath: (movieDB.stillPath != '') ? 'https://image.tmdb.org/t/p/w500${movieDB.stillPath}' : 'https://sd.keepcalms.com/i/keep-calm-poster-not-found.png',
      );
}
