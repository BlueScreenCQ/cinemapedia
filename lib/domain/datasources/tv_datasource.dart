import 'package:cinemapedia/domain/entities/episode.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/tv.dart';
import 'package:cinemapedia/domain/entities/watch_provider.dart';
// import 'package:cinemapedia/domain/entities/video.dart';

abstract class TVDatasource {
  Future<List<Movie>> getAiringToday({int page = 1});

  Future<List<Movie>> getTrendingTv({int page = 1});

  Future<List<Movie>> getPopular({int page = 1});

  Future<List<Movie>> getTopRated({int page = 1});

  Future<TV> getTvById(String id);

  Future<List<Movie>> searchTV(String query);

  Future<Map<String, List<WatchProvider>>> getTvWatchProviderById(String tvId);

  Future<List<Episode>> getSeasonById(String tvId, int seasonNumber);

  // Future<List<Movie>> getSimilarMovies(int movieId);

  // Future<List<Video>> getYoutubeVideosById(int movieId);
}
