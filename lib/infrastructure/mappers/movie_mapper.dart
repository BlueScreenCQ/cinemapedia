import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/watch_provider.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details_moviedb.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieMapper {
  static Movie moviedbToEntity(MovieMovieDB movieDB) => Movie(
      adult: movieDB.adult,
      backdropPath: (movieDB.backdropPath != '') ? 'https://image.tmdb.org/t/p/w500${movieDB.backdropPath}' : 'https://sd.keepcalms.com/i/keep-calm-poster-not-found.png',
      genreIds: movieDB.genreIds.map((e) => e.toString()).toList(),
      id: movieDB.id,
      originalLanguage: movieDB.originalLanguage,
      originalTitle: movieDB.originalTitle,
      overview: movieDB.overview,
      popularity: movieDB.popularity,
      posterPath: (movieDB.posterPath != '')
          ? 'https://image.tmdb.org/t/p/w500${movieDB.posterPath}'
          : 'https://w7.pngwing.com/pngs/584/468/png-transparent-graphic-film-movie-camera-camera-photography-logo-monochrome.png',
      releaseDate: movieDB.releaseDate,
      title: movieDB.title,
      name: movieDB.name,
      video: movieDB.video,
      voteAverage: movieDB.voteAverage,
      voteCount: movieDB.voteCount);

  static Movie movieDetailsToEntity(MovieDetails movieDetails) => Movie(
      adult: movieDetails.adult,
      backdropPath: (movieDetails.backdropPath != '') ? 'https://image.tmdb.org/t/p/w500${movieDetails.backdropPath}' : 'https://sd.keepcalms.com/i/keep-calm-poster-not-found.png',
      // belongsToCollection: movieDetails.belongsToCollection,
      budget: movieDetails.budget,
      genreIds: movieDetails.genres.map((e) => e.name).toList(),
      id: movieDetails.id,
      imdbId: movieDetails.imdbId,
      originalLanguage: movieDetails.originalLanguage,
      originalTitle: movieDetails.originalTitle,
      overview: movieDetails.overview,
      popularity: movieDetails.popularity,
      posterPath: (movieDetails.posterPath != '') ? 'https://image.tmdb.org/t/p/w500${movieDetails.posterPath}' : 'https://sd.keepcalms.com/i/keep-calm-poster-not-found.png',
      releaseDate: movieDetails.releaseDate,
      revenue: movieDetails.revenue,
      runtime: movieDetails.runtime,
      status: movieDetails.status,
      title: movieDetails.title,
      productionCompanies: movieDetails.productionCompanies
          .map((comp) =>
              WatchProvider(providerId: comp.id, providerName: comp.name, logoPath: (comp.logoPath != null && comp.logoPath != "") ? 'https://image.tmdb.org/t/p/w500${comp.logoPath}' : 'no-logo'))
          .toList(),
      tagline: movieDetails.tagline,
      video: movieDetails.video,
      voteAverage: movieDetails.voteAverage,
      voteCount: movieDetails.voteCount);
}
