
abstract class ActorRepository {

  Future<Map<String, List<dynamic>>> getActorsByMovie(String movieId);

}