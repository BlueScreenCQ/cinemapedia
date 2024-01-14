import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/movie_collection.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/domain/entities/watch_provider.dart';

abstract class MovieDatasource {
  Future<List<Movie>> getNowPlaying({int page = 1});

  Future<List<Movie>> getTrending({int page = 1});

  Future<List<Movie>> getUpcoming({int page = 1});

  Future<List<Movie>> getTopRated({int page = 1});

  Future<Movie> getMovieById(String id);

  Future<List<Movie>> searchMovies(String query);

  Future<List<Movie>> getSimilarMovies(int movieId);

  Future<List<Video>> getYoutubeVideosById(int movieId);

  Future<Map<String, Map<String, List<WatchProvider>>>> getWatchProviderById(String movieId);

  Future<MovieCollection> getMovieCollectionById(String collectionId);
}
