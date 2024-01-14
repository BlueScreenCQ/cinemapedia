import 'package:cinemapedia/domain/entities/crew.dart';
import 'package:cinemapedia/domain/entities/tv.dart';
import 'package:cinemapedia/domain/entities/season.dart' as entity_season;
import 'package:cinemapedia/domain/entities/watch_provider.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/tv_details_moviedb.dart';

class TVMapper {
  static TV tvfromMovieDBToEntity(TvResponse movieDB) => TV(
        adult: movieDB.adult,
        backdropPath: (movieDB.backdropPath != '')
            ? 'https://image.tmdb.org/t/p/w500${movieDB.backdropPath}'
            : 'https://st2.depositphotos.com/1000434/10200/i/450/depositphotos_102007848-stock-photo-grunge-background-with-filmstrip.jpg',
        createdBy: movieDB.createdBy
            .map((e) => Crew(
                id: e.id,
                name: e.name,
                profilePath: (e.profilePath != null)
                    ? 'https://image.tmdb.org/t/p/w500${e.profilePath}'
                    : 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg',
                department: e.department,
                job: e.job))
            .toList(),
        genreIds: movieDB.genres.map((e) => e.name).toList(),
        id: movieDB.id,
        inProduction: movieDB.inProduction,
        numberOfEpisodes: movieDB.numberOfEpisodes,
        numberOfSeasons: movieDB.numberOfSeasons,
        originalLanguage: movieDB.originalLanguage,
        originalName: movieDB.originalName,
        overview: movieDB.overview,
        popularity: movieDB.popularity,
        posterPath: (movieDB.posterPath != '')
            ? 'https://image.tmdb.org/t/p/w500${movieDB.posterPath}'
            : 'https://st2.depositphotos.com/1000434/10200/i/450/depositphotos_102007848-stock-photo-grunge-background-with-filmstrip.jpg',
        status: movieDB.status,
        seasons: movieDB.seasons
            .map((season) => entity_season.Season(
                airDate: season.airDate,
                episodeCount: season.episodeCount,
                id: season.id,
                name: season.name,
                overview: season.overview,
                posterPath: (season.posterPath != '')
                    ? 'https://image.tmdb.org/t/p/w500${season.posterPath}'
                    : ((movieDB.posterPath != '')
                        ? 'https://image.tmdb.org/t/p/w500${movieDB.posterPath}'
                        : 'https://st2.depositphotos.com/1000434/10200/i/450/depositphotos_102007848-stock-photo-grunge-background-with-filmstrip.jpg'),
                seasonNumber: season.seasonNumber,
                voteAverage: season.voteAverage,
                episodes: []))
            .toList(),
        voteAverage: movieDB.voteAverage,
        voteCount: movieDB.voteCount,
        name: movieDB.name,
        firstAirDate: movieDB.firstAirDate,
        lastAirDate: movieDB.lastAirDate,
        productionCompanies: movieDB.productionCompanies
            .map((comp) =>
                WatchProvider(providerId: comp.id, providerName: comp.name, logoPath: (comp.logoPath != null && comp.logoPath != "") ? 'https://image.tmdb.org/t/p/w500${comp.logoPath}' : 'no-logo'))
            .toList(),
        tagline: movieDB.tagline,
        type: movieDB.type,
      );
}
