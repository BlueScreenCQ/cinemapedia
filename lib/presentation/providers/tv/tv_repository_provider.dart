import 'package:cinemapedia/infrastructure/datasources/tv_moviedb_datasorce.dart';
import 'package:cinemapedia/infrastructure/repositories/tv_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Este provider es inmutable
final tvRepositoryProvider = Provider((ref) {
  return TVRepositoryImpl(TVMoviedbDatasource());
});
