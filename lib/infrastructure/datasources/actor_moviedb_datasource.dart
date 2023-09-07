

import 'package:cinemapedia/config/constants/envirovement.dart';
import 'package:cinemapedia/domain/datasources/actor_datasoruce.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/crew.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/mappers/crew_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorMovieDbDatasource extends ActorDatasource{

  final dio = Dio(BaseOptions(
    baseUrl:'https://api.themoviedb.org/3/',
    queryParameters: {
      'api_key' : Envirovement.theMovieDBKey,
      'language' : 'es-ES'
    }
    ));

  @override
  Future<Map<String, List<dynamic>>> getActorsByMovie(String movieId) async {
   
    final response = await dio.get('/movie/$movieId/credits');
  
    final castResponse = CreditsResponse.fromJson(response.data);

    List<Actor> actors = castResponse.cast.map((actor) => ActorMapper.castToEntity(actor)).toList();

    List<Crew> crew = castResponse.crew.map((crew) => CrewMapper.castToEntity(crew)).toList();

    Map<String, List<dynamic>> elenco = <String, List<dynamic>>{'Actors': actors, 'Crew' : crew};

    return elenco;
  }

}