import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details_moviedb.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieMapper {
  static Movie moviedbToEntity(MovieMovieDB movieDB) => Movie(
      adult: movieDB.adult,
      backdropPath: (movieDB.backdropPath != '') 
      ? 'https://image.tmdb.org/t/p/w500${ movieDB.backdropPath }'
      : 'https://sd.keepcalms.com/i/keep-calm-poster-not-found.png',
      genreIds: movieDB.genreIds.map((e) => e.toString()).toList(),
      id: movieDB.id,
      originalLanguage: movieDB.originalLanguage,
      originalTitle: movieDB.originalTitle,
      overview: movieDB.overview,
      popularity: movieDB.popularity,
      posterPath: (movieDB.posterPath != '') 
      ? 'https://image.tmdb.org/t/p/w500${ movieDB.posterPath }'
      : 'https://w7.pngwing.com/pngs/584/468/png-transparent-graphic-film-movie-camera-camera-photography-logo-monochrome.png',
      releaseDate: movieDB.releaseDate,
      title: movieDB.title,
      video: movieDB.video,
      voteAverage: movieDB.voteAverage,
      voteCount: movieDB.voteCount);


      static Movie movieDetailsToEntity(MovieDetails movieDetails) => Movie(
      adult: movieDetails.adult,
      backdropPath: (movieDetails.backdropPath != '') 
      ? 'https://image.tmdb.org/t/p/w500${ movieDetails.backdropPath }'
      : 'https://sd.keepcalms.com/i/keep-calm-poster-not-found.png',
      genreIds: movieDetails.genres.map((e) => e.name).toList(),
      id: movieDetails.id,
      originalLanguage: movieDetails.originalLanguage,
      originalTitle: movieDetails.originalTitle,
      overview: movieDetails.overview,
      popularity: movieDetails.popularity,
      posterPath: (movieDetails.posterPath != '') 
      ? 'https://image.tmdb.org/t/p/w500${ movieDetails.posterPath }'
      : 'https://sd.keepcalms.com/i/keep-calm-poster-not-found.png',
      releaseDate: movieDetails.releaseDate,
      title: movieDetails.title,
      video: movieDetails.video,
      voteAverage: movieDetails.voteAverage,
      voteCount: movieDetails.voteCount);
}
