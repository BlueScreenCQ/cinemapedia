import 'package:cinemapedia/domain/datasources/tv_datasource.dart';
import 'package:cinemapedia/domain/entities/tv.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/mappers/tv_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/tv_details_moviedb.dart';
import 'package:dio/dio.dart';
import 'package:cinemapedia/config/constants/envirovement.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

class TVMoviedbDatasource extends TVDatasource {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/', queryParameters: {'api_key': Envirovement.theMovieDBKey, 'language': 'es-ES'}));

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final movieDbResponse = MovieDbResponse.fromJson(json);

    final List<Movie> movies = movieDbResponse.results.where((moviedb) => moviedb.posterPath != 'no-`poster').map((moviedb) => MovieMapper.moviedbToEntity(moviedb)).toList();

    return movies;
  }

  // List<Movie> removeOldMoivies(List<Movie> upcoming) {
  //   List<Movie> cleanUpcoming = [];

  //   for (Movie movie in upcoming) {
  //     if (movie.releaseDate != null && movie.releaseDate!.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
  //       cleanUpcoming.add(movie);
  //     }
  //   }
  //   return cleanUpcoming;
  // }

  //https://developer.themoviedb.org/reference/tv-series-airing-today-list

  @override
  Future<List<Movie>> getAiringToday({int page = 1}) async {
    final response = await dio.get('/tv/airing_today', queryParameters: {'page': page, 'timezone': 'ES'});

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTrendingTv({int page = 1}) async {
    final response = await dio.get('trending/tv/day', queryParameters: {'page': page, 'timezone': 'ES'});

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get('/tv/top_rated', queryParameters: {'page': page});

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await dio.get('/tv/popular', queryParameters: {'page': page});

    return _jsonToMovies(response.data);
  }

  @override
  Future<TV> getTvById(String id) async {
    final response = await dio.get('/tv/$id');

    if (response.statusCode != 200) {
      throw Exception('Tv show with id $id not found');
    }

    final tvDetails = TvResponse.fromJson(response.data);

    final tv = TVMapper.tvfromMovieDBToEntity(tvDetails);
    return tv;
  }

  @override
  Future<List<Movie>> searchTV(String query) async {
    if (query.isEmpty) return [];

    final response = await dio.get('/search/tv', queryParameters: {'query': query});
    return _jsonToMovies(response.data);
  }

  // @override
  // Future<List<Movie>> getSimilarMovies(int movieId) async {
  //   final response = await dio.get('/movie/$movieId/similar');
  //   return _jsonToMovies(response.data);
  // }

  // @override
  // Future<List<Video>> getYoutubeVideosById(int movieId) async {
  //   final response = await dio.get('/movie/$movieId/videos');
  //   final moviedbVideosReponse = MoviedbVideosResponse.fromJson(response.data);
  //   final videos = <Video>[];

  //   for (final moviedbVideo in moviedbVideosReponse.results) {
  //     if (moviedbVideo.site == 'YouTube') {
  //       final video = VideoMapper.moviedbVideoToEntity(moviedbVideo);
  //       videos.add(video);
  //     }
  //   }

  //   return videos;
  // }

  // @override
  // Future<Map<String, List<WatchProvider>>> getWatchProviderById(String movieId) async {
  //   final response = await dio.get('/movie/$movieId/watch/providers');

  //   // print('Esta es la respuesta');
  //   // print(movieId);
  //   // print(response.data['results']['ES']['link']);

  //   // response.data['results']['ES']['link'] = response.data['id'];

  //   final WatchProvidersResponse moviedbProvidersReponse = WatchProvidersResponse.fromJson(response.data['results']['ES']);

  //   Map<String, List<WatchProvider>> watchProviders = {};

  //   watchProviders[movieId] = WatchProviderMapper.watchProviderToEntity(moviedbProvidersReponse);

  //   return watchProviders;
  // }
}
