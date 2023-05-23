import 'package:dio/dio.dart';
import 'package:cinemapedia/config/constants/envirovement.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

class MoviedbDatasource extends  MovieDatasource{
  
  final dio = Dio(BaseOptions(
    baseUrl:'https://api.themoviedb.org/3/',
    queryParameters: {
      'api_key' : Envirovement.theMovieDBKey,
      'language' : 'es-ES'
    }
    ));
  
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    
    final List<Movie> movies = [];

    final response = dio.get('/movie/now_playing?');

    return [];
  }

}