import 'package:cinemapedia/domain/datasources/actor_datasoruce.dart';
import 'package:cinemapedia/domain/repositories/actors_repository.dart';

class ActorRepositoryImp extends ActorRepository {

  final ActorDatasource datasource;

  ActorRepositoryImp(this.datasource);
  
  @override
  Future<Map<String, List<dynamic>>> getActorsByMovie(String movieId) async {
    
    return datasource.getActorsByMovie(movieId);
  }


}