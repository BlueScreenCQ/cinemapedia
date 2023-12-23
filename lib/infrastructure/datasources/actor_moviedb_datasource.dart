import 'package:cinemapedia/config/constants/envirovement.dart';
import 'package:cinemapedia/domain/datasources/actor_datasoruce.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/crew.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/mappers/combined_credit_mapper.dart';
import 'package:cinemapedia/infrastructure/mappers/crew_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/actors_moviedb_response.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/combined_credits_response.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_person_response.dart';
import 'package:dio/dio.dart';

class ActorMovieDbDatasource extends ActorDatasource {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/', queryParameters: {'api_key': Envirovement.theMovieDBKey, 'language': 'es-ES'}));

  @override
  Future<Map<String, List<dynamic>>> getActorsByMovie(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits');

    final castResponse = CreditsResponse.fromJson(response.data);

    List<Actor> actors = castResponse.cast.map((actor) => ActorMapper.castToEntity(actor)).toList();

    List<Crew> crew = castResponse.crew.map((crew) => CrewMapper.castToEntity(crew)).toList();

    Map<String, List<dynamic>> elenco = <String, List<dynamic>>{'Actors': actors, 'Crew': crew};

    return elenco;
  }

  @override
  Future<Map<String, List<dynamic>>> getActorsByTV(String tvId) async {
    final response = await dio.get('/tv/$tvId/credits');

    final castResponse = CreditsResponse.fromJson(response.data);

    List<Actor> actors = castResponse.cast.map((actor) => ActorMapper.castToEntity(actor)).toList();

    List<Crew> crew = castResponse.crew.map((crew) => CrewMapper.castToEntity(crew)).toList();

    Map<String, List<dynamic>> elenco = <String, List<dynamic>>{'Actors': actors, 'Crew': crew};

    return elenco;
  }

  @override
  Future<Actor> getActorById(String id) async {
    final response = await dio.get('/person/$id');

    Person personResponse = Person.fromJson(response.data);

    Actor actor = ActorMapper.personToEntity(personResponse);

    return actor;
  }

  @override
  Future<Map<String, List<Movie>>> getCombinedCreditsOfActor(String id) async {
    final response = await dio.get('/person/$id//combined_credits');

    CombinedCreditsResponse creditsResponse = CombinedCreditsResponse.fromJson(response.data);

    List<Movie> cast = creditsResponse.cast.map((c) => CombinedCreditMapper.moviedbCastCreditToEntity(c)).toList();
    List<Movie> crew = creditsResponse.crew.map((c) => CombinedCreditMapper.moviedbCrewCreditToEntity(c)).toList();

    Map<String, List<Movie>> combinedCredits = <String, List<Movie>>{'Cast': cast, 'Crew': crew};

    return combinedCredits;
  }

  @override
  Future<List<Actor>> searchActors(String query) async {
    if (query.isEmpty) return [];

    final response = await dio.get('/search/person', queryParameters: {'query': query});

    final castResponse = ActorsMovieDbResponse.fromJson(response.data);

    List<Actor> actors = castResponse.results.map((actor) => ActorMapper.castToEntity(actor)).toList();

    return actors;
  }
}
