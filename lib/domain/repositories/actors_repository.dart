import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

abstract class ActorRepository {
  Future<Map<String, List<dynamic>>> getActorsByMovie(String movieId);
  Future<Map<String, List<dynamic>>> getActorsByTV(String tvId);
  Future<Actor> getActorById(String id);
  Future<Map<String, List<Movie>>> getCombinedCreditsOfActor(String id);
}
