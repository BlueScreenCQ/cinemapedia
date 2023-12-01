import 'package:cinemapedia/domain/entities/crew.dart';
import 'package:cinemapedia/domain/entities/tv.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/tv_details_moviedb.dart';

class TVMapper {
  static TV tvfromMovieDBToEntity(TvResponse movieDB) => TV(
        adult: movieDB.adult,
        backdropPath: (movieDB.backdropPath != '') ? 'https://image.tmdb.org/t/p/w500${movieDB.backdropPath}' : 'https://sd.keepcalms.com/i/keep-calm-poster-not-found.png',
        createdBy: movieDB.createdBy.map((e) => Crew(id: e.id, name: e.name, profilePath: e.profilePath, department: e.department, job: e.job)).toList(),
        genreIds: movieDB.genres.map((e) => e.name).toList(),
        id: movieDB.id,
        inProduction: movieDB.inProduction,
        numberOfEpisodes: movieDB.numberOfEpisodes,
        numberOfSeasons: movieDB.numberOfSeasons,
        originalLanguage: movieDB.originalLanguage,
        originalName: movieDB.originalName,
        overview: movieDB.overview,
        popularity: movieDB.popularity,
        posterPath: (movieDB.posterPath != '') ? 'https://image.tmdb.org/t/p/w500${movieDB.posterPath}' : 'https://sd.keepcalms.com/i/keep-calm-poster-not-found.png',
        status: movieDB.status,
        voteAverage: movieDB.voteAverage,
        voteCount: movieDB.voteCount,
        name: movieDB.name,
        firstAirDate: movieDB.firstAirDate,
        lastAirDate: movieDB.lastAirDate,
      );
}
