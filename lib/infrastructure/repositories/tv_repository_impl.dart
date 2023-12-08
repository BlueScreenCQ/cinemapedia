import 'package:cinemapedia/domain/datasources/tv_datasource.dart';
import 'package:cinemapedia/domain/entities/episode.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/tv.dart';
import 'package:cinemapedia/domain/entities/watch_provider.dart';
import 'package:cinemapedia/domain/repositories/tv_repository.dart';

class TVRepositoryImpl extends TVRepository {
  final TVDatasource datasource;
  TVRepositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getAiringToday({int page = 1}) {
    return datasource.getAiringToday(page: page);
  }

  @override
  Future<List<Movie>> getTrendingTv({int page = 1}) {
    return datasource.getTrendingTv(page: page);
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

  @override
  Future<List<Movie>> searchTV(String query) {
    return datasource.searchTV(query);
  }

  @override
  Future<Map<String, List<WatchProvider>>> getTvWatchProviderById(String tvId) {
    return datasource.getTvWatchProviderById(tvId);
  }

  @override
  Future<List<Episode>> getSeasonById(String tvId, int seasonNumber) {
    return datasource.getSeasonById(tvId, seasonNumber);
  }
}
