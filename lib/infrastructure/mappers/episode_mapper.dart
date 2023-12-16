import 'package:cinemapedia/domain/entities/episode.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/crew.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';
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
        runtime: movieDB.runtime,
        seasonNumber: movieDB.seasonNumber,
        showId: movieDB.showId,
        stillPath: (movieDB.stillPath != '') ? 'https://image.tmdb.org/t/p/w500${movieDB.stillPath}' : 'https://sd.keepcalms.com/i/keep-calm-poster-not-found.png',
        guestStars: movieDB.guestStars
            .map<Actor>((Cast e) => Actor(
                id: e.id,
                name: e.name,
                profilePath: (e.profilePath != null)
                    ? 'https://image.tmdb.org/t/p/w500${e.profilePath}'
                    : 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg',
                character: e.character))
            .toList(),
        crew: List<Crew>.from(movieDB.crew.map<Crew>((Cast e) => Crew(
            id: e.id,
            name: e.name,
            profilePath: (e.profilePath != null)
                ? 'https://image.tmdb.org/t/p/w500${e.profilePath}'
                : 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg',
            department: e.department,
            job: e.job))),
      );
}
