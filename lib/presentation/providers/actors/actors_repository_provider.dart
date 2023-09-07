import 'package:cinemapedia/infrastructure/datasources/actor_moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/actor_repository_imp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Este provider es inmutable
final actorsRepositoryProvider = Provider((ref) {
  return ActorRepositoryImp(ActorMovieDbDatasource());
});