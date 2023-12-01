import 'package:cinemapedia/domain/datasources/tv_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/tv.dart';

class TVRepositoryImpl extends TVDatasource {
  final TVDatasource datasource;
  TVRepositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getAiringToday({int page = 1}) {
    return datasource.getAiringToday(page: page);
  }

  @override
  Future<List<Movie>> getOnTheAir({int page = 1}) {
    return datasource.getOnTheAir(page: page);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) {
    return datasource.getPopular(page: page);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) {
    return datasource.getTopRated(page: page);
  }

  @override
  Future<TV> getTvById(String id) {
    return datasource.getTvById(id);
  }

  // @override
  // Future<List<Movie>> searchMovies(String query) {
  //   return datasource.searchMovies(query);
  // }

  // @override
  // Future<List<Movie>> getSimilarMovies(int movieId) {
  //   return datasource.getSimilarMovies(movieId);
  // }

  // @override
  // Future<List<Video>> getYoutubeVideosById(int movieId) {
  //   return datasource.getYoutubeVideosById(movieId);
  // }

  // @override
  // Future<Map<String, List<WatchProvider>>> getWatchProviderById(String movieId) {
  //   return datasource.getWatchProviderById(movieId);
  // }
}
