import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/watch_provider.dart';
import 'package:cinemapedia/domain/entities/movie_collection.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details_moviedb.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieMapper {
  static Movie moviedbToEntity(MovieMovieDB movieDB) => Movie(
      adult: movieDB.adult,
      backdropPath: (movieDB.backdropPath != '')
          ? 'https://image.tmdb.org/t/p/w500${movieDB.backdropPath}'
          : 'https://st2.depositphotos.com/1000434/10200/i/450/depositphotos_102007848-stock-photo-grunge-background-with-filmstrip.jpg',
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
      backdropPath: (movieDetails.backdropPath != '')
          ? 'https://image.tmdb.org/t/p/w500${movieDetails.backdropPath}'
          : 'https://st2.depositphotos.com/1000434/10200/i/450/depositphotos_102007848-stock-photo-grunge-background-with-filmstrip.jpg',
      belongsToCollection: (movieDetails.belongsToCollection != null)
          ? MovieCollection(
              id: movieDetails.belongsToCollection!.id,
              name: movieDetails.belongsToCollection!.name,
              posterPath: 'https://image.tmdb.org/t/p/w500${movieDetails.belongsToCollection!.posterPath}',
              backdropPath: 'https://image.tmdb.org/t/p/w500${movieDetails.belongsToCollection!.backdropPath}',
              overview: '',
              parts: [])
          : null,
      budget: movieDetails.budget,
      genreIds: movieDetails.genres.map((e) => e.name).toList(),
      id: movieDetails.id,
      imdbId: movieDetails.imdbId,
      originalLanguage: movieDetails.originalLanguage,
      originalTitle: movieDetails.originalTitle,
      overview: movieDetails.overview,
      popularity: movieDetails.popularity,
      posterPath: (movieDetails.posterPath != '')
          ? 'https://image.tmdb.org/t/p/w500${movieDetails.posterPath}'
          : 'https://st2.depositphotos.com/1000434/10200/i/450/depositphotos_102007848-stock-photo-grunge-background-with-filmstrip.jpg',
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
