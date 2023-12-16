import 'package:cinemapedia/domain/datasources/actor_datasoruce.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/actors_repository.dart';

class ActorRepositoryImp extends ActorRepository {
  final ActorDatasource datasource;

  ActorRepositoryImp(this.datasource);

  @override
  Future<Map<String, List<dynamic>>> getActorsByMovie(String movieId) async {
    return datasource.getActorsByMovie(movieId);
  }

  @override
  Future<Map<String, List<dynamic>>> getActorsByTV(String tvId) async {
    return datasource.getActorsByTV(tvId);
  }

  @override
  Future<Actor> getActorById(String id) {
    return datasource.getActorById(id);
  }

  @override
  Future<Map<String, List<Movie>>> getCombinedCreditsOfActor(String id) {
    return datasource.getCombinedCreditsOfActor(id);
  }
}
