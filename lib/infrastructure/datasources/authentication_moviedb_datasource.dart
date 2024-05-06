import 'package:cinemapedia/config/constants/envirovement.dart';
import 'package:cinemapedia/domain/datasources/authentication_datasource.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/request_token_model.dart';
import 'package:dio/dio.dart';

class AuthenticationMovieDBDataSource extends AuthenticationDataSource {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/', queryParameters: {'api_key': Envirovement.theMovieDBKey, 'language': 'es-ES'}));

  @override
  Future<RequestTokenModel> getRequestToken() async {
    final response = await dio.get('authentication/token/new');
    print(response);
    final requestTokenModel = RequestTokenModel.fromJson(response.data);
    return requestTokenModel;
  }

  @override
  Future<RequestTokenModel> validateWithLogin(Map<String, dynamic> requestBody) async {
    final response = await dio.post(
      'authentication/token/validate_with_login',
      queryParameters: requestBody,
    );
    print(response);
    return RequestTokenModel.fromJson(response.data);
  }

  @override
  Future<String> createSession(Map<String, dynamic> requestBody) async {
    final response = await dio.post(
      'authentication/session/new',
      queryParameters: requestBody,
    );
    print(response);
    return response.data['success'] ? response.data['session_id'] : null;
  }
}
