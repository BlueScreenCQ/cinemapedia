import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_collection.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details_moviedb.dart';

class MovieCollectionMapper {
  static MovieCollection movieCollectionToEntity(MovieDBCollection movieDB) => MovieCollection(
      id: movieDB.id,
      name: movieDB.name,
      posterPath: (movieDB.posterPath != '')
          ? 'https://image.tmdb.org/t/p/w500${movieDB.posterPath}'
          : 'https://w7.pngwing.com/pngs/584/468/png-transparent-graphic-film-movie-camera-camera-photography-logo-monochrome.png',
      backdropPath: (movieDB.backdropPath != '')
          ? 'https://image.tmdb.org/t/p/w500${movieDB.backdropPath}'
          : 'https://st2.depositphotos.com/1000434/10200/i/450/depositphotos_102007848-stock-photo-grunge-background-with-filmstrip.jpg',
      overview: movieDB.overview,
      parts: movieDB.parts!
          .map((movie) => Movie(
              adult: movie.adult,
              backdropPath: (movie.backdropPath != '')
                  ? 'https://image.tmdb.org/t/p/w500${movie.backdropPath}'
                  : 'https://st2.depositphotos.com/1000434/10200/i/450/depositphotos_102007848-stock-photo-grunge-background-with-filmstrip.jpg',
              id: movie.id,
              genreIds: movie.genreIds.map((e) => e.toString()).toList(),
              originalLanguage: movie.originalLanguage,
              originalTitle: movie.originalTitle,
              overview: movie.overview,
              popularity: movie.popularity,
              posterPath: (movie.posterPath != '')
                  ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
                  : 'https://w7.pngwing.com/pngs/584/468/png-transparent-graphic-film-movie-camera-camera-photography-logo-monochrome.png',
              title: movie.title,
              video: movie.video,
              voteAverage: movie.voteAverage,
              voteCount: movie.voteCount,
              releaseDate: movie.releaseDate))
          .toList());
}
