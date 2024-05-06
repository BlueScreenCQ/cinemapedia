import 'package:cinemapedia/infrastructure/models/moviedb/request_token_model.dart';

abstract class AuthenticationDataSource {
  Future<RequestTokenModel> getRequestToken();

  Future<RequestTokenModel> validateWithLogin(Map<String, dynamic> requestBody);

  Future<String> createSession(Map<String, dynamic> requestBody);
}
