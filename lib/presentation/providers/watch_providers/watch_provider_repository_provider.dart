import 'package:cinemapedia/infrastructure/datasources/moviedb_datasorce.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Este provider es inmutable
final watchProviderRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl((MoviedbDatasource()));
});
