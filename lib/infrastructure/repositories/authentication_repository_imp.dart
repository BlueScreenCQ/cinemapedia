import 'dart:io';

import 'package:cinemapedia/domain/datasources/authentication_datasource.dart';
import 'package:cinemapedia/domain/datasources/authentication_local_datasource.dart';
import 'package:cinemapedia/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImp extends AuthenticationRepository {
  final AuthenticationDataSource remoteDataSource;
  final AuthenticationLocalDataSource localDataSource;

  AuthenticationRepositoryImp(this.remoteDataSource, this.localDataSource);

  @override
  Future<bool> loginUser(Map<String, dynamic> params) async {
    final requestTokenEitherResponse = await remoteDataSource.getRequestToken();

    final token1 = requestTokenEitherResponse.requestToken;

    try {
      params.putIfAbsent('request_token', () => token1);

      final validateWithLoginToken = await remoteDataSource.validateWithLogin(params);

      final sessionId = await remoteDataSource.createSession(validateWithLoginToken.toJson());

      print(sessionId);

      if (sessionId != null) {
        await localDataSource.saveSessionId(sessionId);
        return true;
      } else {
        return false;
      }
    } on SocketException {
      return false;
    }
  }

  @override
  Future<void> logoutUser() {
    // TODO: implement logoutUser
    throw UnimplementedError();
  }
}
