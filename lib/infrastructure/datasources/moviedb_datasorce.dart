import 'package:cinemapedia/domain/entities/movie_collection.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/domain/entities/watch_provider.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_collection_mapper.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/mappers/video_mapper.dart';
import 'package:cinemapedia/infrastructure/mappers/watch_provider_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details_moviedb.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_videos.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/providers_reponse.dart';
import 'package:dio/dio.dart';
import 'package:cinemapedia/config/constants/envirovement.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

class MoviedbDatasource extends MovieDatasource {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/', queryParameters: {'api_key': Envirovement.theMovieDBKey, 'language': 'es-ES'}));

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final movieDbResponse = MovieDbResponse.fromJson(json);

    final List<Movie> movies = movieDbResponse.results.where((moviedb) => moviedb.posterPath != 'no-poster').map((moviedb) => MovieMapper.moviedbToEntity(moviedb)).toList();

    return movies;
  }

  List<Movie> removeOldMoivies(List<Movie> upcoming) {
    List<Movie> cleanUpcoming = [];

    for (Movie movie in upcoming) {
      if (movie.releaseDate != null && movie.releaseDate!.isAfter(DateTime.now())) {
        cleanUpcoming.add(movie);
      }
    }
    return cleanUpcoming;
  }

  List<Movie> orderMovies(List<Movie> movies) {
    movies.sort((a, b) {
      if (a.releaseDate != null && b.releaseDate != null) {
        return b.releaseDate!.compareTo(a.releaseDate!);
      }

      return 0;
    });
    // movies.reversed.toList();

    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing', queryParameters: {'page': page});

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTrending({int page = 1}) async {
    final response = await dio.get('trending/movie/day', queryParameters: {'page': page});

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get('/movie/top_rated', queryParameters: {'page': page});

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get('/movie/upcoming', queryParameters: {'page': page});
    List<Movie> upcomingMovies = _jsonToMovies(response.data);

    //Eliminamos las pelis ya estrenadas de la lista de Upcoming
    upcomingMovies = removeOldMoivies(upcomingMovies);

    return upcomingMovies;
  }

  @override
  Future<Movie> getMovieById(String id) async {
    final response = await dio.get('/movie/$id');

    if (response.statusCode != 200) {
      throw Exception('Movie with id $id not found');
    }

    final movieDetails = MovieDetails.fromJson(response.data);

    final movie = MovieMapper.movieDetailsToEntity(movieDetails);
    return movie;
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return [];

    final response = await dio.get('/search/movie', queryParameters: {'query': query});
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getSimilarMovies(int movieId) async {
    final response = await dio.get('/movie/$movieId/recommendations');

    List<Movie> movies = _jsonToMovies(response.data);

    orderMovies(movies);

    return movies;
  }

  @override
  Future<List<Video>> getYoutubeVideosById(int movieId) async {
    final response = await dio.get('/movie/$movieId/videos');
    final moviedbVideosReponse = MoviedbVideosResponse.fromJson(response.data);
    final videos = <Video>[];

    for (final moviedbVideo in moviedbVideosReponse.results) {
      if (moviedbVideo.site == 'YouTube') {
        final video = VideoMapper.moviedbVideoToEntity(moviedbVideo);
        videos.add(video);
      }
    }

    return videos;
  }

  @override
  Future<Map<String, Map<String, List<WatchProvider>>>> getWatchProviderById(String movieId) async {
    final response = await dio.get('/movie/$movieId/watch/providers');

    // print('Esta es la respuesta');
    // print(movieId);
    // print(response.data['results']['ES']['link']);

    // response.data['results']['ES']['link'] = response.data['id'];

    final WatchProvidersResponse moviedbProvidersReponse = WatchProvidersResponse.fromJson(response.data['results']['ES']);

    Map<String, Map<String, List<WatchProvider>>> watchProviders = {};

    watchProviders[movieId] = WatchProviderMapper.watchProviderToEntity(moviedbProvidersReponse);

    return watchProviders;
  }

  @override
  Future<MovieCollection> getMovieCollectionById(String collectionId) async {
    final response = await dio.get('/collection/$collectionId');

    if (response.statusCode != 200) {
      throw Exception('Collection with id $collectionId not found');
    }

    final collectionDetails = MovieDBCollection.fromJson(response.data);

    final collection = MovieCollectionMapper.movieCollectionToEntity(collectionDetails);
    return collection;
  }
}
