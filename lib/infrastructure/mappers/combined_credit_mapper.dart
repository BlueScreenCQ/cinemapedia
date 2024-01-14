import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/combined_credits_response.dart';

class CombinedCreditMapper {
  static Movie moviedbCastCreditToEntity(Cast cast) => Movie(
      adult: cast.adult,
      backdropPath: (cast.backdropPath != '')
          ? 'https://image.tmdb.org/t/p/w500${cast.backdropPath}'
          : 'https://st2.depositphotos.com/1000434/10200/i/450/depositphotos_102007848-stock-photo-grunge-background-with-filmstrip.jpg',
      genreIds: cast.genreIds.map((e) => e.toString()).toList(),
      id: cast.id,
      originalLanguage: cast.originalLanguage,
      originalTitle: cast.originalTitle,
      overview: cast.overview,
      popularity: cast.popularity,
      posterPath: (cast.posterPath != '')
          ? 'https://image.tmdb.org/t/p/w500${cast.posterPath}'
          : 'https://w7.pngwing.com/pngs/584/468/png-transparent-graphic-film-movie-camera-camera-photography-logo-monochrome.png',
      releaseDate: cast.releaseDate,
      title: cast.title,
      video: cast.video,
      voteAverage: cast.voteAverage,
      voteCount: cast.voteCount,
      mediaType: cast.mediaType,
      firstAirDate: cast.firstAirDate,
      // episodeCount: cast.episodeCount,
      character: cast.character,
      name: cast.name);

  static Movie moviedbCrewCreditToEntity(Cast crew) => Movie(
      adult: crew.adult,
      backdropPath: (crew.backdropPath != '')
          ? 'https://image.tmdb.org/t/p/w500${crew.backdropPath}'
          : 'https://st2.depositphotos.com/1000434/10200/i/450/depositphotos_102007848-stock-photo-grunge-background-with-filmstrip.jpg',
      genreIds: crew.genreIds.map((e) => e.toString()).toList(),
      id: crew.id,
      originalLanguage: crew.originalLanguage,
      originalTitle: crew.originalTitle,
      overview: crew.overview,
      popularity: crew.popularity,
      posterPath: (crew.posterPath != '')
          ? 'https://image.tmdb.org/t/p/w500${crew.posterPath}'
          : 'https://w7.pngwing.com/pngs/584/468/png-transparent-graphic-film-movie-camera-camera-photography-logo-monochrome.png',
      releaseDate: crew.releaseDate,
      title: crew.title,
      video: crew.video,
      voteAverage: crew.voteAverage,
      voteCount: crew.voteCount,
      mediaType: crew.mediaType,
      firstAirDate: crew.firstAirDate,
      // episodeCount: crew.episodeCount,
      department: crew.department,
      job: crew.job,
      name: crew.name);
}
